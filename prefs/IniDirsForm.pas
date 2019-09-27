unit IniDirsForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TIniDirForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    Edit3: TEdit;
    Button4: TButton;
    Edit4: TEdit;
    Button5: TButton;
    Edit5: TEdit;
    Button6: TButton;
    Button7: TButton;
    Edit6: TEdit;
    Label1: TLabel;
    Button8: TButton;
    Edit7: TEdit;
    Edit8: TEdit;
    Button9: TButton;
    Button10: TButton;
    Edit9: TEdit;
    Button11: TButton;
    Edit10: TEdit;
    Button12: TButton;
    Edit11: TEdit;
    Button13: TButton;
    Edit12: TEdit;
    Button14: TButton;
    Edit13: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    FDir: String;
  public
    { Public-Deklarationen }
  end;

var
  IniDirForm: TIniDirForm;

implementation

{$R *.dfm}

uses DivUtils, FileHandling, Mand, LightAdjust, Animation, FormulaGUI,
  Tiling, VoxelExport, MonteCarloForm, BulbTracer2UI;

procedure TIniDirForm.Button1Click(Sender: TObject);
var i: Integer;
begin
    for i := 0 to high(IniDirs) do
      IniDirs[i] := (FindComponent('Edit' + IntToStr(i + 1)) as TEdit).Text;
    SaveIni(True);
    LoadIni;
    Visible := False;
    if FDir <> IniDirs[3] then FormulaGUIForm.LoadFormulaNames;
end;

procedure TIniDirForm.FormShow(Sender: TObject);
var i: Integer;
begin
    for i := 0 to high(IniDirs) do
      (FindComponent('Edit' + IntToStr(i + 1)) as TEdit).Text := IniDirs[i];
    FDir := IniDirs[3];
end;

procedure TIniDirForm.Button3Click(Sender: TObject);
var t: Integer;
    s: String;
    E: TEdit;
begin
    t := (Sender as TButton).Tag;
    E := FindComponent('Edit' + IntToStr(t + 1)) as TEdit;
    s := E.Text;
    IniDirs[t] := GetDirectory(IniDirs[t], IniDirForm);
    E.Text := IniDirs[t];
    if t = 6 then SetDialogDirectory(LightAdjustForm.OpenDialogPic, IniDirs[6])
 //     LightAdjustForm.OpenDialogPic.InitialDir := IniDirs[6]
    else if t = 7 then
    begin
      SetDialogDirectory(LightAdjustForm.OpenDialog1, IniDirs[7]);
      SetDialogDirectory(LightAdjustForm.SaveDialog1, IniDirs[7]);
  //    LightAdjustForm.OpenDialog1.InitialDir := IniDirs[7];
   //   LightAdjustForm.SaveDialog1.InitialDir := IniDirs[7];
      if s <> E.Text then LightAdjustForm.UpdateQuickLoadCB;
    end
    else if t = 0 then
    begin
      SetDialogDirectory(Mand3DForm.OPD, IniDirs[0]);
      SetDialogDirectory(Mand3DForm.SaveDialog3, IniDirs[0]);
   //   Mand3DForm.OPD.InitialDir := IniDirs[0];
 //     Mand3DForm.SaveDialog3.InitialDir := IniDirs[0];
    end
    else if t = 1 then
    begin
      SetDialogDirectory(Mand3DForm.OpenDialog1, IniDirs[1]);
      SetDialogDirectory(Mand3DForm.SaveDialog2, IniDirs[1]);
      SetDialogDirectory(TilingForm.OpenDialog2, IniDirs[1]);
  {    Mand3DForm.OpenDialog1.InitialDir := IniDirs[1];
      Mand3DForm.SaveDialog2.InitialDir := IniDirs[1];
      TilingForm.OpenDialog2.InitialDir := IniDirs[1];    }
    end
    else if t = 2 then
    begin
      SetDialogDirectory(Mand3DForm.SaveDialog4, IniDirs[2]);
      SetDialogDirectory(Mand3DForm.SaveDialog6, IniDirs[2]);
 //     Mand3DForm.SaveDialog4.InitialDir := IniDirs[2];
  //    Mand3DForm.SaveDialog6.InitialDir := IniDirs[2];
    end
    else if t = 3 then
      SetDialogDirectory(FormulaGUIForm.OpenDialog3, IniDirs[3])
    //  FormulaGUIForm.OpenDialog3.InitialDir := IniDirs[3]
    else if t = 4 then
    begin
      SetDialogDirectory(AnimationForm.SaveDialog1, IniDirs[4]);
      SetDialogDirectory(AnimationForm.OpenDialog4, IniDirs[4]);
 //     AnimationForm.SaveDialog1.InitialDir := IniDirs[4];
   //   AnimationForm.OpenDialog4.InitialDir := IniDirs[4];
    end
{    else if t = 5 then
    begin
      AnimationForm.OpenDialog1.InitialDir := IniDirs[5];
    //  AnimationForm.OutputFolder := IniDirs[5];
    end  }
    else if t = 8 then
    begin
      SetDialogDirectory(TilingForm.OpenDialog1, IniDirs[8]);
      SetDialogDirectory(TilingForm.SaveDialog1, IniDirs[8]);
 //     TilingForm.OpenDialog1.InitialDir := IniDirs[8];
  //    TilingForm.SaveDialog1.InitialDir := IniDirs[8];
    end
    else if t = 10 then
    begin
      SetDialogDirectory(FVoxelExport.OpenDialog4, IniDirs[10]);
      SetDialogDirectory(FVoxelExport.SaveDialog1, IniDirs[10]);
  //    FVoxelExport.OpenDialog4.InitialDir := IniDirs[10];
   //   FVoxelExport.SaveDialog1.InitialDir := IniDirs[10];
      FVoxelExport.OutputFolder := IniDirs[10];
    end
    else if t = 11 then
    begin
      SetDialogDirectory(MCForm.OPDmc, IniDirs[11]);
      SetDialogDirectory(MCForm.SaveDialog3, IniDirs[11]);
  //    MCForm.OPDmc.InitialDir := IniDirs[11];
   //   MCForm.SaveDialog3.InitialDir := IniDirs[11];
    end
    else if t = 12 then
    begin
      SetDialogDirectory(BulbTracer2Frm.SaveDialog, IniDirs[12]);
  //    MCForm.OPDmc.InitialDir := IniDirs[11];
   //   MCForm.SaveDialog3.InitialDir := IniDirs[11];
    end;
end;

end.
