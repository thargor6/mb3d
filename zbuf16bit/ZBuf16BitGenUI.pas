(*
  ZBuf16BitGenerator for MB3D
  Copyright (C) 2020 Andreas Maschke

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
unit ZBuf16BitGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VertexList, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.StdCtrls, VectorMath, Vcl.ComCtrls, JvExExtCtrls,
  JvExtComponent, JvOfficeColorButton, JvExControls, JvColorBox, JvColorButton,
  SpeedButtonEx, ZBuf16BitGen;

type

  TZBuf16BitGenFrm = class(TForm)
    NavigatePnl: TPanel;
    RefreshPreviewBtn: TButton;
    SaveImgBtn: TButton;
    SaveImgDialog: TSaveDialog;
    ZOffsetEdit: TEdit;
    ZOffsetEditUpDown: TUpDown;
    Label2: TLabel;
    ZScaleEdit: TEdit;
    ZScaleEditUpDown: TUpDown;
    Label3: TLabel;
    ScrollBox1: TScrollBox;
    MainPreviewImg: TImage;
    InfoMemo: TMemo;
    InvertZBufferCBx: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ZScaleEditUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure RefreshPreviewBtnClick(Sender: TObject);
    procedure ZOffsetEditUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ZOffsetEditChange(Sender: TObject);
    procedure ZScaleEditChange(Sender: TObject);
    procedure InvertZBufferCBxClick(Sender: TObject);
    procedure SaveImgBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure EnableControls;
    procedure ShowInfo(const PInfo: TPZBufInfo);
  public
    { Public declarations }
  end;

var
  ZBuf16BitGenFrm: TZBuf16BitGenFrm;

implementation

uses
  DivUtils, BulbTracerUITools, Mand;

{$R *.dfm}

procedure TZBuf16BitGenFrm.FormCreate(Sender: TObject);
begin
  SaveImgDialog.InitialDir := Mand3DForm.SaveDialog6.InitialDir;
  EnableControls;
end;

procedure TZBuf16BitGenFrm.InvertZBufferCBxClick(Sender: TObject);
begin
  RefreshPreviewBtnClick(Sender);
end;

procedure TZBuf16BitGenFrm.SaveImgBtnClick(Sender: TObject);
begin
  if SaveImgDialog.Execute then begin
    SaveZBufPNG16(SaveImgDialog.Filename, StrToFloatK(ZBuf16BitGenFrm.ZOffsetEdit.Text), StrToFloatK(ZBuf16BitGenFrm.ZScaleEdit.Text), ZBuf16BitGenFrm.InvertZBufferCBx.Checked);
  end;
end;

procedure TZBuf16BitGenFrm.ShowInfo(const PInfo: TPZBufInfo);
begin
  InfoMemo.Text := 'Raw Values:' + #13#10 +
                       '  ' + FloatToStr(PInfo^.MinRawZValue) + '..' + #13#10 +
                       '  ' + FloatToStr(PInfo^.MaxRawZValue ) + #13#10 +
                   'Mapped Values:' + #13#10 +
                       '  ' + IntToStr(PInfo^.MinZValue) + '..' + #13#10 +
                       '  ' + IntToStr(PInfo^.MaxZValue ) + #13#10 +
                   'Clamped Values:' + #13#10 +
                       '  ' + IntToStr(PInfo^.MinClampedZValue) + '..' + #13#10 +
                       '  ' + IntToStr(PInfo^.MaxClampedZValue ) + #13#10;

end;


procedure TZBuf16BitGenFrm.RefreshPreviewBtnClick(Sender: TObject);
var
  Bmp: TBitmap;
  Info: TZBufInfo;
begin
  Bmp := CreateZBuf16BitPreview( StrToFloatK(ZBuf16BitGenFrm.ZOffsetEdit.Text), StrToFloatK(ZBuf16BitGenFrm.ZScaleEdit.Text), InvertZBufferCBx.Checked, @Info);
  try
    ShowInfo(@Info);
    MainPreviewImg.Picture.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TZBuf16BitGenFrm.ZScaleEditChange(Sender: TObject);
begin
  RefreshPreviewBtnClick(Sender);
end;

procedure TZBuf16BitGenFrm.ZScaleEditUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ZScaleEdit.Text, 0.0) + UpDownBtnValue(Button, 0.01);
  ZScaleEdit.Text := FloatToStr(Value);
  ZScaleEditChange(nil);
end;

procedure TZBuf16BitGenFrm.ZOffsetEditChange(Sender: TObject);
begin
  RefreshPreviewBtnClick(Sender);
end;

procedure TZBuf16BitGenFrm.ZOffsetEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ZOffsetEdit.Text, 0.0) + UpDownBtnValue(Button, 0.01);
  ZOffsetEdit.Text := FloatToStr(Value);
  ZOffsetEditChange(nil);
end;

procedure TZBuf16BitGenFrm.EnableControls;
begin
end;

end.



