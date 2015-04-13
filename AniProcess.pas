unit AniProcess;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.ComCtrls;

type
  TAniProcessForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label16: TLabel;
    Label18: TLabel;
    Label13: TLabel;
    Edit25: TEdit;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Button5: TButton;
    CheckBox6: TCheckBox;
    Edit1: TEdit;
    Label15: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button6: TButton;
    CheckBox8: TCheckBox;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label5: TLabel;
    Edit4: TEdit;
    CheckBox11: TCheckBox;
    Label6: TLabel;
    Edit5: TEdit;
    CheckBox12: TCheckBox;
    Label7: TLabel;
    Edit6: TEdit;
    CheckBox13: TCheckBox;
    Button7: TButton;
    CheckBox14: TCheckBox;
    CheckBox16: TCheckBox;
    Label22: TLabel;
    Edit7: TEdit;
    CheckBox3: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    Label2: TLabel;
    CheckBox7: TCheckBox;
    Edit2: TEdit;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox21: TCheckBox;
    Bevel5: TBevel;
    Edit21: TEdit;
    UpDown3: TUpDown;
    UpDown1: TUpDown;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    bRerenderPreviewImages: LongBool;
    actKeyFame: Integer;
  end;

var
  AniProcessForm: TAniProcessForm;

implementation

uses Animation, DivUtils, Mand, LightAdjust, TypeDefinitions,
  PostProcessForm, Math, Math3D;

{$R *.dfm}

procedure TAniProcessForm.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TAniProcessForm.Button2Click(Sender: TObject);
var t, i, kf, j, start, stop, bch: Integer;
    d: Double;
    PH: TPMandHeader11;
begin
    t := (Sender as TButton).Tag;
    if t in [1..4] then
    begin
      kf    := AnimationForm.CurrentNr - 1;
      start := 0;
      stop  := AnimationForm.HeaderCount - 1;
      case t of
        2:  start := kf;
        3:  stop  := kf;
        4:  begin
              start := kf;
              stop  := kf;
            end;
      end;
      if CheckBox14.Checked then bch := PostProForm.HSoptions else bch := 0;
      for i := start to stop do
      begin
        j := AnimationForm.KFposLUT[i];
        PH := @AnimationForm.KeyFrames[j].HeaderParas;
        if CheckBox1.Checked then PH.iOptions := UpDown1.Position shl 6;  //Smooth normals
        if CheckBox2.Checked then PH.sDEstop := StrToFloatK(Edit25.Text);
        if CheckBox3.Checked then PostProForm.PutAmbientParsToHeader(PH); //AO
        if CheckBox4.Checked then PH.mZstepDiv := Min(1, Max(0.01, StrToFloatK(Edit7.Text)));
        if CheckBox5.Checked then PH.bStepsafterDEStop := UpDown3.Position;
        if CheckBox6.Checked then AnimationForm.KeyFrames[j].KFcount := StrToIntTrim(Edit1.Text);
        if CheckBox7.Checked then PH.sRaystepLimiter := StrToFloatK(Edit2.Text);
        if CheckBox8.Checked then LightAdjustForm.PutLightFInHeader(AnimationForm.KeyFrames[j].HeaderParas);
        if CheckBox9.Checked then PostProForm.PutReflectionParsToHeader(PH); //reflections
        if CheckBox11.Checked then PH.Iterations := StrToIntTrim(Edit4.Text);
        if CheckBox12.Checked then PH.MinimumIterations := StrToIntTrim(Edit5.Text);
        if CheckBox13.Checked then AnimationForm.KeyFrames[j].KFcount :=
            Round(AnimationForm.KeyFrames[j].KFcount * StrToFloatK(Edit6.Text));
        if CheckBox14.Checked then
        begin   //HS settings
          PH.bCalculateHardShadow := bch and $FF;
          PH.HSmaxLengthMultiplier := StrToFloatK(PostProForm.Edit5.Text);
          PH.bCalc1HSsoft := bch shr 8;
          if not StrToFloatKtry(PostProForm.Edit7.Text, d) then d := 1;
          PH.MCSoftShadowRadius := SingleToShortFloat(MinMaxCS(0.01, d, 20));
        end;
        if CheckBox15.Checked then PH.iOptions := (PH.iOptions and $7FFFFFFE) or
                                                  (Byte(CheckBox17.Checked) and 1);
        if CheckBox16.Checked then PostProForm.PutDOFparsToHeader(PH); //DOF
        if CheckBox18.Checked then
        begin
          PH.byColor2Option := Mand3DForm.RadioGroup1.ItemIndex;
          PH.bColorOnIt := StrToIntTry(Mand3DForm.Edit35.Text, -1) + 1;
          PH.sColorMul := StrToFloatK(Mand3DForm.Edit2.Text);
          if Mand3DForm.ButtonVolLight.Caption = 'Dyn. fog on It.:' then
          begin
            PH.bVolLightNr := 2 shl 4;
            PH.bDFogIt := StrToIntTry(Mand3DForm.Edit16.Text, 0);
          end
          else PH.bVolLightNr := Min(6, Max(1, StrToIntTry(Mand3DForm.Edit16.Text, 0))) or
                                 ((Mand3DForm.UpDown5.Position + 2) shl 4);
        end;
        if CheckBox19.Checked then
        begin
          PH.StereoScreenWidth := StrToFloatK(Mand3DForm.Edit15.Text);
          PH.StereoScreenDistance := StrToFloatK(Mand3DForm.Edit18.Text);
          PH.StereoMinDistance := StrToFloatK(Mand3DForm.Edit13.Text);
        end;
        if CheckBox20.Checked then //camera
        begin
          PH.dFOVy := StrToFloatK(Mand3DForm.Edit14.Text);
          PH.bPlanarOptic := Mand3DForm.RadioGroup2.ItemIndex;
        end;
        if CheckBox21.Checked then PH.byCalcNsOnZBufAuto := Byte(CheckBox10.Checked) and 1; //N's on ZBuf
      end;
    end;
end;

procedure TAniProcessForm.FormShow(Sender: TObject);
begin
    Button2.Enabled := AnimationForm.HeaderCount > 0;
    Button5.Enabled := Button2.Enabled;
    Button3.Enabled := AnimationForm.CurrentNr <= AnimationForm.HeaderCount;
    Button4.Enabled := Button3.Enabled;
    Button6.Enabled := Button3.Enabled;
end;

procedure TAniProcessForm.Button5Click(Sender: TObject);     //Rerender all keyframe images
begin
    bRerenderPreviewImages := True;
    actKeyFame := 0;
    AnimationForm.RenderPrevBMP(AnimationForm.KFposLUT[0]);
    Screen.Cursor := crHourGlass;
end;

procedure TAniProcessForm.FormCreate(Sender: TObject);
begin
    bRerenderPreviewImages := False;
end;

procedure TAniProcessForm.Button7Click(Sender: TObject);   //reverse order
var i, i2, it: Integer;
begin
    with AnimationForm do
    begin
      for i := 0 to (HeaderCount - 1) div 2 do
      begin
        i2 := HeaderCount - 1 - i;
        it := KFposLUT[i];
        KFposLUT[i] := KFposLUT[i2];
        KFposLUT[i2] := it;
      end;
      PaintBox1.Invalidate;
    end;
end;

end.
