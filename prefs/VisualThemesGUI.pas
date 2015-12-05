unit VisualThemesGUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TVisualThemesFrm = class(TForm)
    SaveAndExitBtn: TButton;
    StylesCmb: TComboBox;
    Label1: TLabel;
    DefaultThemeBtn: TButton;
    ThemesOffBtn: TButton;
    procedure SaveAndExitBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DefaultThemeBtnClick(Sender: TObject);
    procedure StylesCmbChange(Sender: TObject);
    procedure ThemesOffBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  VisualThemesFrm: TVisualThemesFrm;

implementation

{$R *.dfm}

uses
  Vcl.Themes, FileHandling;

procedure TVisualThemesFrm.SaveAndExitBtnClick(Sender: TObject);
begin
  SaveIni(True);
  LoadIni;
  Visible := False;
end;

procedure TVisualThemesFrm.StylesCmbChange(Sender: TObject);
begin
  try
    TStyleManager.TrySetStyle(StylesCmb.Items[StylesCmb.ItemIndex]);
  except
    on E: Exception do begin
      if Pos('Focus', E.Message) < 1 then
        raise;
    end;
  end;
end;

procedure TVisualThemesFrm.ThemesOffBtnClick(Sender: TObject);
begin
  StylesCmb.ItemIndex := StylesCmb.Items.IndexOf('Windows');
  StylesCmbChange(Sender);
end;

procedure TVisualThemesFrm.DefaultThemeBtnClick(Sender: TObject);
begin
  StylesCmb.ItemIndex := StylesCmb.Items.IndexOf('Glossy');
  StylesCmbChange(Sender);
end;

procedure TVisualThemesFrm.FormShow(Sender: TObject);
var
  s: String;
begin
  StylesCmb.Items.BeginUpdate;
  try
    StylesCmb.Items.Clear;
    for s in TStyleManager.StyleNames do
       StylesCmb.Items.Add(s);
    StylesCmb.Sorted := True;
    StylesCmb.ItemIndex := StylesCmb.Items.IndexOf(TStyleManager.ActiveStyle.Name);
  finally
    StylesCmb.Items.EndUpdate;
  end;
end;

end.
