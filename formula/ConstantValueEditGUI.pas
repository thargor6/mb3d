unit ConstantValueEditGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TConstantValueEditFrm = class(TForm)
    Panel1: TPanel;
    CancelAndExitBtn: TButton;
    SaveAndExitBtn: TButton;
    Panel2: TPanel;
    ValueEdit: TEdit;
    Label27: TLabel;
    TypeCmb: TComboBox;
    Label1: TLabel;
    procedure SaveAndExitBtnClick(Sender: TObject);
    procedure CancelAndExitBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure Validate;
    private function GetValue: Variant;
    procedure SetValue(const Value: Variant);
    private function GetTypeStr: String;
    procedure SetTypeStr(const TypeStr: String);
    procedure SetWindowTitle(const WindowTitle: String);
  public
    { Public declarations }
    procedure Clear;
    property Value: Variant read GetValue write SetValue;
    property TypeStr: String read GetTypeStr write SetTypeStr;
    property WindowTitle: String write SetWindowTitle;
  end;

var
  ConstantValueEditFrm: TConstantValueEditFrm;

implementation

{$R *.dfm}
uses
  JITFormulas;

procedure TConstantValueEditFrm.Validate;
begin
  if GetTypeStr = '' then
    raise Exception.Create('Type must not be empty');
  GetValue;
end;

procedure TConstantValueEditFrm.SaveAndExitBtnClick(Sender: TObject);
begin
  Validate;
  ModalResult := mrOK;
end;

function TConstantValueEditFrm.GetValue: Variant;
begin
  case StrToJITValueDatatype(TypeStr) of
    dtINT64: Result := StrToInt(ValueEdit.Text)
  else
    Result := StrToFloat(ValueEdit.Text);
  end;
end;

procedure TConstantValueEditFrm.SetValue(const Value: Variant);
begin
  ValueEdit.Text := FloatToStr(Value);
end;

function TConstantValueEditFrm.GetTypeStr: String;
begin
  if TypeCmb.ItemIndex >= 0 then
    Result := TypeCmb.Items[TypeCmb.ItemIndex]
  else
    Result := '';
end;

procedure TConstantValueEditFrm.SetTypeStr(const TypeStr: String);
begin
  TypeCmb.ItemIndex := TypeCmb.Items.IndexOf(TypeStr);
end;

procedure TConstantValueEditFrm.CancelAndExitBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TConstantValueEditFrm.Clear;
begin
  TypeCmb.ItemIndex := TypeCmb.Items.IndexOf('Double');
  ValueEdit.Text := '0';
end;

procedure TConstantValueEditFrm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    ModalResult := mrCancel;
end;

procedure TConstantValueEditFrm.FormShow(Sender: TObject);
begin
  SaveAndExitBtn.SetFocus;
end;

procedure TConstantValueEditFrm.SetWindowTitle(const WindowTitle: String);
begin
  Self.Caption := WindowTitle;
end;

end.
