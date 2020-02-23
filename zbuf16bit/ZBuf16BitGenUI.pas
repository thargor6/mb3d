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
  SpeedButtonEx;

type

  TZBuf16BitGenFrm = class(TForm)
    NavigatePnl: TPanel;
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
    ResetBtn: TButton;
    ZOffsetEdit: TEdit;
    XOffsetUpDown: TUpDown;
    Label2: TLabel;
    ZScaleEdit: TEdit;
    UpDown1: TUpDown;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
    procedure EnableControls;
  public
    { Public declarations }
  end;

var
  ZBuf16BitGenFrm: TZBuf16BitGenFrm;

implementation

uses
  ZBuf16BitGen;

{$R *.dfm}

procedure TZBuf16BitGenFrm.FormCreate(Sender: TObject);
begin

  EnableControls;
end;


procedure TZBuf16BitGenFrm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  Value: Double;
begin
//  Value := StrToFloatSafe(XOffsetEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
//  XOffsetEdit.Text := FloatToStr(Value);
//  XOffsetEditChange(nil);
end;

procedure TZBuf16BitGenFrm.EnableControls;
begin
end;

end.



