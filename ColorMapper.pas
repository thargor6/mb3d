////////////////////////////////////////////////////////////////////////////////
//
// ColorMapper.pas - Color mapping and histogram calculations for TLinearBitmap
// ----------------------------------------------------------------------------
// Version:   2003-01-25
// Maintain:  Michael Vinther         mv@logicnet·dk
//
// Last changes:
//   AutoBlackWhitePoint added
//   Apply palette fixed
//
unit ColorMapper;

interface

uses Windows, Classes, SysUtils, Graphics, Streams, LinarBitmap, Monitor, MathUtils;

const
  BluePlane  = 0;
  GreenPlane = 1;
  RedPlane   = 2;
  AllPlanes  = 3;

type
  TColorMapList = packed array[0..255] of Byte;
  TColorMap = object
                Map : TColorMapList;

                procedure SetDirect; // Output = Input
                procedure SetNegative; // Output = 255-Input
                procedure SetBrightnessContrast(Brightness,Contrast: Integer); // [-127 : 127]
                procedure SetBrightnessContrastCourve(Brightness,Contrast: Integer; var Courve: array of TPoint); // [-127 : 127]
                procedure SetBlackWhitePoint(Black,White: Integer); // [-255 : 255]
                procedure SetGamma(Gamma: Double);
                procedure Threshold(Value: Integer); // [-255;255]
                procedure SetZeroPoint(Point: Integer); // [0;255]
                procedure Quantize(Levels: Integer); // [2;256]
                procedure SmoothCourve(const Points: array of TPoint); // Minimum 5 points
                procedure Add(A: Integer);

                // Produce color mapping to first apply Self and then ColorMap2
                procedure Combine(var ColorMap2: TColorMap);

                procedure Apply(Image: TLinearBitmap; Plane: Integer=AllPlanes); overload;
                procedure Apply(Palette: PPalette; Plane: Integer=AllPlanes); overload;
                procedure Apply(OrgMap: PByteArray; NewImage: TLinearBitmap; Plane: Integer=AllPlanes); overload;

                procedure SaveToStream(Stream: TBaseStream);
                procedure LoadFromStream(Stream: TBaseStream);
                procedure SaveToFile(const FileName: string);
                procedure LoadFromFile(const FileName: string);
              end;

  THistogramStat = array[0..255] of DWord;
  THistogram = object
                 Stat : THistogramStat;
                 Count : DWord;

                 procedure Reset;

                 // Find maximum height
                 function Max: DWord;

                 // Calculate histogram
                 procedure Calc(Image: TLinearBitmap; Plane: Integer=AllPlanes); overload;
                 procedure Calc(Image: TLinearBitmap; const Rect: TRect; Plane: Integer=AllPlanes); overload;

                 // Update histogram to follow an image where ColorMap is applied to
                 procedure Update(const ColorMap: TColorMap);

                 // Color statistics
                 procedure GetStat(var MinCol,MaxCol: Byte; var Mean,StdDev: Double);
                 function Variance(First: Byte=0; Last: Byte=255): Double;

                 // Equalize histogram, ResultLevels must be 256 so far
                 procedure Equalize(var Map: TColorMap; Levels: Integer=256);

                 // Find the gamma setting that gvies the closest match to an equalized histogram
                 function BestGamma: Double;

                 // Auto adjust black and white points
                 procedure GetBlackWhitePoint(PixelsOut: Integer; out Black, White: Integer);

                 // Get equlized value for single color
                 function EqualizeColor(Color: Byte): Byte;

                 function MostUsedColor: Byte;
                 function CountColorsUsed: Integer;
                 function SplitBimodalHistogram: Byte;
               end;

function CountColorsUsed(Image: TLinearBitmap): Integer;

// Find the gamma setting that gvies the closest match to an equalized histogram
var AllRect : TRect = (Left:0);
procedure AutoColorCorrection(Image: TLinearBitmap; AnalyzeRect: TRect; SplitPlanes: Boolean=False);
procedure AutoBlackWhitePoint(Image: TLinearBitmap);

procedure AdjustSaturationGamma(Image: TLinearBitmap; Saturation: Double; GammaR: Double=1; GammaG: Double=0; GammaB: Double=0);

implementation

uses MemUtils, Math;

function CountColorsUsed(Image: TLinearBitmap): Integer;
type
  Pix24Rec = packed record
               A : Word;
               B : Byte;
             end;
var
  I : Integer;
  Pix : ^Pix24Rec;
  P : ^Byte;
  Histogram : THistogram;
  ColorsFound : PByteArray;
begin
  if Image.PixelFormat=pf24bit then
  begin
    GetMem(ColorsFound,256*256*256 div 8);
    try
      ZeroMem(ColorsFound^,256*256*256 div 8);
      Result:=0;
      Pix:=@Image.Map^;
      for I:=1 to Image.Size div 3 do
      begin
        P:=@ColorsFound^[(Pix^.A shl 5) or (Pix^.B shr 3)];
        if not Boolean((P^ shr (Pix^.B and 7)) and 1) then
        begin
          P^:=P^ or (1 shl (Pix^.B and 7));
          Inc(Result);
        end;
        Inc(Pix);
      end;
    finally
      FreeMem(ColorsFound);
    end;
  end
  else
  begin
    Histogram.Calc(Image);
    Result:=Histogram.CountColorsUsed;
  end;
end;

procedure AutoColorCorrection(Image: TLinearBitmap; AnalyzeRect: TRect; SplitPlanes: Boolean);
var
  Histogram : THistogram;
  ColorMap, GammaMap : TColorMap;
  P, Black, White : Integer;
  Gamma, GammaR, GammaG, GammaB, Saturation : Double;
begin
  if (AnalyzeRect.Right>=Image.Width) then AnalyzeRect.Right:=Image.Width-1;
  if (AnalyzeRect.Bottom>=Image.Height) then AnalyzeRect.Bottom:=Image.Height-1;
  if (AnalyzeRect.Left<0) or (AnalyzeRect.Top<0) or (AnalyzeRect.Right-AnalyzeRect.Left<2) or (AnalyzeRect.Bottom-AnalyzeRect.Top<2) then
    AnalyzeRect:=Rect(0,0,Image.Width-1,Image.Height-1);

  if Image.PixelFormat=pf8bit then // 8 bit
  begin
    Histogram.Calc(Image,AnalyzeRect);
    Histogram.GetBlackWhitePoint(Histogram.Count div 10000,Black,White);
    ColorMap.SetBlackWhitePoint(Black,White);
    Histogram.Update(ColorMap);
    GammaMap.SetGamma(Histogram.BestGamma);
    ColorMap.Combine(GammaMap);
    ColorMap.Apply(Image);
  end
  else if SplitPlanes then // 24 bit, split planes
  begin
    for P:=1 to 3 do
    begin
      Histogram.Calc(Image,AnalyzeRect,P);
      Histogram.GetBlackWhitePoint(Histogram.Count div 10000,Black,White);
      ColorMap.SetBlackWhitePoint(Black,White);
      ColorMap.Apply(Image,P);
    end;

    Histogram.Calc(Image,AnalyzeRect,RedPlane);   GammaR:=Histogram.BestGamma;
    Histogram.Calc(Image,AnalyzeRect,GreenPlane); GammaG:=Histogram.BestGamma;
    Histogram.Calc(Image,AnalyzeRect,BluePlane);  GammaB:=Histogram.BestGamma;
    Gamma:=(GammaR+GammaG+GammaB)/3;
    if Gamma<1 then Saturation:=1 else Saturation:=Power(Gamma,1/Gamma);
    AdjustSaturationGamma(Image,Saturation,GammaR,GammaG,GammaB);
  end
  else // 24 bit
  begin
    Histogram.Calc(Image,AnalyzeRect);
    Histogram.GetBlackWhitePoint(Histogram.Count div 10000,Black,White);
    ColorMap.SetBlackWhitePoint(Black,White);
    ColorMap.Apply(Image);

    Histogram.Calc(Image,AnalyzeRect);
    Gamma:=Histogram.BestGamma;
    if Gamma<1 then Saturation:=1
    else Saturation:=Power(Gamma,0.5/Gamma);
    AdjustSaturationGamma(Image,Saturation,Gamma);
  end;
end;

procedure AutoBlackWhitePoint(Image: TLinearBitmap);
var
  Histogram : THistogram;
  ColorMap : TColorMap;
  Black, White : Integer;
begin
  Histogram.Calc(Image);
  Histogram.GetBlackWhitePoint(Histogram.Count div 10000,Black,White);
  ColorMap.SetBlackWhitePoint(Black,White);
  ColorMap.Apply(Image);
end;

procedure AdjustSaturationGamma(Image: TLinearBitmap; Saturation,GammaR,GammaG,GammaB: Double);
var
  P, Res : Integer;
  Pix : ^RGBRec;
  I, R, G, B : Double;
  GammaMapR, GammaMapG, GammaMapB : array[0..255] of Double;
  ColorMap : TColorMap;
begin
  if Image.PixelFormat=pf24bit then
  begin
    GammaR:=1/GammaR;
    if GammaG=0 then GammaG:=GammaR else GammaG:=1/GammaG;
    if GammaB=0 then GammaB:=GammaR else GammaB:=1/GammaB;
    GammaMapR[0]:=0; GammaMapG[0]:=0; GammaMapB[0]:=0;
    for P:=1 to 255 do
    begin
      GammaMapR[P]:=Power(P/255,GammaR)*255;
      GammaMapG[P]:=Power(P/255,GammaG)*255;
      GammaMapB[P]:=Power(P/255,GammaB)*255;
    end;

    Pix:=@Image.Map^;
    for P:=1 to Image.Size div 3 do
    begin
      R:=GammaMapR[Pix^.R]; G:=GammaMapG[Pix^.G]; B:=GammaMapB[Pix^.B];
      I:=(R*2+G*3+B)/6;
      //I:=R*0.299+G*0.587+B*0.114;
      //I:=(R+B+G)/3;

      Res:=Round(I+(R-I)*Saturation);
      if Res<0 then Res:=0 else if Res>255 then Res:=255;
      Pix^.R:=Res;
      Res:=Round(I+(G-I)*Saturation);
      if Res<0 then Res:=0 else if Res>255 then Res:=255;
      Pix^.G:=Res;
      Res:=Round(I+(B-I)*Saturation);
      if Res<0 then Res:=0 else if Res>255 then Res:=255;
      Pix^.B:=Res;

      Inc(Pix);
    end
  end
  else if (GammaR<>0) and (GammaR<>1) then
  begin
    ColorMap.SetGamma(GammaR);
    ColorMap.Apply(Image);
  end;
end;

//==================================================================================================
// THistogram
//==================================================================================================

procedure THistogram.Reset;
begin
  Count:=0;
  ZeroMem(Stat,SizeOf(Stat));
end;

procedure THistogram.Calc(Image: TLinearBitmap; Plane: Integer);
var
  Planes, P : Integer;
  Pix : ^Byte;
begin
  if Plane=AllPlanes then
  begin
    Plane:=0;
    Planes:=1;
  end
  else if Image.PixelFormat=pf24bit then Planes:=3
  else Planes:=1;
  Count:=Image.Size div Planes;

  ZeroMem(Stat,SizeOf(Stat));
  Pix:=@Image.Map^[Plane];
  for P:=1 to Count do
  begin
    Inc(Stat[Pix^]);
    Inc(Pix,Planes);
  end;
end;

procedure THistogram.Calc(Image: TLinearBitmap; const Rect: TRect; Plane: Integer=AllPlanes);
var
  Planes, X, Y, LineStart, LineCount : Integer;
  Pix : ^Byte;
begin
  if (Plane=AllPlanes) or (Image.PixelFormat=pf8bit) then
  begin
    Planes:=1;
    if Image.PixelFormat=pf24bit then
    begin
      LineStart:=Rect.Left*3;
      LineCount:=(Rect.Right-Rect.Left+1)*3;
    end
    else // 8 bit
    begin
      LineStart:=Rect.Left;
      LineCount:=Rect.Right-Rect.Left+1;
    end;
  end
  else // 24 bit, one plane
  begin
    Planes:=3;
    LineStart:=Plane+Rect.Left*3;
    LineCount:=Rect.Right-Rect.Left+1;
  end;
  ZeroMem(Stat,SizeOf(Stat));
  for Y:=Rect.Top to Rect.Bottom do
  begin
    Pix:=@Image.Map^[Y*Image.BytesPerLine+LineStart];
    for X:=1 to LineCount do
    begin
      Inc(Stat[Pix^]);
      Inc(Pix,Planes);
    end;
  end;
  Count:=LineCount*(Rect.Bottom-Rect.Top+1);
end;

procedure THistogram.Update(const ColorMap: TColorMap);
var
  OldStat : THistogramStat;
  Col : Integer;
begin
  OldStat:=Stat;
  ZeroMem(Stat,SizeOf(Stat));
  for Col:=0 to 255 do Inc(Stat[ColorMap.Map[Col]],OldStat[Col]);
end;

// Find maximum height
function THistogram.Max: DWord;
var Col : Integer;
begin
  Result:=Stat[0];
  for Col:=1 to 255 do if Stat[Col]>Result then Result:=Stat[Col];
end;

procedure THistogram.GetStat(var MinCol,MaxCol: Byte; var Mean,StdDev: Double);
var
  Col : DWord;
  Sum, SqrSum : Int64;
begin
  MinCol:=255;
  MaxCol:=0;
  Sum:=0;
  SqrSum:=0;
  for Col:=0 to 255 do
  begin
    if (Col>MaxCol) and (Stat[Col]>0) then MaxCol:=Col;
    if (Col<MinCol) and (Stat[Col]>0) then MinCol:=Col;
    Inc(Sum,Stat[Col]*Col);
    Inc(SqrSum,Int64(Stat[Col])*Sqr(Col));
  end;
  Mean:=Sum/Count;
  StdDev:=Sqrt(SqrSum/Count-Sqr(Mean));
end;

function THistogram.Variance(First,Last: Byte): Double;
var
  Col, PixCount : DWord;
  Sum, SqrSum : Int64;
begin
  Sum:=0; SqrSum:=0; PixCount:=0;
  for Col:=First to Last do
  begin
    Inc(PixCount,Stat[Col]);
    Inc(Sum,Stat[Col]*Col);
    Inc(SqrSum,Int64(Stat[Col])*Sqr(Col));
  end;
  if PixCount>0 then Variance:=SqrSum/PixCount-Sqr(Sum/PixCount)
  else Variance:=1e50;
end;

function THistogram.SplitBimodalHistogram: Byte;
var
  Col : DWord;
  CurVar, BestVar : Double;
begin
  BestVar:=1e50; Result:=0;
  for Col:=1 to 254 do
  begin
    CurVar:=Variance(0,Col)+Variance(Col,255);
    if CurVar<BestVar then
    begin
      BestVar:=CurVar;
      Result:=Col;
    end;
  end;
end;

procedure THistogram.Equalize(var Map: TColorMap; Levels: Integer);
var
  Col, Sum, Offset, L : Integer;
  H : Double;
begin
  Sum:=0;
  Offset:=Round(Stat[0]/Count*255);
  if Offset=255 then Offset:=127;
  for Col:=0 to 255 do
  begin
    Inc(Sum,Stat[Col]);
    H:=(Sum*255.0/Count-Offset)/(255-Offset)*255; // Equalize
    L:=Trunc(H*Levels/256)*256 div (Levels-1); // Quantize
    if L>255 then L:=255;
    Map.Map[Col]:=L;
  end;
end;

function THistogram.BestGamma: Double;
const
  MinGamma   = 0.6;
  MaxGamma   = 2.5;
  GammaSteps = 512;
var
  EqualMap, GammaMap : TColorMap;
  I, C, Diff, BestDiff : Integer;
  Step, Gamma : Double;
//  NewHist : array[0..255] of Integer;
begin
  BestDiff:=High(BestDiff); Result:=1;
  Gamma:=MinGamma;
  Step:=(MaxGamma-MinGamma)/(GammaSteps-1);

  Equalize(EqualMap);
  for I:=1 to GammaSteps do
  begin
    GammaMap.SetGamma(Gamma);
    Diff:=0;
    for C:=0 to 255 do Inc(Diff,Sqr(Integer(EqualMap.Map[C])-GammaMap.Map[C]));
    if Diff<BestDiff then
    begin
      BestDiff:=Diff;
      Result:=Gamma;
    end;
    Gamma:=Gamma+Step;
  end;{}

  {for I:=1 to GammaSteps do
  begin
    GammaMap.SetGamma(Gamma);
    ZeroMem(NewHist,SizeOf(NewHist));
    for C:=0 to 255 do Inc(NewHist[GammaMap.Map[C]],Stat[C]);

    Diff:=0;
    for C:=0 to 255 do Inc(Diff,Abs(NewHist[C]-Count div 256));
    if Diff<BestDiff then
    begin
      Result:=Gamma;
      BestDiff:=Diff;
    end;

    Gamma:=Gamma+Step;
  end;{}
end;

function THistogram.EqualizeColor(Color: Byte): Byte;
var
  Col, Sum, Offset : DWord;
begin
  Sum:=0;
  for Col:=0 to Color do Inc(Sum,Stat[Col]);

  Offset:=Round(Stat[0]/Count*255);
  if Offset=255 then Offset:=0;
  Result:=Round((Sum*255.0/Count-Offset)/(255-Offset)*255);{}

  //Result:=Sum*255 div Count; // Faster, but less accurate
end;

function THistogram.CountColorsUsed: Integer;
var
  Col : Integer;
begin
  Result:=0;
  for Col:=0 to 255 do if Stat[Col]<>0 then Inc(Result);
end;

function THistogram.MostUsedColor: Byte;
var
  Col, Best : DWord;
begin
  Best:=Stat[0];
  Result:=0;
  for Col:=1 to 255 do if Stat[Col]>Best then
  begin
    Best:=Stat[Col];
    Result:=Col;
  end;
end;

procedure THistogram.GetBlackWhitePoint(PixelsOut: Integer; out Black, White: Integer);
var
  C, Sum : Integer;
begin
  Black:=0;
  Sum:=0;
  for C:=0 to 254 do
  begin
    Inc(Sum,Stat[C]);
    if Sum>PixelsOut then
    begin
      Black:=C;
      Break;
    end;
  end;
  White:=255;
  Sum:=0;
  for C:=255 downto Black+1 do
  begin
    Inc(Sum,Stat[C]);
    if Sum>PixelsOut then
    begin
      White:=C;
      Break;
    end;
  end;
end;

//==================================================================================================
// TColorMap
//==================================================================================================

procedure TColorMap.SetDirect;
var Col : Byte;
begin
  for Col:=0 to 255 do Map[Col]:=Col;
end;

procedure TColorMap.Add(A: Integer);
var Col : Byte;
begin
  for Col:=0 to 255 do Map[Col]:=ForceInRange(Col+A,0,255);
end;

procedure TColorMap.SetNegative;
var Col : Byte;
begin
  for Col:=0 to 255 do Map[Col]:=255-Col;
end;

procedure TColorMap.SetBrightnessContrast(Brightness,Contrast: Integer);
var
  //Col, A : Integer;
  Courve : array[0..4] of TPoint;
begin
  {for Col:=0 to 255 do
  begin
    A:=Col;

    A:=A+Brightness;

    if Contrast<=0 then A:=Round(127+(A-127)*(255+Contrast)/255)
    else
    begin
      if A*2<Contrast then A:=0
      else if A*2>511-Contrast then A:=255
      else A:=Round(127+((A-127)/2)*255/(128-Contrast/2));
    end;

    if A<=0 then Map[Col]:=0
    else if A>=255 then Map[Col]:=255
    else Map[Col]:=A;
  end;}
  SetBrightnessContrastCourve(Brightness,Contrast,Courve);
end;

procedure TColorMap.SetBrightnessContrastCourve(Brightness,Contrast: Integer; var Courve: array of TPoint);
const
  ContrastHeight = 40;
  ExtraContrastStart = 74;
var
  ExtraContrast : Integer;
begin
  if Contrast>ExtraContrastStart then
  begin
    Courve[0].X:=-Max(0,Brightness);
    Courve[1].X:=ContrastHeight+ExtraContrastStart-Brightness;
    Courve[2].X:=127-Brightness;
    Courve[3].X:=255-ContrastHeight-ExtraContrastStart-Brightness;
    Courve[4].X:=255-Min(0,Brightness);

    ExtraContrast:=(Contrast-ExtraContrastStart)*2;
    Courve[0].Y:=0;
    Courve[1].Y:=ContrastHeight-ExtraContrast;
    Courve[2].Y:=127;
    Courve[3].Y:=255-ContrastHeight+ExtraContrast;
    Courve[4].Y:=255;
  end
  else if Contrast>=0 then
  begin
    Courve[0].X:=-Max(0,Brightness);
    Courve[1].X:=ContrastHeight+Contrast-Brightness;
    Courve[2].X:=127-Brightness;
    Courve[3].X:=255-ContrastHeight-Contrast-Brightness;
    Courve[4].X:=255-Min(0,Brightness);

    Courve[0].Y:=0;
    Courve[1].Y:=ContrastHeight;
    Courve[2].Y:=127;
    Courve[3].Y:=255-ContrastHeight;
    Courve[4].Y:=255;
  end
  else // Contrast<0
  begin
    Courve[0].X:=-Max(1,Brightness-Contrast);
    Courve[1].X:=ContrastHeight+Contrast-Brightness;
    Courve[2].X:=127-Brightness;
    Courve[3].X:=255-ContrastHeight-Contrast-Brightness;
    Courve[4].X:=256-Min(0,Brightness+Contrast);

    Courve[0].Y:=0;
    Courve[1].Y:=ContrastHeight;
    Courve[2].Y:=127;
    Courve[3].Y:=255-ContrastHeight;
    Courve[4].Y:=255;
    {Courve[0].X:=-Max(0,Brightness);
    Courve[2].X:=127-Brightness;
    Courve[4].X:=255-Min(0,Brightness);

    Courve[0].Y:=-Contrast;
    Courve[2].Y:=127;
    Courve[4].Y:=255+Contrast;

    Courve[1]:=Courve[0];
    Courve[3]:=Courve[4];}
  end;

  SmoothCourve(Courve);
end;

procedure TColorMap.SetBlackWhitePoint(Black,White: Integer); // [-255 : 255]
var
  Col, First, Dist : Integer;
begin
  First:=Black;
  Dist:=White-Black;
  if Black>0 then ZeroMem(Map[0],Black)
  else Black:=0;
  if White<255 then FillChar(Map[White],256-White,255)
  else White:=255;
  if Dist>0 then for Col:=Black to White do Map[Col]:=Round((Col-First)*255/Dist);
end;

procedure TColorMap.SetGamma(Gamma: Double);
var
  Col : Byte;
  A   : Integer;
begin
  Gamma:=1/Gamma;
  Map[0]:=0;
  for Col:=1 to 255 do
  begin
    A:=Round(Power(Col/255,Gamma)*255);

    if A<=0 then Map[Col]:=0
    else if A>=255 then Map[Col]:=255
    else Map[Col]:=A;
  end;
end;

procedure TColorMap.Threshold(Value: Integer);
var
  Col : Byte;
begin
  if Value>=0 then for Col:=0 to 255 do Map[Col]:=Byte(Col<=Value)-1
  else for Col:=0 to 255 do Map[Col]:=Byte(Col>-Value)-1;
end;

procedure TColorMap.SetZeroPoint(Point: Integer);
var
  Col : Byte;
begin
  if Point>0 then for Col:=0 to Point do Map[Col]:=Round(255-Col/Point*255);
  if Point<255 then for Col:=Point to 255 do Map[Col]:=Round((Col-Point)/(255-Point)*255);
end;

procedure TColorMap.Quantize(Levels: Integer);
var
  Col, L : Integer;
begin
  for Col:=0 to 255 do
  begin
    L:=Trunc(Col*Levels/256)*256 div (Levels-1);
    if L>255 then L:=255;
    Map[Col]:=L;
  end;
end;

procedure TColorMap.SmoothCourve(const Points: array of TPoint);

  const
    LineSegs = 384;

  type
    TBlend = array[0..3,1..LineSegs] of Double;

  var
    FirstBlend, Blend, LastBlend : TBlend;
    SM : array[0..3] of TPoint;

  procedure InitBlend;
  var
   U, V, W : Double;
   I       : Integer;
  begin
    for I:=1 to LineSegs do
    begin
      U:=I/LineSegs; V:=U-1; W:=U+1;
      Blend[0,I]:=-U*V*(U-2)/6;
      Blend[1,I]:= W*V*(U-2)/2;
      Blend[2,I]:=-W*U*(U-2)/2;
      Blend[3,I]:= W*U*V/6;
      FirstBlend[0,I]:=-V*(V-1)*(V-2)/6;
      FirstBlend[1,I]:= U*(V-1)*(V-2)/2;
      FirstBlend[2,I]:=-U*V*(V-2)/2;
      FirstBlend[3,I]:= U*V*(V-1)/6;
      LastBlend[0,I]:=-W*U*(W-2)/6;
      LastBlend[1,I]:= (W+1)*U*(W-2)/2;
      LastBlend[2,I]:=-(W+1)*W*(W-2)/2;
      LastBlend[3,I]:= (W+1)*W*U/6;
    end;
  end;

  procedure DrawSegs(var B: TBlend);
  var
    RoundX, I, J : Integer;
    X, Y : Double;
  begin
    for I:=1 to LineSegs do
    begin
      X:=0; Y:=0;
      for J:=0 to 3 do
      begin
        X:=X+SM[J].X*B[J,I];
        Y:=Y+SM[J].Y*B[J,I];
      end;
      RoundX:=Round(X);
      if RoundX in [0..255] then Map[RoundX]:=ForceInRange(Round(Y),0,255);
    end;
  end;

  procedure NextSection;
  var
    I : Integer;
  begin
    for I:=0 to 2 do SM[I]:=SM[I+1];
  end;

var
  I : Integer;
begin
  InitBlend;
  for I:=0 to 3 do SM[I]:=Points[I];
  DrawSegs(FirstBlend);
  DrawSegs(Blend);
  NextSection;
  for I:=4 to High(Points)-1 do
  begin
    SM[3]:=Points[I];
    DrawSegs(Blend);
    NextSection
  end;
  SM[3]:=Points[High(Points)];
  DrawSegs(Blend);
  DrawSegs(LastBlend);
  if Points[0].X in [0..255] then Map[Points[0].X]:=Points[0].Y;
  if Points[High(Points)].X in [0..255] then Map[Points[High(Points)].X]:=Points[High(Points)].Y;
end;


procedure TColorMap.Combine(var ColorMap2: TColorMap);
var
  Col : Integer;
  NewMap : TColorMapList;
begin
  for Col:=0 to 255 do NewMap[Col]:=ColorMap2.Map[Map[Col]];
  Map:=NewMap;
end;

procedure TColorMap.Apply(Image: TLinearBitmap; Plane: Integer);
var
  Planes, P : Integer;
  Pix : ^Byte;
begin
  if Plane=AllPlanes then
  begin
    Plane:=0;
    Planes:=1;
  end
  else if Image.PixelFormat=pf24bit then Planes:=3
  else
  begin
    if Image.PixelFormat=pf8bit then Plane:=0;
    Planes:=1;
  end;

  Pix:=@Image.Map^[Plane];
  for P:=1 to Image.Size div Planes do
  begin
    Pix^:=Map[Pix^];
    Inc(Pix,Planes);
  end;
end;

procedure TColorMap.Apply(Palette: PPalette; Plane: Integer);
var
  Planes, P : Integer;
  Pix : ^Byte;
begin
  if Plane=AllPlanes then
  begin
    Plane:=0;
    Planes:=1;
    P:=768;
  end
  else
  begin
    Planes:=3;
    P:=256;
  end;
  Pix:=@Palette^[Plane];
  for P:=1 to P do
  begin
    Pix^:=Map[Pix^];
    Inc(Pix,Planes);
  end;
end;

procedure TColorMap.Apply(OrgMap: PByteArray; NewImage: TLinearBitmap; Plane: Integer);
var
  Planes, P : Integer;
  Pix, NewPix : ^Byte;
begin
  if Plane=AllPlanes then
  begin
    Plane:=0;
    Planes:=1;
  end
  else if NewImage.PixelFormat=pf24bit then Planes:=3
  else Planes:=1;

  Pix:=@OrgMap^[Plane];
  NewPix:=@NewImage.Map^[Plane];
  for P:=1 to NewImage.Size div Planes do
  begin
    NewPix^:=Map[Pix^];
    Inc(Pix,Planes);
    Inc(NewPix,Planes);
  end;
end;

procedure TColorMap.SaveToStream(Stream: TBaseStream);
begin
  Stream.Write(Map,SizeOf(Map));
end;

procedure TColorMap.LoadFromStream(Stream: TBaseStream);
begin
  Stream.Read(Map,SizeOf(Map));
end;

procedure TColorMap.SaveToFile(const FileName: string);
var
  Stream : TFileStream;
begin
  Stream:=TFileStream.Create(FileName,fsRewrite+[fsShareRead]);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TColorMap.LoadFromFile(const FileName: string);
var
  Stream : TFileStream;
begin
  Stream:=TFileStream.Create(FileName,[fsRead,fsShareRead]);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

end.
