unit MonteCarloForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, M3Iregister,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, TypeDefinitions, Vcl.ExtDlgs,
  Vcl.ImgList;

type
  TMCForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button9: TSpeedButton;
    Button8: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel4: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    TrackBar1: TTrackBar;
    Label7: TLabel;
    Timer2: TTimer;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Label8: TLabel;
    SaveDialog3: TSaveDialog;
    SpeedButton1: TSpeedButton;
    SaveDialog6: TSaveDialog;
    Button4: TButton;
    Label14: TLabel;
    Label15: TLabel;
    CheckBox5: TCheckBox;
    Button6: TButton;
    ImageList1: TImageList;
    CategoryPanelGroup2: TCategoryPanelGroup;
    CategoryPanel6: TCategoryPanel;
    CategoryPanel5: TCategoryPanel;
    CategoryPanel1: TCategoryPanel;
    Label9: TLabel;
    Edit21: TEdit;
    UpDown3: TUpDown;
    CheckBox6: TCheckBox;
    CheckBox2: TCheckBox;
    Label20: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label21: TLabel;
    Edit2: TEdit;
    CheckBox3: TCheckBox;
    Button5: TButton;
    CheckBox4: TCheckBox;
    Image2: TImage;
    UpDown2: TUpDown;
    Label23: TLabel;
    Label22: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Label24: TLabel;
    ComboBox1: TComboBox;
    CategoryPanel2: TCategoryPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label2avrgnoise: TLabel;
    Label7avrgrays: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label3: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    CheckBox7: TCheckBox;
    Label33: TLabel;
    Timer3: TTimer;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    TrackBar3: TTrackBar;
    CheckBox8: TCheckBox;
    TrackBar4: TTrackBar;
    procedure TrackBar18KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SaveDialog6TypeChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure CategoryPanel2Collapse(Sender: TObject);
    procedure CategoryPanel2Expand(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private-Deklarationen }
    MCActiveCalcThreads: Integer;
    LastUpdate: Cardinal;
    LastSaved: Cardinal;
    AvrgSqrNoise: Double;
    AvrgRCount: Single;
    iUpdate: Integer;
    bGotZeroCounts: LongBool;
    FirstOpenM3C: LongBool;
    FName, SaveFName: String;
    BokehBMP: array[0..5] of TBitmap;
    procedure MCRepaint;
    function SizeOK: LongBool;
    procedure MCTriggerRepaint;
    procedure StartCalc;
    procedure FitImageSize;
    procedure CalcAvrgNoise;
    procedure SetParas;
    procedure UpdateParas;
    procedure ProofTotalLightAmount(bVerboseIfOK: LongBool);
    procedure SetFormSize;
    procedure SaveM3C;
    procedure ShowTotalCalcTime;
    procedure ConvertFromNewMCrecord;
    procedure CalcBokeDiscOnBMP(var BokehBMP: TBitmap; nr: Integer);
    procedure SetCPanelImages(C: TCategoryPanel; Checked: LongBool);
    procedure UpdatePanel(C: TCategoryPanel);
    procedure IniHeaderPointers;
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    siLightMC: array of TMCrecord;
    bUserChange: LongBool;
    MCparas: TMandHeader10;
    MCCalcStop: LongBool;
    MCHeaderLightVals: TLightVals;
    MCctstats: TCalcThreadStats;
    MCHybridCustoms: array[0..5] of TCustomFormula;
    MCHAddOn: THeaderCustomAddon;
    OPDmc: TOpenPictureDialogM3D;
    Authors: AuthorStrings;
  end;

var
  MCForm: TMCForm;
  MCFormCreated: LongBool = False;

implementation

uses Mand, Math3D, PaintThread, ImageProcess, HeaderTrafos, Tiling, CommDlg,
  PostProcessForm, DivUtils, CalcMonteCarlo, CustomFormulas, FileHandling,
  LightAdjust, Maps, Math, ColorOptionForm;

{$R *.dfm}

procedure TMCForm.WmThreadReady(var Msg: TMessage);
begin
    if Msg.LParam = 0 then
    begin
      Dec(MCActiveCalcThreads); //calc number from calcthreadstat
      if (MCActiveCalcThreads < 1) and (Button2.Caption = 'Stop rendering') then
      begin
        Timer1.Interval := 5;
        Timer1.Enabled := True;
      end;
    end;
end;

procedure TMCForm.MCTriggerRepaint;
begin
    Inc(MCRepaintCounter);
    Timer2.Enabled := True;
end;

procedure TMCForm.SaveDialog6TypeChange(Sender: TObject);
var S: String;
begin
    case SaveDialog6.FilterIndex of
      1:  SaveDialog6.DefaultExt := 'bmp';
      2:  SaveDialog6.DefaultExt := 'png';
      3:  SaveDialog6.DefaultExt := 'jpg';
    end;
    S := SaveDialog6.Filename;
    if SysUtils.DirectoryExists(S) then S := '';
    if S <> '' then
      case SaveDialog6.FilterIndex of
        1:  S := ChangeFileExt(S, '.bmp');
        2:  S := ChangeFileExt(S, '.png');
      else
        S := '';
      end;
    if S <> '' then
      SendMessage(GetParent(SaveDialog6.Handle), CDM_SETCONTROLTEXT, $480, Longint(PChar(ExtractFileName(S))));
end;

function TMCForm.SizeOK: LongBool;
var w, h: Integer;
begin
    w := MCparas.Width;
    h := MCparas.Height;
    Result := (w > 0) and (h > 0) and (w < 32768) and (h < 32768) and
              (Length(siLightMC) = w * h);
end;

procedure TMCForm.SpeedButton1Click(Sender: TObject);  //save bmp,png
var i, c: Integer;
    s: String;
begin
    Val(IniVal[16], i, c);
    if c = 0 then SaveDialog6.FilterIndex := i + 1;
    SaveDialog6.InitialDir := IniDirs[2];
    SetDialogName(SaveDialog6, FName);
    if SaveDialog6.Execute then
    case SaveDialog6.FilterIndex of
      1: SaveBMP(SaveDialog6.FileName, Image1.Picture.Bitmap, pf24bit);
      2: SavePNG(SaveDialog6.FileName, Image1.Picture.Bitmap, False);
      3: begin
           s := '95';
           if InputQuery('JPEG quality or size', 'Type in the quality (0..100) or the maximal output filesize in KB (>100):', s) then
             SaveJPEGfromBMP(SaveDialog6.FileName, Image1.Picture.Bitmap, StrToIntTrim(s));
  //         c := StrToIntTrim(InputBox('JPEG quality or size', 'Type in the quality (0..100) or the maximal output filesize in KB (>100):', '95'));
    //       SaveJPEGfromBMP(SaveDialog6.FileName, Image1.Picture.Bitmap, c);
         end;
    end;
end;

procedure TMCForm.MCRepaint;
begin
    if SizeOK then
    begin
      Inc(MCRepaintCounter);
      PaintMC(@MCparas);
    end;
end;

procedure TMCForm.TrackBar18KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = '1' then (Sender as TTrackBar).Position := (Sender as TTrackBar).SelStart;
end;

procedure TMCForm.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TMCForm.CalcBokeDiscOnBMP(var BokehBMP: TBitmap; nr: Integer);
var sx, sy, r, fx, fy, sm{, a, b, sml}: Single;
    x, y, c, cy, yy, n{, i}: Integer;
    p: PByteArray;
    ps: PSingle;
  //  p1, p2: TPSPoint;
    sa: array[0..30, 0..30] of Single;
begin
    with BokehBMP.Canvas do
    begin
      Brush.Color := 0;
      FillRect(ClipRect);
      n := 70;  //size for calculation of avrg sum, try to get lo as possible without quality loss
      sm := 1 / n;
      for x := 0 to 30 do for y := 0 to 30 do sa[x, y] := 0;
      for y := -n to n do for x := -n to n do
      begin
     //   if nr < 2 then
        begin
          if Sqr(x) + Sqr(y) >= n * n then Continue;
          r := CalcBokeh(x * sm, y * sm, nr) * sm * 14;
          sx := x * r + 15;
          sy := y * r + 15;
   {       sml := 1;
        end
        else
        begin
          if nr > 3 then i := 7 else i := 5;
          sx := (x * sm * s05 + s05) * i;
          sy := (Abs(y * sm * s05 + s05));
          sml := sy;
          i := Trunc(sx) mod i;
          sx := FracSingle(sx);
          if (nr and 1) = 0 then
          begin
            if sy < 0.94 then sy := sy * 1.03
                         else sy := sy * (0.9682 + (sy - 0.94) * s05);
          end
          else sy := sy * (1.5 - sy * s05);
          if nr > 3 then
          begin  //septagon
            p1 := @SinCosP7[i];
            p2 := @SinCosP7[i + 1];
            fx := 0.3;
          end
          else
          begin  //pentagon
            p1 := @SinCosP5[i];
            p2 := @SinCosP5[i + 1];
            fx := 0.4;
          end;
          r := sx * (1 - sx) * fx; //addition to border, make it more roundy
          fx := 0.96 + r;
          if sy < fx then sy := sy * (1 + r) else sy := 0.96 + (sy - fx) * (r + 0.04);
          a := sx * sy;
          b := (1 - sx) * sy;
          sx := a * p1[0] + b * p2[0];
          sy := a * p1[1] + b * p2[1];
          sx := sx * 14 + 15;
          sy := sy * 14 + 15;  }
        end;
        c := Trunc(sx);
        cy := Trunc(sy);
        fx := sx - c;
        fy := sy - cy;
        ps := @sa[cy, c];
        ps^ := ps^ + (1 - fx) * (1 - fy); // * sml
        Inc(ps);
        ps^ := ps^ + fx * (1 - fy);
        Inc(ps, 30);
        ps^ := ps^ + (1 - fx) * fy;
        Inc(ps);
        ps^ := ps^ + fx * fy;
      end;
      sm := sm * sm * 21000;
    //  if nr > 1 then sm := sm * 1.4;
      for x := 0 to 30 do
      begin
        p := BokehBMP.ScanLine[x + 1];
        for y := 0 to 30 do
        begin
          yy := (y + 1) * 4;
          c := Round(sa[y, x] * sm);
          p[yy] := c;
          p[yy + 1] := c;
          p[yy + 2] := c;
        end;
      end;
    end;
end;

procedure TMCForm.CategoryPanel2Collapse(Sender: TObject);
begin   //set categoryGroupheight
    CategoryPanelGroup2.Height := CategoryPanel1.Height + CategoryPanel2.Height
                                + CategoryPanel5.Height + CategoryPanel6.Height;
    Label33.Top := CategoryPanelGroup2.Height + 8;
end;

procedure TMCForm.CategoryPanel2Expand(Sender: TObject);
begin //Collapse every other panel
    if Sender <> CategoryPanel1 then CategoryPanel1.Collapsed := True;
    if Sender <> CategoryPanel2 then CategoryPanel2.Collapsed := True;
    if Sender <> CategoryPanel5 then CategoryPanel5.Collapsed := True;
    if Sender <> CategoryPanel6 then CategoryPanel6.Collapsed := True;
    CategoryPanel2Collapse(Sender);
end;

procedure TMCForm.IniHeaderPointers;
var i: Integer;
begin
    MCparas.PCFAddon := @MCHAddOn;
    for i := 0 to 5 do MCparas.PHCustomF[i] := @MCHybridCustoms[i];
end;

procedure TMCForm.FormCreate(Sender: TObject);
var i: Integer;
begin
    OPDmc := TOpenPictureDialogM3D.Create(Self);
    OPDmc.Filter := 'M3D monte carlo file (*.m3c)|*.m3c';
    OPDmc.DefaultExt := 'm3c';
    MCFormCreated := True;
    bUserChange := True;
    FirstOpenM3C := True;
    MCActiveCalcThreads := 0;
    iUpdate := 0;
    Image1.Picture.Bitmap.PixelFormat := pf32bit;
    Image1.Picture.Bitmap.SetSize(250, 30);
    IniHeaderPointers;
    MCVMapcalculated := False;
    for i := 0 to 5 do IniCustomF(@MCHybridCustoms[i]);
    for i := 0 to 5 do
    begin
      BokehBMP[i] := TBitmap.Create;
      BokehBMP[i].PixelFormat := pf32Bit;
      BokehBMP[i].SetSize(33, 33);
      CalcBokeDiscOnBMP(BokehBMP[i], i);
    end;
    Image2.Picture.Bitmap.Assign(BokehBMP[0]);
    ComboBox1.Hint := 'Box: sharp, good AA' + #13#10 +
                      'Gauss: bit blurry, very good AA';
end;

procedure TMCForm.FormDestroy(Sender: TObject);
begin
    OPDmc.Free;
end;

procedure TMCForm.FormHide(Sender: TObject);
begin
    if Button2.Caption = 'Stop rendering' then
      if MessageDlg('Should i stop calculations?', mtWarning, [mbYes, mbNo], 0) = mrYes then
        Button2.Click;
end;

procedure TMCForm.FormShow(Sender: TObject);
begin
    PreComputeHaltonSequence;
end;

procedure TMCForm.TrackBar1Change(Sender: TObject);  //contrast
begin
    if bUserChange then MCTriggerRepaint;
end;

procedure TMCForm.Timer1Timer(Sender: TObject);   //trigger new calc
var i, j, n, ysub: Integer;
    c: Cardinal;
    xx, yy, ymax: Double;
begin
    Timer1.Interval := 400;
    i := 0;
    n := 0;
    yy := 0;
    ymax := MCparas.Height / MCctstats.iTotalThreadCount;
    xx := 1 / MCparas.Width;
    for j := 1 to MCctstats.iTotalThreadCount do
    with MCctstats.CTrecords[j] do
    begin
      i := i + iActualYpos;
      if isActive <> 0 then
      begin
        Inc(n);
        yy := yy + MinCD(ymax, Max(0, iActualYpos - j + 1) / MCctstats.iTotalThreadCount +
                               iActualXpos * xx);
      end
      else yy := yy + ymax;
    end;
    if bGotZeroCounts then ysub := 0 else ysub := MCctstats.ctCalcRect.Top;
    c := GetTickCount;
    if n > 0 then
    begin
      Label14.Caption := dDateTimeToStr((c - MCctstats.cCalcTime) / MSecsPerDay);
      ProgressBar1.Position := i div MCctstats.iTotalThreadCount;
      if c - LastUpdate > 3000 then
      begin
        xx := (c - MCctstats.cCalcTime) * (ymax * MCctstats.iTotalThreadCount - yy) /
              (MSecsPerDay * MaxCD(0.1, yy - ysub)) * (MCctstats.iTotalThreadCount / Max(n, 1));
        Label15.Caption := 'togo: ' + dDateTimeToStr(xx);
        Inc(iUpdate);
        if bGotZeroCounts or (iUpdate = 3) then MCTriggerRepaint;
        if iUpdate > 2 then iUpdate := 0;
        LastUpdate := c;
      end;
      Exit;
    end;
    Timer1.Enabled := False;
    MCTriggerRepaint;

    if Button2.Caption = 'Stop rendering' then
    begin
      if bGotZeroCounts then MCparas.iCalcTime := (c - MCctstats.cCalcTime) div 100
                        else Inc(MCparas.iCalcTime, (c - MCctstats.cCalcTime) div 100);
      if CheckBox5.Enabled and CheckBox5.Checked and ((c - LastSaved) > 300000) then
      begin
        SaveM3C;
        LastSaved := GetTickCount;
      end;
      MCparas.MClastY := 0;
      StartCalc;
      Timer1.Enabled := True;
    end
    else
    begin
      ProgressBar1.Visible := False;
      Label8.Visible := False;
    end;
end;

procedure TMCForm.Timer2Timer(Sender: TObject);
begin
    if MCThreadActive = 0 then
    begin
      Timer2.Enabled := False;
      UpdateParas;
      MCRepaint;
    end;
end;

procedure TMCForm.Timer3Timer(Sender: TObject);
begin
    Label33.Top := CategoryPanelGroup2.Height + 8;
    if Timer3.Tag > 0 then
    begin
      Timer3.Tag := Timer3.Tag - 1;
      if (Timer3.Tag and 1) = 0 then Label33.Font.Color := clWindowText
                                else Label33.Font.Color := clRed;
    end
    else
    begin
      Label33.Font.Color := clWindowText;
      Timer3.Enabled := False;
    end;
end;

procedure TMCForm.SetParas;
begin
    bUserChange := False;
    TrackBar1.Position := MCparas.MCcontrast;
    TrackBar4.Position := MCparas.bMCSaturation and $7F;
    TrackBar3.Position := (MCparas.Light.TBoptions shr 23) and $3F;
    Edit3.Text := ShortFloatToStr(MCparas.MCSoftShadowRadius);
    Edit2.Text := D2ByteToStr(MCparas.MCdiffReflects);
    UpDown1.Position := MCparas.SRreflectioncount;
    UpDown3.Position := MCparas.MCDepth - 1;
    Button2.Enabled := True;
    Button8.Enabled := True;
    Button4.Enabled := Mand3DForm.Button2.Caption <> 'Stop';
    CheckBox8.Checked := (MCparas.MCoptions and 1) <> 0;
    CheckBox2.Checked := (MCparas.bCalcSRautomatic and 1) <> 0;
    CheckBox3.Checked := (MCparas.bCalcSRautomatic and 2) <> 0;
    CheckBox4.Checked := (MCparas.bCalcDOFtype and 1) <> 0;
    CheckBox6.Checked := (MCparas.MCoptions and 2) <> 0;
    CheckBox7.Checked := (MCparas.MCoptions and 4) <> 0;
    ComboBox1.ItemIndex := (MCparas.MCoptions shr 3) and 1;
    Label22.Caption := IntToStr(Min(6, ((MCparas.MCoptions shr 4) and 7) + 1));
    Image2.Picture.Bitmap.Assign(BokehBMP[StrToInt(Label22.Caption) - 1]);
    bUserChange := True;
    Label14.Caption := '';
    Label15.Caption := '';
    ShowTotalCalcTime;
end;

procedure TMCForm.UpdateParas;
var d: Double;
begin
    MCparas.bCalcSRautomatic := (MCparas.bCalcSRautomatic and 12) or
     (Ord(CheckBox2.Checked) and 1) or ((Ord(CheckBox3.Checked) shl 1) and 2);
    MCparas.bCalcDOFtype := (MCparas.bCalcDOFtype and $FE) or (Ord(CheckBox4.Checked) and 1);
    MCparas.bSliceCalc := 0;
    MCparas.bCalc3D := 1;
    if not StrToFloatKtry(Edit3.Text, d) then d := 1;
    MCparas.MCSoftShadowRadius := SingleToShortFloat(d);
    MCparas.MCDepth := UpDown3.Position + 1;
    MCparas.SRreflectioncount := UpDown1.Position;
    MCparas.bMCSaturation := TrackBar4.Position;
    MCparas.MCoptions := (Ord(CheckBox8.Checked) and 1) or ((Ord(CheckBox6.Checked) and 1) shl 1)
                     or ((Ord(CheckBox7.Checked) and 1) shl 2) or ((ComboBox1.ItemIndex and 1) shl 3)
                     or (Max(0, StrToInt(Label22.Caption) - 1) shl 4);
    MCparas.MCcontrast := TrackBar1.Position; //exposure
    MCparas.MCdiffReflects := StrToD2Byte(Edit2.Text);
    MCparas.Light.TBoptions := (MCparas.Light.TBoptions and $E07FFFFF) or (TrackBar3.Position shl 23);  //gamma/L
end;

procedure TMCForm.UpDown2Click(Sender: TObject; Button: TUDBtnType);
var i: Integer;
begin
    i := StrToInt(Label22.Caption);
    if Button = btNext then Inc(i) else
    if Button = btPrev then Dec(i);
    i := Min(5, Max(0, i - 1));
    MCparas.MCoptions := (MCparas.MCoptions and $3F) or (i shl 4);
    Label22.Caption := IntToStr(i + 1);
    Image2.Picture.Bitmap.Assign(BokehBMP[i]);
end;

procedure ModLight(Light: TPLightingParas9; Paras: TPMandHeader10; iOption: Integer);
var i, i2, ii: Integer;
    c: Cardinal;
    bIsSqr, bCalcT: LongBool;
    smax, SpecMul, sd: Single;
    sv1, sv2: TSVec;
begin
    with Light^ do
    begin
      bIsSqr := (AdditionalOptions and 1) <> 0;
      bCalcT := (Paras.bCalcSRautomatic and 3) = 3;
      SpecMul := MaxCS(0.001, Paras.SRamount);
      for i := 0 to 9 do for ii := 0 to 1 do if (i < 4) or (ii = 0) then //for inside?  spec = dif[3]
      begin
        if ii = 1 then
        begin
          c := ICols[i].Color;
          sv1 := ColToSVec(c, bIsSqr);
          c := c shr 24;
          sv2 := ColToSVec(c or (c shl 8) or (c shl 16), bIsSqr);
        end else begin
          sv1 := ColToSVec(LCols[i].ColorDif, bIsSqr);
          sv2 := ColToSVec(LCols[i].ColorSpe, bIsSqr);
        end;
        if bCalcT then sd := MaxCS(0.001, 1 - (LCols[i].ColorSpe shr 24) * s1d255 * SpecMul) else sd := 1;
        case iOption of
          1: begin
               smax := 1;
               for i2 := 0 to 2 do if sv1[i2] * sd + sv2[i2] * SpecMul > 1 then
                 smax := MinMaxCS(0, (1.001 - sv2[i2] * SpecMul) / (sv1[i2] * sd), smax);
               if smax < 1 then ScaleSVectorV(@sv1, smax);
             end;
          2: begin
               smax := MaxCS(MaxCS(sv1[0] * sd + sv2[0] * SpecMul,
                                   sv1[1] * sd + sv2[1] * SpecMul),
                                   sv1[2] * sd + sv2[2] * SpecMul);
               if smax > 1 then
               begin
                 smax := 1 / smax;
                 ScaleSVectorV(@sv1, smax);
                 ScaleSVectorV(@sv2, smax);
               end;
             end;
          3: begin
               smax := 1;
               for i2 := 0 to 2 do if sv1[i2] * sd + sv2[i2] * SpecMul > 1 then
                 smax := MinMaxCS(0, (1.001 - sv1[i2] * sd) / (sv2[i2] * SpecMul), smax);
               if smax < 1 then ScaleSVectorV(@sv2, smax);
             end;
        end;
        if bIsSqr then
        begin
          sv1 := mSqrtSVec(sv1);
          sv2 := mSqrtSVec(sv2);
        end;
        if ii = 1 then
        begin
          ICols[i].Color := (SVecToColNoScale(ScaleSvector(sv1, s255)) and $FFFFFF) or
                            (SVecToColNoScale(ScaleSvector(sv2, s255)) shl 24);
        end else begin
          LCols[i].ColorDif := (LCols[i].ColorDif and $FF000000) or
            (SVecToColNoScale(ScaleSvector(sv1, s255)) and $FFFFFF);
          LCols[i].ColorSpe := (LCols[i].ColorSpe and $FF000000) or
            (SVecToColNoScale(ScaleSvector(sv2, s255)) and $FFFFFF);
        end;
      end;
    end;
end;

procedure TMCForm.ProofTotalLightAmount(bVerboseIfOK: LongBool);
var i, iOption: Integer;
    bIsSqr, bToMuch, bCalcT: LongBool;
    SpecMul, sd: Single;
    sv1, sv2: TSVec;
    tmpLight: TLightingParas9;
function ProofCols(const LCol: TLCol8): LongBool;
begin
    Result := False;    //if calcTransp + Transp > 0 then downscale diffuse
    if bCalcT then sd := MaxCS(0.001, 1 - (LCol.ColorSpe shr 24) * s1d255 * SpecMul) else sd := 1;
    if (sv1[0] * sd + sv2[0] * SpecMul) > 1.005 then Result := True;
    if (sv1[1] * sd + sv2[1] * SpecMul) > 1.005 then Result := True;
    if (sv1[2] * sd + sv2[2] * SpecMul) > 1.005 then Result := True;
end;
begin
    if (MCparas.bCalcSRautomatic and 1) <> 0 then
    with MCparas.Light do
    begin
      bToMuch := False;
      if GetDiffMapNr(@MCparas.Light) <> 0 then
      begin
        if not CheckBox7.Checked then
        begin
          ShowMessage('When using a map for the diffuse color,' + #13#10 +
                      'you have to check ''Autoclip Spec+Diff''' + #13#10 +
                      'for an automatic clipping of colors.');
          CheckBox7.Checked := True;
        end;
      end
      else
      begin
        bIsSqr := (AdditionalOptions and 1) <> 0;
        bCalcT := (MCparas.bCalcSRautomatic and 3) = 3;
        SpecMul := MCparas.SRamount;
        if (MCparas.bCalcSRautomatic and 1) <> 0 then
        for i := 0 to 9 do
        begin
          sv1 := ColToSVec(LCols[i].ColorDif, bIsSqr);
          sv2 := ColToSVec(LCols[i].ColorSpe, bIsSqr);
          bToMuch := ProofCols(LCols[i]);
          if bToMuch then Break;
        end;
      end;
      if bVerboseIfOK and not bToMuch then ShowMessage('All colors are ok.');
      if bToMuch and (MessageDlg('The amount of added diffuse and specular colors are bigger 1,' + #13#10 +
        'should i downscale them for a more realistic coloring?', mtWarning, [mbYes, mbNo], 0) = mrYes) then
      begin
        for iOption := 1 to 3 do
        begin
          tmpLight := MCparas.Light;
          ModLight(@tmpLight, @MCparas, iOption);
          PaintSDPreviewColors(@tmpLight, (FColorOptions.FindComponent('Image' + IntToStr(iOption * 2 - 1)) as TImage).Canvas,
            (FColorOptions.FindComponent('Image' + IntToStr(iOption * 2)) as TImage).Canvas, 60);
        end;
        iOption := FColorOptions.ShowModal;
        if not (iOption in [1..3]) then Exit;
        ModLight(@MCparas.Light, @MCparas, iOption);
      end;
    end;
end;

procedure TMCForm.SetFormSize;
begin
    ClientWidth := Panel3.Width + MCparas.Width;
    ClientHeight := Panel1.Height + Panel2.Height + MCparas.Height;
end;

procedure TMCForm.Button3Click(Sender: TObject);  //import paras
begin
    if FirstOpenM3C then
    begin
      OPDmc.InitialDir := IniDirs[11];
      SaveDialog3.InitialDir := IniDirs[11];
      FirstOpenM3C := False;
    end;
    Mand3DForm.MakeHeader;
    IniHeaderPointers;
    AssignHeader(@MCparas, @Mand3DForm.MHeader);
    IniCFsFromHAddon(MCparas.PCFAddon, MCparas.PHCustomF); //new
    Authors := Mand3DForm.Authors;
    MCparas.TilingOptions := 0;     //used as OldAvrgSqrNoise
    MCparas.iReflectsCalcTime := 0; //used as OldAvrgRayCount
    MCparas.bSSAO24BorderMirrorSize := 0; //indicator if oldvals are stored
    MCparas.iCalcTime := 0;
    MCparas.MClastY := 0;
    MCparas.sDOFZsharp := (MCparas.sDOFZsharp + MCparas.sDOFZsharp2) * s05;
    MCparas.sDOFZsharp2 := MCparas.sDOFZsharp;
    ProofTotalLightAmount(False);
    MakeLightValsFromHeaderLight(@MCparas, @MCHeaderLightVals, 1, MCparas.bStereoMode);
    SetParas;
    FName := ChangeFileExtSave(Mand3DForm.Caption, '');
    if Copy(FName, 1, 13) = 'Mandelbulb 3D' then FName := 'main params';
    Caption := FName;
    SetLength(siLightMC, 0);
    FitImageSize;
    Image1.Picture.Bitmap.Canvas.FillRect(Image1.Picture.Bitmap.Canvas.ClipRect);
    Image1.Picture.Bitmap.Canvas.Font.Color := $C000;
    Image1.Picture.Bitmap.Canvas.TextOut(8, 8, 'Press ''Start rendering'' to calculate the image');
    SetFormSize;
    SpeedButton1.Enabled := False;
    CheckBox5.Enabled := False;
    Label7avrgrays.Caption := '';
    Label2avrgnoise.Caption := '';
    Label12.Caption := '';
    Label13.Caption := '';
    Label19.Caption := '';
    Label33.Caption := '';
    MCVMapcalculated := False;
end;

procedure TMCForm.Button4Click(Sender: TObject); //send paras to main
var x, n: Integer;
begin
    UpdateParas;
    MCparas.bCalculateHardShadow := 3;
    n := 0;
    for x := 0 to 5 do if (MCparas.Light.Lights[x].Loption and 3) = 0 then
    begin
      MCparas.bCalculateHardShadow := MCparas.bCalculateHardShadow or (4 shl x);
      MCparas.Light.Lights[x].LFunction := MCparas.Light.Lights[x].LFunction and $CF; //cos
      Inc(n);
    end;
    if n = 1 then MCparas.bCalc1HSsoft := 1 else MCparas.bCalc1HSsoft := 0;
    if n = 0 then MCparas.bCalculateHardShadow := 2;
    MCparas.AODEdithering := 0;
    MCparas.bCalcAmbShadowAutomatic := 253;
    MCparas.iOptions := (2 shl 6) + 1;
    MCparas.Light.Lights[3].AdditionalByteEx := 0; //HS diffuse shadow amount
    MCparas.Light.TBpos[11] := (MCparas.Light.TBpos[11] and $FFFF0000) or 53 or (27 shl 8);  //AmbShadow + 2ndreflect amount
    MCparas.Light.Lights[2].FreeByte := MCparas.Light.Lights[2].FreeByte and $FE;  //turn of 2nd mode
    MCparas.Light.AdditionalOptions := MCparas.Light.AdditionalOptions or 32;      //use small BGpic for amb
    IniHeaderPointers;
    AssignHeader(@Mand3DForm.MHeader, @MCparas);
    Mand3DForm.MHeader.MClastY := 0;
    Mand3DForm.MHeader.TilingOptions := 0;
    Mand3DForm.MHeader.iReflectsCalcTime := 0;
    Mand3DForm.MHeader.bSSAO24BorderMirrorSize := 0;
    Mand3DForm.Authors := Authors;
    IniCFsFromHAddon(Mand3DForm.MHeader.PCFAddon, Mand3DForm.MHeader.PHCustomF);
    Mand3DForm.SetEditsFromHeader;
    LightAdjustForm.SetLightFromHeader(Mand3DForm.MHeader);
    Mand3DForm.Caption := FName;
    SetSaveDialogNames(FName);
    Mand3DForm.ParasChanged;
    SetFocus;
end;

procedure TMCForm.Button5Click(Sender: TObject);
begin
    UpdateParas;
    ProofTotalLightAmount(True);
end;

procedure TMCForm.Button6Click(Sender: TObject);   // noise filter
var x, y, wid, l, SLstart, SLoffset, sop: Integer;
    s1, s2: Single;
    sv, sv2: TSVec;
    pmc, pmc2, pmc3, pmc4, pmc5: TPMCrecord;
begin
    wid := MCparas.Width;
  //  l := l - 2 * wid - 2;
    sop := SizeOf(TMCrecord);
    pmc := @siLightMC[wid + 1];
    pmc2 := TPMCrecord(Integer(pmc) - sop);
    pmc3 := TPMCrecord(Integer(pmc) + sop);
    pmc4 := TPMCrecord(Integer(pmc) - sop * wid);
    pmc5 := TPMCrecord(Integer(pmc) + sop * wid);
    SLstart := Integer(Image1.Picture.Bitmap.ScanLine[0]);
    SLoffset := Integer(Image1.Picture.Bitmap.ScanLine[1]) - SLstart;
    for y := 1 to MCparas.Height - 2 do
    begin
      l := SLstart + y * SLoffset + 4;
      for x := 1 to wid - 2 do
      begin
        sv := ColToSVecFlipRBNoScale(PCardinal(l)^, False);
        s1 := 1;
        sv2 := ColToSVecFlipRBNoScale(PCardinal(l - SLoffset)^, False);
        s2 := 0.25;
        AddSVecWeight(@sv, @sv2, s2);
        s1 := s1 + s2;
        sv2 := ColToSVecFlipRBNoScale(PCardinal(l - 4)^, False);
        s2 := 0.25;
        AddSVecWeight(@sv, @sv2, s2);
        s1 := s1 + s2;
        sv2 := ColToSVecFlipRBNoScale(PCardinal(l + 4)^, False);
        s2 := 0.25;
        AddSVecWeight(@sv, @sv2, s2);
        s1 := s1 + s2;
        sv2 := ColToSVecFlipRBNoScale(PCardinal(l + SLoffset)^, False);
        s2 := 0.25;
        AddSVecWeight(@sv, @sv2, s2);
        s1 := s1 + s2;

        ScaleSVectorV(@sv, 1 / s1);
        PCardinal(l)^ := SVecToCol(sv);

{        dT1 := MCRGBtoDouble(@pmc.Ysum);
        dtmp := 0;                    //todo: Ysum  avrg of all 5 pixles to subtract...
        if pmc2.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc2.Ysum));
        if pmc3.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc3.Ysum));
        if pmc4.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc4.Ysum));
        if pmc5.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc5.Ysum));
        dtmp := Clamp0D(dtmp * 0.25 - sigma);
        dT1 := Clamp0D((MCRGBtoDouble(@pmc.Ysqr) - Sqr(dT1)) / (MaxCD(0.1, dT1) * pmc.RayCount) - dtmp);
         }
        Inc(pmc);
        Inc(pmc2);
        Inc(pmc3);
        Inc(pmc4);
        Inc(pmc5);
        Inc(l, 4);
      end;
    end;
    Image1.Picture.Bitmap.Modified := True;
end;

procedure TMCForm.SaveM3C;
var f: file;
begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      AssignFile(f, ChangeFileExtSave(SaveFName, '.m3c'));
      Rewrite(f, 1);
      InsertAuthorsToPara(@MCparas, Authors);
      BlockWrite(f, MCparas, SizeOf(MCparas));
      IniHeaderPointers;
      MCHAddon.bHCAversion := 16;
      BlockWrite(f, MCHAddon, SizeOf(THeaderCustomAddon));
      BlockWrite(f, siLightMC[0], SizeOf(TMCrecord) * Length(siLightMC));
      CloseFile(f);
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TMCForm.Button8Click(Sender: TObject);  //save mc
begin
    SetDialogName(SaveDialog3, FName);
    if SaveDialog3.Execute then
    begin
      SaveFName := SaveDialog3.FileName;
      FName := ChangeFileExtSave(ExtractFileName(SaveFName), '');
      SaveM3C;
      Caption := FName;
      CheckBox5.Enabled := True;
    end;
end;

procedure TMCForm.ConvertFromNewMCrecord;
var i: Integer;
    mcrN: TMCrecordNew;
begin
    for i := 0 to Length(siLightMC) - 1 do
    begin
      FastMove(siLightMC[i], mcrN, 18);
      ConvertNewMCRtoOld(@siLightMC[i], @mcrN);
    end;
end;

procedure TMCForm.Button9Click(Sender: TObject);   //open mc
var f: file;
begin
    MCCalcStop := True;
    Inc(MCRepaintCounter);
    if FirstOpenM3C then
    begin
      OPDmc.InitialDir := IniDirs[11];
      SaveDialog3.InitialDir := IniDirs[11];
      FirstOpenM3C := False;
    end;
    if OPDmc.Execute then
    begin
      SetDialogName(SaveDialog3, OPDmc.FileName);
      SaveFName := OPDmc.FileName;
      CheckBox5.Enabled := True;
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        AssignFile(f, ChangeFileExt(OPDmc.FileName, '.m3c'));
        Reset(f, 1);
        BlockRead(f, MCparas, SizeOf(MCparas));
        BlockRead(f, MCHAddon, SizeOf(THeaderCustomAddon));
        SetLength(siLightMC, MCparas.Width * MCparas.Height);
        BlockRead(f, siLightMC[0], SizeOf(TMCrecord) * Length(siLightMC));
        CloseFile(f);
      finally
        Screen.Cursor := crDefault;
        Authors := ExtractAuthorsFromPara(@MCparas);
        IniHeaderPointers;
      end;
      FitImageSize;
      Label33.Caption := 'Parameters version: ' + ProgramVersionStr(MCparas.sM3dVersion);
      if Abs(M3dVersion - MCparas.sM3dVersion) > 0.0005 then
      begin
        Label33.Caption := Label33.Caption + #13#10 +
          'Version of this program: ' + ProgramVersionStr(M3dVersion) + #13#10 +
          'You should use the same program version to avoid' + #13#10 +
          'color or other changes in further calculations!';
        Timer3.Tag := 8;
        Timer3.Enabled := True;
      end;
      if MCparas.MandId < 43 then MCparas.bSSAO24BorderMirrorSize := 0;
      UpdateFormulaOptionAbove20(MCparas);
      if (MCparas.MCoptions and 128) <> 0 then ConvertFromNewMCrecord;
      Mand3DForm.bOutMessageLoud := True;
      try
        LoadBackgroundPicT(@MCparas.Light);
      finally
        Mand3DForm.bOutMessageLoud := False;
      end;
      if (MCparas.Light.AdditionalOptions and 32) <> 0 then
        MakeSmallLMimage(@M3DSmallBGpic, @M3DBackGroundPic);
      MakeLightValsFromHeaderLight(@MCparas, @MCHeaderLightVals, 1, MCparas.bStereoMode);
      SetParas;
      Button2.Caption := 'Start rendering';
      MCTriggerRepaint;
      CalcAvrgNoise;
      SpeedButton1.Enabled := True;
      FName := ChangeFileExtSave(ExtractFileName(OPDmc.FileName), '');
      Caption := FName;
      SetFormSize;
      IniCFsFromHAddon(MCparas.PCFAddon, MCparas.PHCustomF);
      MCVMapcalculated := False;
    end;
end;

procedure TMCForm.FitImageSize;
begin
    if (Image1.Picture.Bitmap.Width <> MCparas.Width) or
       (Image1.Picture.Bitmap.Height <> MCparas.Height) then
    begin
      Image1.Picture.Bitmap.SetSize(MCparas.Width, MCparas.Height);
      Image1.SetBounds(Image1.Left, Image1.Top, MCparas.Width, MCparas.Height);
    end;
end;

procedure TMCForm.CalcAvrgNoise;
var i, l, maxRCount{, wid, sop}: Integer;
    pmc{, pmc2, pmc3, pmc4, pmc5}: TPMCrecord;
    avgNoise, avgSqrNoise, dT1, maxNoise{, sigma, dtmp}: Double;
begin
    l := Length(siLightMC);
    if l = 0 then Exit;
  //  sop := SizeOf(TMCrecord);
    maxRCount := 0;
    avgSqrNoise := 0;
    AvrgRCount := 0;
    maxNoise := 0;
    bGotZeroCounts := False;
    pmc := @siLightMC[0];
    for i := 1 to l do
    begin
      if pmc.RayCount = 0 then bGotZeroCounts := True else
      begin
        AvrgRCount := AvrgRCount + pmc.RayCount;
        if pmc.RayCount > maxRCount then maxRCount := pmc.RayCount;
        dT1 := MCRGBtoDouble(@pmc.Ysum);
        dT1 := (MCRGBtoDouble(@pmc.Ysqr) - Sqr(dT1)) / ({MaxCD(0.1, dT1) *} pmc.RayCount);  //~varianz
        avgSqrNoise := avgSqrNoise + dT1;
      end;
      Inc(pmc);
    end;
    dT1 := 1 / l;
    AvrgRCount := AvrgRCount * dT1;

    //2nd pass clamp high contrast > 5 sigma
  //  sigma := 25 * avgSqrNoise * dT1; //sqr
    avgNoise := 0;
    avgSqrNoise := 0;
 //   wid := MCparas.Width;
  //  l := l - 2 * wid - 2;
    pmc := @siLightMC[0];//wid + 1];
 {   pmc2 := TPMCrecord(Integer(pmc) - sop);
    pmc3 := TPMCrecord(Integer(pmc) + sop);
    pmc4 := TPMCrecord(Integer(pmc) - sop * wid);
    pmc5 := TPMCrecord(Integer(pmc) + sop * wid);  }
    for i := 1 to l do
    begin
      if pmc.RayCount <> 0 then
      begin
        dT1 := MCRGBtoDouble(@pmc.Ysum);
    {    dtmp := 0;                    //todo: Ysum  avrg of all 5 pixles to subtract...
        if pmc2.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc2.Ysum));
        if pmc3.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc3.Ysum));
        if pmc4.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc4.Ysum));
        if pmc5.RayCount <> 0 then dTmp := dTmp + Sqr(dT1 - MCRGBtoDouble(@pmc5.Ysum));
        dtmp := Clamp01D(dtmp * 0.25 - sigma); }
        dT1 := Clamp0D((MCRGBtoDouble(@pmc.Ysqr) - Sqr(dT1) {- dtmp}) / ({MaxCD(0.15, dT1) *} pmc.RayCount));
        avgSqrNoise := avgSqrNoise + dT1;
        dT1 := Sqrt(dT1);
        avgNoise := avgNoise + dT1;
        MaxCDvar(dT1, maxNoise);
      end;
      Inc(pmc);
   {   Inc(pmc2);
      Inc(pmc3);
      Inc(pmc4);
      Inc(pmc5);  }
    end;
  //  dT1 := 1 / l;
    avgNoise := avgNoise / l;
    AvrgSqrNoise := MaxCD(0.002, avgSqrNoise / l + 0.002);

    Label2avrgnoise.Caption := FloatToStrSingle(avgNoise);
    Label7avrgrays.Caption := FloatToStrSingle(AvrgRCount);
    Label12.Caption := FloatToStrSingle(maxNoise);
    Label13.Caption := FloatToStrSingle(maxRCount);
end;

procedure TMCForm.SetCPanelImages(C: TCategoryPanel; Checked: LongBool);
var i: Integer;
begin
    if Checked then i := 2 else i := 0;
    C.CollapsedImageIndex := i;
    C.ExpandedImageIndex := i + 1;
    C.CollapsedHotImageIndex := i + 4;
    C.CollapsedPressedImageIndex := i + 4;
    C.ExpandedHotImageIndex := i + 5;
    C.ExpandedPressedImageIndex := i + 5;
    UpdatePanel(C);
end;

procedure TMCForm.UpdatePanel(C: TCategoryPanel); //because it will not be repainted properly
begin
    if Copy(C.Caption, 1, 1) = ' ' then C.Caption := Trim(C.Caption)
                                   else C.Caption := ' ' + Trim(C.Caption) + ' ';
end;

procedure TMCForm.CheckBox2Click(Sender: TObject);
begin
    Edit1.Enabled := CheckBox2.Checked;
    Edit2.Enabled := CheckBox2.Checked;
    UpDown1.Enabled := CheckBox2.Checked;
    Button5.Enabled := CheckBox2.Checked;
    CheckBox3.Enabled := CheckBox2.Checked;
    SetCPanelImages(CategoryPanel5, CheckBox2.Checked);
end;

procedure TMCForm.CheckBox4Click(Sender: TObject);
begin
    UpDown2.Enabled := CheckBox4.Checked;
    Image2.Visible := CheckBox4.Checked; //is not updated if not visible! -> doublebuffered := True
    SetCPanelImages(CategoryPanel6, CheckBox4.Checked);
end;

procedure TMCForm.StartCalc;
begin
    if Length(siLightMC) <> MCparas.Width * MCparas.Height then
    begin
      SetLength(siLightMC, MCparas.Width * MCparas.Height);
      FillChar(siLightMC[0], Length(siLightMC) * SizeOf(TMCrecord), 0);
      AvrgSqrNoise := 1;
      Label2avrgnoise.Caption := '';
      Label7avrgrays.Caption := '';
      Label12.Caption := '';
      Label13.Caption := '';
      bGotZeroCounts := True;
      MCparas.iCalcTime := 0;  //total calc time
      MCparas.MClastY := 0;
    end
    else CalcAvrgNoise;
    if not SizeOK then Exit;
    if MCparas.MClastY = 0 then
    begin
      MCparas.TilingOptions := 0;     //used as OldAvrgSqrNoise
      MCparas.iReflectsCalcTime := 0; //used as OldAvrgRayCount
      MCparas.bSSAO24BorderMirrorSize := 0;
    end
    else if MCparas.bSSAO24BorderMirrorSize <> 0 then //used as storage of oldavrg vals indicator
    begin
      AvrgSqrNoise := PSingle(@MCparas.TilingOptions)^;
      AvrgRCount := PSingle(@MCparas.iReflectsCalcTime)^;
    end;
    FitImageSize;
    UpdateParas;
    MCCalcStop := False;
    Label15.Caption := '';
    ShowTotalCalcTime;
    MCctstats.pLBcalcStop := @MCCalcStop;
    MCctstats.pMessageHwnd := Self.Handle;
    Button2.Caption := 'Stop rendering';
    if CalcMCT(@MCparas, @MCHeaderLightVals, @siLightMC[0], @MCctstats,
               AvrgSqrNoise, AvrgRCount, bGotZeroCounts) then
    begin
      MCActiveCalcThreads := MCctstats.iTotalThreadCount;
      Button3.Enabled := False;
      Button8.Enabled := False;
      Button9.Enabled := False;
      ProgressBar1.Max := MCparas.Height;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible := True;
      if bGotZeroCounts then Label8.Caption := 'first 4 rays (noisy)'
                        else Label8.Caption := '..til next update';
      Label8.Visible := True;
      Timer1.Interval := 200;
      LastUpdate := GetTickCount;
      Timer1.Enabled := True;
    end
    else
    begin
      Button2.Caption := 'Start rendering';
      ProgressBar1.Visible := False;
      Label8.Visible := False;
    end;
end;

procedure TMCForm.ShowTotalCalcTime;
begin
    if MCparas.iCalcTime = 0 then Label19.Caption := '' else
    Label19.Caption := dDateTimeToStr(MCparas.iCalcTime / (MSecsPerDay * 0.01)); //IntToTimeStr(MCparas.iCalcTime);
end;

procedure TMCForm.Button2Click(Sender: TObject);  //start/stop rendering
var i, minY: Integer;
begin
    if Button2.Caption = 'Stop rendering' then    //todo: save lastY if noZeroCounts to start nexttime
    begin
      if bGotZeroCounts then MCparas.iCalcTime := (GetTickCount - MCctstats.cCalcTime) div 100
      else Inc(MCparas.iCalcTime, (GetTickCount - MCctstats.cCalcTime) div 100);
      minY := MCparas.Height - 1;
      for i := 1 to MCctstats.iTotalThreadCount do
        minY := Min(minY, MCctstats.CTrecords[i].iActualYpos);
      MCparas.MClastY := minY;
      if minY = 0 then MCparas.bSSAO24BorderMirrorSize := 0 else
      begin
        PSingle(@MCparas.TilingOptions)^ := AvrgSqrNoise;   //used as OldAvrgSqrNoise
        PSingle(@MCparas.iReflectsCalcTime)^ := AvrgRCount; //used as OldAvrgRayCount
        MCparas.bSSAO24BorderMirrorSize := 1;
      end;
      MCCalcStop := True;
      ProgressBar1.Visible := False;
      Label8.Visible := False;
      Label14.Caption := '';
      Label15.Caption := '';
      Button2.Caption := 'Start rendering';
      MCTriggerRepaint;
      Button3.Enabled := True;
      Button8.Enabled := True;
      Button9.Enabled := True;
      SpeedButton1.Enabled := True;
      ShowTotalCalcTime;
      CalcAvrgNoise;
    end
    else
    begin
      MCTriggerRepaint;
      LastSaved := GetTickCount;
      StartCalc;
    end;
end;

end.
