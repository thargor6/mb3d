unit ColorPick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TypeDefinitions, StdCtrls, Buttons, Vcl.ComCtrls,
  TrackBarEx;

type
  TColorForm = class(TForm)
    Image1: TImage;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    ColorDialog1: TColorDialog;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    CheckBox2: TCheckBox;
    SpeedButton1: TSpeedButton;
    Edit1: TEdit;
    SpeedButton2: TSpeedButton;
    Edit2: TEdit;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Shape26: TShape;
    Shape27: TShape;
    Shape28: TShape;
    Shape29: TShape;
    Shape30: TShape;
    Label5: TLabel;
    TrackBarEx1: TTrackBarEx;
    CheckBox3: TCheckBox;
    Shape31: TShape;
    procedure FormShow(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBarEx1Exit(Sender: TObject);
    procedure TrackBarEx1Change(Sender: TObject);
    procedure Shape21MouseEnter(Sender: TObject);
    procedure TrackBarEx1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    ShapeWidD2: Integer;
    SstartPos: TPoint;
    actShape: Integer;
    DrawXindex: Integer;
    PLight: TPLightingParas9;
    ColCopy1, ColCopy2, ColCopy: Cardinal;
    RandMidCol: array[0..1] of Cardinal;
    bColCopied, bOutside: LongBool;
    procedure SetImageSize;
    function MakeSatCol(var sat, pr, pg, pb: Single): Cardinal;
    function MouseOnTrackBE1: LongBool;
    procedure UpdateShapeCol(Snr, Scol: Integer);
  public
    { Public-Deklarationen }
    procedure RepaintImage(LP: TPLightingParas9; Iupdate: LongBool);
  end;

var
  ColorForm: TColorForm;

implementation

uses Mand, LightAdjust, Math, Math3D, DivUtils, Interpolation, HeaderTrafos;

{$R *.dfm}

function GetIntensity(var StartI: Integer): LongBool;
var s: String;
begin
    s := IntToStr(STartI);
    Result := InputQuery('Transparency intensity', '0: no, 255: Full transparency', s);
    if Result then StartI := StrToIntTrim(s);
end;

procedure TColorForm.SetImageSize;
begin
    Image1.Picture.Bitmap.PixelFormat := pf32Bit;
    Image1.Picture.Bitmap.SetSize(Image1.Width, Image1.Height);
end;

{   LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)
  TLCol8 = packed record
    Position: Word;
    ColorDif: Cardinal;
    ColorSpe: Cardinal;
  end;
  TICol8 = packed record
    Position: Word;
    Color:    Cardinal;
  end;
  }

{procedure FillScol(var sCol: array of Single; var col: Cardinal);
begin
    sCol[0] := col and $FF;
    sCol[1] := (col shr 8) and $FF;
    sCol[2] := (col shr 16) and $FF;
end;  }

procedure TColorForm.UpdateShapeCol(Snr, Scol: Integer);
var nr: Integer;
begin
    if (Snr < 1) or (Snr > 30) then Exit;
    nr := (Snr - 1) mod 10;
    if (not bOutside) and (nr > 3) then Exit;
    (FindComponent('Shape' + IntToStr(Snr)) as TShape).Brush.Color := Scol;
end;

procedure TColorForm.RepaintImage(LP: TPLightingParas9; Iupdate: LongBool);
var x, y, yh, iSL, iSL2, iSoff, xFrom, xTo, actN, n, il, n2: Integer;
    C: Cardinal;
    w1, sm: Single;
    S: TShape;
    bNoColIpol, bDrawCIdone: LongBool;
begin
    with LP^ do
    begin
      bNoColIpol := (Lights[3].FreeByte and 1) <> 0;
      if bOutside then n := 10 else n := 4;
      iSL   := Integer(Image1.Picture.Bitmap.Scanline[0]);
      iSoff := Integer(Image1.Picture.Bitmap.Scanline[1]) - iSL;
      actN  := 1;
      xFrom := 0;
      bDrawCIdone := False;
      yh    := (Image1.Height * 2) div 5;
      sm    := Image1.Width / 32767;
      if bOutside then xTo := Round(LCols[1].Position * sm)
                  else xTo := Round(ICols[1].Position * sm);
      if bOutside then Shape1.Brush.Color := LCols[0].ColorSpe and $FFFFFF
                  else Shape1.Brush.Color := ICols[0].Color and $FFFFFF;
      Shape11.Brush.Color := LCols[0].ColorDif;
      if bOutside then Shape21.Brush.Color := TransparencyToColor(LCols[0].ColorSpe)
                  else Shape21.Brush.Color := TransparencyToColor(ICols[0].Color);
      for x := 0 to Image1.Width - 1 do
      begin
        if x > xTo then
        begin
          if actN < n then
          begin
            Inc(actN);
            xFrom := xTo;
            if actN >= n then xTo := Image1.Width - 1
            else if bOutside then xTo := Round(LCols[actN].Position * sm)
                             else xTo := Round(ICols[actN].Position * sm);
            if xTo <= xFrom then xTo := xFrom + 1;
            S := FindComponent('Shape' + IntToStr(actN)) as TShape;
            il := Image1.Left + xFrom - ShapeWidD2;
            S.Left := il;
            if not bOutside then
            begin
              S.Brush.Color := ICols[actN - 1].Color and $FFFFFF;
              S := FindComponent('Shape' + IntToStr(actN + 20)) as TShape;
              S.Left := il;
              S.Brush.Color := TransparencyToColor(ICols[actN - 1].Color);
            end
            else
            begin
              S.Brush.Color := LCols[actN - 1].ColorSpe and $FFFFFF;
              S := FindComponent('Shape' + IntToStr(actN + 10)) as TShape;
              S.Left := il;
              S.Brush.Color := LCols[actN - 1].ColorDif;
              S := FindComponent('Shape' + IntToStr(actN + 20)) as TShape;
              S.Left := il;
              S.Brush.Color := TransparencyToColor(LCols[actN - 1].ColorSpe);
            end;
          end;
        end;
        w1 := 1 - (x - xFrom) / (xTo - xFrom);
        iSL2 := iSL;
        if bNoColIpol then n2 := actN - 1 else
        if bOutside then n2 := actN mod 10 else n2 := actN and 3;
        if bOutside then C := cIpol2colFlip(TransparencyToColor(LCols[actN - 1].ColorSpe),
                                            TransparencyToColor(LCols[n2].ColorSpe), w1)
                    else C := cIpol2colFlip(TransparencyToColor(ICols[actN - 1].Color),
                                            TransparencyToColor(ICols[n2].Color), w1);
        for y := 0 to (yh div 2) - 1 do
        begin
          PCardinal(iSL2)^ := C;
          Inc(iSL2, iSoff);
        end;
        if bOutside then C := cIpol2colFlip(LCols[actN - 1].ColorSpe, LCols[n2].ColorSpe, w1)
                    else C := cIpol2colFlip(ICols[actN - 1].Color, ICols[n2].Color, w1);
        for y := yh div 2 to yh - 1 do
        begin
          PCardinal(iSL2)^ := C;
          Inc(iSL2, iSoff);
        end;
        if bOutside then C := cIpol2colFlip(LCols[actN - 1].ColorDif, LCols[n2].ColorDif, w1);
        if (not bDrawCIdone) and (X = DrawXindex) then
        begin
          bDrawCIdone := True;
          Shape31.Brush.Color := FlipRBCol(C);
        end;
        for y := yh to Image1.Height - 1 do
        begin
          PCardinal(iSL2)^ := C;
          Inc(iSL2, iSoff);
        end;
        Inc(iSL, 4);
      end;
      if bOutside then
      begin
        Shape10.Brush.Color := LCols[9].ColorSpe and $FFFFFF;
        Shape10.Left := Image1.Left + Round(LCols[9].Position * sm) - ShapeWidD2;
        Shape20.Brush.Color := LCols[9].ColorDif;
        Shape20.Left := Shape10.Left;
        Shape30.Brush.Color := TransparencyToColor(LCols[9].ColorSpe);
        Shape30.Left := Shape10.Left;
      end
      else
      begin
        Shape24.Brush.Color := TransparencyToColor(ICols[3].Color);
        Shape4.Brush.Color := ICols[3].Color and $FFFFFF;
        Shape4.Left := Image1.Left + Round(ICols[3].Position * sm) - ShapeWidD2;
        Shape24.Left := Shape4.Left;
      end;
      Image1.Picture.Bitmap.Modified := True;
      Invalidate;
      if Iupdate and CheckBox2.Checked then TriggerRepaint;
    end;
end;

procedure TColorForm.FormShow(Sender: TObject);
var bTmp: Boolean;
begin
    PLight := @LightAdjustForm.LAtmpLight;
    ShapeWidD2 := (Shape1.Width + 1) div 2;
    actShape := 0;
    DrawXindex := -1;
    bOutside := RadioGroup1.ItemIndex = 0;
    SetImageSize;
    bTmp := CheckBox2.Checked;
    CheckBox2.Checked := False;
    RepaintImage(PLight, False);
    CheckBox2.Checked := bTmp;
    LightAdjustForm.ColorFormCreated := True;
end;

procedure TColorForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if ssLeft in Shift then
    begin
      Shape31.Brush.Style := bsSolid;
      DrawXindex := X;
      Mand3DForm.DrawInOutside := RadioGroup1.ItemIndex;
      Mand3DForm.DrawColSIndex := {Clamp01S}(X / Image1.Width);
      RepaintImage(PLight, False);
    end;
end;

procedure TColorForm.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var t, c: Integer;
begin
    t := (Sender as TShape).Tag;
    if ssLeft in Shift then
    begin
      GetCursorPos(SstartPos);
      actShape := t;
    end else if t < 21 then
    begin  //color choose
      if t > 10 then ColorDialog1.Color := PLight.LCols[t - 11].ColorDif else
      if bOutside then ColorDialog1.Color := PLight.LCols[t - 1].ColorSpe and $FFFFFF
                  else ColorDialog1.Color := PLight.ICols[t - 1].Color and $FFFFFF;
      if ColorDialog1.Execute then
      begin
        c := ColorToRGB(ColorDialog1.Color);
        if t > 10 then PLight.LCols[t - 11].ColorDif := c else
        if bOutside then PLight.LCols[t - 1].ColorSpe := (PLight.LCols[t - 1].ColorSpe and $FF000000) or c
                    else PLight.ICols[t - 1].Color := (PLight.ICols[t - 1].Color and $FF000000) or c;
        RepaintImage(PLight, True);
      end;
    end
    else
    begin
      if bOutside then c := PLight.LCols[t - 21].ColorSpe shr 24
                  else c := PLight.ICols[t - 21].Color shr 24;
      if GetIntensity(c) then
      begin
        if bOutside then PLight.LCols[t - 21].ColorSpe := (PLight.LCols[t - 21].ColorSpe and $FFFFFF) or (c shl 24)
                    else PLight.ICols[t - 21].Color := (PLight.ICols[t - 21].Color and $FFFFFF) or (c shl 24);
        RepaintImage(PLight, True);
      end;
    end;
end;

procedure TColorForm.Shape1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var t, xplus, xnew, xx, xp, pt, n: Integer;
    S, S2: TShape;
    aPos: TPoint;
    smul: Single;
    LC: TLCol8;
    IC: TICol8;
begin              //change positions, glued or not + repaint
    if (ssLeft in Shift) and (actShape > 0) then
    begin
      if bOutside then n := 10 else n := 4;
      GetCursorPos(aPos);
      S := FindComponent('Shape' + IntToStr(actShape)) as TShape; //Sender as TShape;
      t := actShape;
      if (t > 0) and (t < 21) then
      begin
        If TrackBarEx1.Visible then TrackBarEx1.Visible := False;
        if t > 10 then pt := (t - 11) * 2 else pt := (t - 1) * 2;
        if t > 10 then S2 := FindComponent('Shape' + IntToStr(t - 10)) as TShape
                  else S2 := FindComponent('Shape' + IntToStr(t + 10)) as TShape;
        xnew := S.Left + aPos.X - SstartPos.X;
        if xnew < Image1.Left - ShapeWidD2 + pt then xnew := Image1.Left - ShapeWidD2 + pt else
        if xnew > Image1.Left + Image1.Width - ShapeWidD2 + pt - (n - 1) * 2 then
          xnew := Image1.Left + Image1.Width - ShapeWidD2 + pt - (n - 1) * 2;
        xplus := xnew - S.Left;

        S.Left := S.Left + xplus;
        if bOutside then S2.Left := S2.Left + xplus;
        SstartPos.X := SstartPos.X + xplus;
        if t > 10 then Dec(t, 11) else Dec(t);
        smul := 32767 / Image1.Width;
        if bOutside then
        begin
          pt := PLight.LCols[t].Position;
          PLight.LCols[t].Position := pt + Round(smul * xplus);
        end else begin
          pt := PLight.ICols[t].Position;
          PLight.ICols[t].Position := pt + Round(smul * xplus);
        end;
        if CheckBox1.Checked then  //rubberband
        begin
          if pt < 1 then pt := 1 else if pt > 32766 then pt := 32766;
          for xx := 1 to n - 1 do if xx <> t then
          begin
            if bOutside then
            begin
              if xx < t then xp := Round(smul * xplus * PLight.LCols[xx].Position / pt)
                        else xp := Round(smul * xplus * (32767 - PLight.LCols[xx].Position) / (32767 - pt));
            end else begin
              if xx < t then xp := Round(smul * xplus * PLight.ICols[xx].Position / pt)
                        else xp := Round(smul * xplus * (32767 - PLight.ICols[xx].Position) / (32767 - pt));
            end;
            if Abs(xp) > Round(Abs(smul * xplus)) then xp := Sign(xp) * Round(Abs(smul * xplus));
            if bOutside then
              PLight.LCols[xx].Position := Max(0, Min(32767, PLight.LCols[xx].Position + xp))
            else PLight.ICols[xx].Position := Max(0, Min(32767, PLight.ICols[xx].Position + xp));
          end;
        end else begin  //proof if position has changed and flip colors + positions
          while True do
          begin
            if bOutside then
            begin
              xp := PLight.LCols[t].Position;
              if (t > 1) and (xp < PLight.LCols[t - 1].Position) then
              begin
                LC := PLight.LCols[t - 1];
                PLight.LCols[t - 1] := PLight.LCols[t];
                PLight.LCols[t] := LC;
                Dec(t);
              end
              else if (t < 9) and (xp > PLight.LCols[t + 1].Position) then
              begin
                LC := PLight.LCols[t + 1];
                PLight.LCols[t + 1] := PLight.LCols[t];
                PLight.LCols[t] := LC;
                Inc(t);
              end
              else Break;
            end else begin
              xp := PLight.ICols[t].Position;
              if (t > 1) and (xp < PLight.ICols[t - 1].Position) then
              begin
                IC := PLight.ICols[t - 1];
                PLight.ICols[t - 1] := PLight.ICols[t];
                PLight.ICols[t] := IC;
                Dec(t);
              end
              else if (t < 3) and (xp > PLight.ICols[t + 1].Position) then
              begin
                IC := PLight.ICols[t + 1];
                PLight.ICols[t + 1] := PLight.ICols[t];
                PLight.ICols[t] := IC;
                Inc(t);
              end
              else Break;
            end;
          end;
          actShape := t + 1;
        end;
        RepaintImage(PLight, True);
      end;
    end;
end;

procedure TColorForm.Shape21MouseEnter(Sender: TObject);
begin
    TrackBarEx1.Tag := (Sender as TShape).Tag;
    TrackBarEx1.Left := (Sender as TShape).Left + (Sender as TShape).Width;
    if TrackBarEx1.Tag in [21..30] then
    begin
      if bOutside then
        TrackBarEx1.Position := PLight.LCols[TrackBarEx1.Tag - 21].ColorSpe shr 24
      else TrackBarEx1.Position := PLight.ICols[TrackBarEx1.Tag - 21].Color shr 24;
    end;
    TrackBarEx1.Visible := True;
end;

function TColorForm.MouseOnTrackBE1: LongBool;
var mpos: TPoint;
begin
    GetCursorPos(mpos);
    mpos := TrackBarEx1.ScreenToClient(mpos);
    Result := (mpos.X >= 0) and (mpos.Y >= 0) and
              (mpos.X <= TrackBarEx1.Width) and (mpos.Y < TrackBarEx1.Height);
end;

procedure TColorForm.FormCreate(Sender: TObject);
begin
    DoubleBuffered := True;
    bColCopied := False;
    RandMidCol[0] := $808080;
    RandMidCol[1] := $808080;               // TBS_DOWNISLEFT
//    SetWindowLong(TrackBarEx1.Handle, GWL_STYLE, $400 or GetWindowLong(TrackBarEx1.Handle, GWL_STYLE)); //does not work
end;

procedure TColorForm.FormPaint(Sender: TObject);
var xa, xe, xm, ya, ye, i, n: Integer;
   S: TShape;
begin
    if bOutside then n := 10 else n := 4;
    for i := 1 to n do
    begin
      S := FindComponent('Shape' + IntToStr(i)) as TShape;
      xa := S.Left + ShapeWidD2 - 4;
      xe := xa + 6;
      ya := Image1.Top + Image1.Height;
      ye := S.Top;
      xm := S.Left + ShapeWidD2 - 1;
      Canvas.Pen.Color := clBlack;
      Canvas.MoveTo(xa, ye);
      Canvas.LineTo(xm, ya);
      Canvas.LineTo(xe, ye);
    end;
end;

function TColorForm.MakeSatCol(var sat, pr, pg, pb: Single): Cardinal;
var r, g, b: Single;
begin
    r := Power(Random, pr) * 255;
    g := Power(Random, pg) * 255;
    b := Power(Random, pb) * 255;
    r := Max(0, Min(255, (r - (RandMidCol[0] and $FF)) * sat + (RandMidCol[0] and $FF)));
    g := Max(0, Min(255, (g - ((RandMidCol[0] shr 8) and $FF)) * sat + ((RandMidCol[0] shr 8) and $FF)));
    b := Max(0, Min(255, (b - ((RandMidCol[0] shr 16) and $FF)) * sat + ((RandMidCol[0] shr 16) and $FF)));
    Result := Round(r) or (Round(g) shl 8) or (Round(b) shl 16);
end;

procedure TColorForm.Button1Click(Sender: TObject);   // diffuse colors
var i: Integer;
    d1, d2, d3, s: Single;
begin
    s  := StrToFloatK(Edit1.Text);
    d1 := Max(0.05, Min(0.95, (RandMidCol[0] and $FF) / 255));
    d2 := Max(0.05, Min(0.95, ((RandMidCol[0] shr 8) and $FF) / 255));
    d3 := Max(0.05, Min(0.95, ((RandMidCol[0] shr 16) and $FF) / 255));
    d1 := LogN(0.5, d1);
    d2 := LogN(0.5, d2);
    d3 := LogN(0.5, d3);
    if bOutside then
    for i := 0 to 9 do PLight.LCols[i].ColorDif := MakeSatCol(s, d1, d2, d3)
    else for i := 0 to 3 do PLight.ICols[i].Color := (PLight.ICols[i].Color and $FF000000) or MakeSatCol(s, d1, d2, d3);
    RepaintImage(PLight, True);
end;

procedure TColorForm.Button2Click(Sender: TObject);  // specular colors
var i: Integer;
    r1, r2, s: Single;
    ct: Cardinal;
    sv1, sv2: TSVec;
const cs128: TSVec = (128, 128, 128, 0);
begin
    for i := 0 to 9 do
    begin
      s  := Max(0, Min(3, StrToFloatK(Edit2.Text)));
      r1 := Cos(Random * 2 * Pi) * 0.5 + 0.5;
      r2 := Min(1, Max(1, s) - Random * s);
      ct := InterpolateColor($FFFFFF, 0 , r1, 1- r1);
      r2 := Sqrt(r2);
      sv1 := AddSVectors(ScaleSVector(SubtractSVectors(@cs128, ColToSVecNoScale(ct)), s),
                         ColToSVecNoScale(RandMidCol[1]));
      sv2 := ColToSVecNoScale(PLight.LCols[i].ColorDif);
      PLight.LCols[i].ColorSpe := (PLight.LCols[i].ColorSpe and $FF000000) or
                    SVecToColNoScale(Interpolate2Scols(@sv1, @sv2, r2, 1 - r2));
    end;
    RepaintImage(PLight, True);
end;

procedure TColorForm.Button3Click(Sender: TObject);
begin
    TriggerRepaint;
end;

procedure TColorForm.CheckBox3Click(Sender: TObject);
begin
    if CheckBox3.Checked then
    begin
      if DrawXindex >= 0 then
      begin
        Shape31.Brush.Style := bsSolid;
        RepaintImage(PLight, False);
      end;
      //disable m3dbuttons...
      Mand3DForm.MButtonsUp;
      Mand3DForm.Image1.Cursor := crCross;
      Mand3DForm.Shape2.Visible := True;
      Image1.Cursor := crCross;
    end
    else
    begin
      Shape31.Brush.Style := bsClear;
      Mand3DForm.SetImageCursor;
      Mand3DForm.Shape2.Visible := False;
      Image1.Cursor := crDefault;
    end;
end;

procedure TColorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var C   : TControl;
    MPos: TPoint;
    t, m: Integer;
begin
    if Key in [66, 67, 86] then
    begin
      GetCursorPos(MPos);
      C := ControlAtPos(ScreenToClient(Point(MPos.X, MPos.Y)), False, False);
      if (C <> nil) and (C is TShape) then
      begin
        t := (C as TShape).Tag;
        m := (t - 1) mod 10;
        if (t > 0) and (t < 31) then
        case Key of
          66:  if bColCopied then   //B
               begin      //paste 1 color
                 if t > 20 then
                 begin
                   if bOutside then PLight.LCols[m].ColorSpe := (PLight.LCols[m].ColorSpe and $FFFFFF) or (ColCopy and $FF000000)
                               else PLight.ICols[m].Color := (PLight.ICols[m].Color and $FFFFFF) or (ColCopy and $FF000000);
                 end
                 else if t > 10 then PLight.LCols[m].ColorDif := ColCopy and $FFFFFF else
                 if bOutside then PLight.LCols[m].ColorSpe := (PLight.LCols[m].ColorSpe and $FF000000) or (ColCopy and $FFFFFF)
                             else PLight.ICols[m].Color := (PLight.ICols[m].Color and $FF000000) or (ColCopy and $FFFFFF);
                 RepaintImage(PLight, True);
               end;
          67:  begin   //c copy  color
                 if bOutside then ColCopy2 := PLight.LCols[m].ColorSpe
                             else ColCopy2 := PLight.ICols[m].Color;
                 ColCopy1 := PLight.LCols[m].ColorDif;
                 if t > 10 then ColCopy := ColCopy1 or (ColCopy2 and $FF000000)
                           else ColCopy := ColCopy2;
                 bColCopied := True;
               end;
          86:  if bColCopied then
               begin        //v paste bothcolors
                 if bOutside then
                 begin
                   PLight.LCols[m].ColorDif := ColCopy1;
                   PLight.LCols[m].ColorSpe := ColCopy2;
                 end
                 else PLight.ICols[m].Color := ColCopy2;
                 RepaintImage(PLight, True);
               end;
        end;
      end;
    end;
end;

procedure TColorForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    if TrackBarEx1.Visible and not MouseOnTrackBE1 then
    begin
      TrackBarEx1.Tag := 0;
      TrackBarEx1.Visible := False;
    end;
end;

procedure TColorForm.RadioGroup1Click(Sender: TObject);
var i: Integer;
begin
    bOutside := RadioGroup1.ItemIndex = 0;
    Edit2.Visible := bOutside;
    Button2.Visible := bOutside;
    SpeedButton2.Visible := bOutside;
    Label1.Visible := bOutside;
    Label2.Visible := bOutside;
    Label4.Visible := not bOutside;
    if bOutside then Label5.Caption := 'Transparency'
                else Label5.Caption := 'Transparency + Specular';
    for i := 5 to 20 do (FindComponent('Shape' + IntToStr(i)) as TShape).Visible := bOutSide;
    for i := 25 to 30 do (FindComponent('Shape' + IntToStr(i)) as TShape).Visible := bOutSide;
    RepaintImage(PLight, False);
end;

procedure TColorForm.FormHide(Sender: TObject);
begin
    LightAdjustForm.SetSDButtonColors;
    CheckBox3.Checked := False;
end;

procedure TColorForm.SpeedButton1Click(Sender: TObject);
begin
   ColorDialog1.Color := RandMidCol[(Sender as TSpeedButton).Tag];
   if ColorDialog1.Execute then
   with (Sender as TSpeedButton).Glyph.Canvas do
   begin
     RandMidCol[(Sender as TSpeedButton).Tag] := ColorToRGB(ColorDialog1.Color);
     Brush.Color := RandMidCol[(Sender as TSpeedButton).Tag];
     FillRect(Rect(2, 1, 14, 13));
   end;
end;

procedure TColorForm.SpeedButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if ssRight in Shift then SpeedButton1Click(Sender);
end;

procedure TColorForm.TrackBarEx1Change(Sender: TObject);
var t, ie: Integer;
    c: Cardinal;
begin
    t := (Sender as TTrackBarEx).Tag;
    if bOutside then ie := 30 else ie := 24;
    if t in [21..ie] then
    begin
      c := TrackBarEx1.Position and 255;         //rangecheck error
      if bOutside then PLight.LCols[t - 21].ColorSpe := (PLight.LCols[t - 21].ColorSpe and $FFFFFF) or (c shl 24)
                  else PLight.ICols[t - 21].Color := (PLight.ICols[t - 21].Color and $FFFFFF) or (c shl 24);
      UpdateShapeCol(t, c or (c shl 8) or (c shl 16));
    end;
end;

procedure TColorForm.TrackBarEx1Exit(Sender: TObject);
begin
    TrackBarEx1.Visible := False;
    RepaintImage(PLight, True);
end;

procedure TColorForm.TrackBarEx1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    RepaintImage(PLight, True);
end;

end.
