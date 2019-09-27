(*
  FormulaJIT for MB3D
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
unit ParamValueEditGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TEditMode = (mdEdit, mdNew);

  TParamValueEditFrm = class(TForm)
    Panel1: TPanel;
    CancelAndExitBtn: TButton;
    SaveAndExitBtn: TButton;
    Panel2: TPanel;
    ValueEdit: TEdit;
    Label27: TLabel;
    TypeCmb: TComboBox;
    Label1: TLabel;
    ParamnameEdit: TEdit;
    Label2: TLabel;
    procedure SaveAndExitBtnClick(Sender: TObject);
    procedure CancelAndExitBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure Validate;
    private function GetParamname: String;
    procedure SetParamname(const Paramname: String);
    private function GetValue: Variant;
    procedure SetValue(const Value: Variant);
    private function GetTypeStr: String;
    procedure SetTypeStr(const TypeStr: String);
    procedure SetWindowTitle(const WindowTitle: String);
  public
    { Public declarations }
    procedure Clear(const EditMode: TEditMode);
    property Paramname: String read GetParamname write SetParamname;
    property Value: Variant read GetValue write SetValue;
    property TypeStr: String read GetTypeStr write SetTypeStr;
    property WindowTitle: String write SetWindowTitle;
  end;

var
  ParamValueEditFrm: TParamValueEditFrm;

implementation

{$R *.dfm}
uses
  JITFormulas;

procedure TParamValueEditFrm.Validate;
begin
  if GetParamname = '' then
    raise Exception.Create('Param name must not be empty');
  if GetTypeStr = '' then
    raise Exception.Create('Type must not be empty');
  GetValue;
end;

procedure TParamValueEditFrm.SaveAndExitBtnClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

function TParamValueEditFrm.GetParamname: String;
begin
  Result := Trim( ParamnameEdit.Text );
end;

procedure TParamValueEditFrm.SetParamname(const Paramname: String);
begin
  ParamnameEdit.Text := Paramname;
end;

function TParamValueEditFrm.GetValue: Variant;
begin
  case StrToJITValueDatatype(TypeStr) of
    dtINT64: Result := StrToInt(ValueEdit.Text)
  else
    Result := StrToFloat(ValueEdit.Text);
  end;
end;

procedure TParamValueEditFrm.SetValue(const Value: Variant);
begin
  ValueEdit.Text := FloatToStr(Value);
end;

function TParamValueEditFrm.GetTypeStr: String;
begin
  if TypeCmb.ItemIndex >= 0 then
    Result := TypeCmb.Items[TypeCmb.ItemIndex]
  else
    Result := '';
end;

procedure TParamValueEditFrm.SetTypeStr(const TypeStr: String);
begin
  TypeCmb.ItemIndex := TypeCmb.Items.IndexOf(TypeStr);
end;

procedure TParamValueEditFrm.CancelAndExitBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TParamValueEditFrm.Clear(const EditMode: TEditMode);
begin
  ParamnameEdit.ReadOnly := EditMode = mdEdit;
  ParamnameEdit.Text := '';
  TypeCmb.ItemIndex := TypeCmb.Items.IndexOf('Double');
  ValueEdit.Text := '0';
end;

procedure TParamValueEditFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
    ModalResult := mrCancel;
end;

procedure TParamValueEditFrm.FormShow(Sender: TObject);
begin
  SaveAndExitBtn.SetFocus;
end;

procedure TParamValueEditFrm.SetWindowTitle(const WindowTitle: String);
begin
  Self.Caption := WindowTitle;
end;

end.
