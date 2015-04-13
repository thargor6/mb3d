/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// PNGLoader.pas - PNG/MNG bitmap coding/decoding
// ----------------------------------------------
// Version:   2003-12-07
// Maintain:  Michael Vinther    |     mv@logicnet·dk
//
// Last changes:
//   Transparency, alpha channel and gamma bug fixes
//   Lossy compression
//   MNG support
//
unit PNGLoader;

interface

uses Windows, Classes, SysUtils, LinarBitmap, Streams, BufStream, Graphics, DelphiStream, MemUtils,
  CRC32Stream, Deflate, ColorMapper, Monitor, Math, MathUtils, MemStream;

resourcestring
  rsPNGImageFile       = 'Portable Network Graphics';
  rsMNGImageFile       = 'Multiple-image Network Graphics';
  rsInvalidPNGHeader   = 'Invalid PNG header';
  rsInvalidPNGData     = 'Invalid PNG data';
  rsUnsupportedPNGData = 'Unsupported PNG data';
  rsCRCError           = 'CRC error';

const // Constants for ScanLineFilter property
  slfAutoMinSum   = -1; // Auto detect methods
  slfAutoMostRuns = -2;
  slfAutoTryAll   = -3;
  slfNone         =  0; // Fixed filters
  slfSub          =  1;
  slfUp           =  2;
  slfAverage      =  3;
  slfPaeth        =  4;

type
  TPNGGraphic = class(TLinarGraphic)
                  procedure LoadFromStream(Stream: TStream); override;
                  procedure SaveToStream(Stream: TStream); override;
                end;
  TMNGGraphic = class(TLinarGraphic)
                  procedure LoadFromStream(Stream: TStream); override;
                  procedure SaveToStream(Stream: TStream); override;
                end;
  TAlphaPalette = array[0..255] of Byte;

  TPNGLoader = class(TBitmapLoader)
    public
      ExtraInfo : Boolean; // Decode AlphaChannel, AlphaPalette and Palette if in file
      Palette : PPalette;
      AlphaChannel : TLinearBitmap;
      AlphaPalette : ^TAlphaPalette;
      Gamma : Double;
      TransparentColor : Integer; // -1 for no transparency
      BitsPerPixel : Integer;
      ScanLineFilter : Integer; // Default is slfAutoMinSum
      QuantizationSteps : Integer; // Lossy compression, 0 for no loss

      constructor Create;
      destructor Destroy; override;
      procedure NewImage;

      function CanLoad(const Ext: string): Boolean; override;
      function CanSave(const Ext: string): Boolean; override;
      function GetLoadFilter: string; override;

      procedure LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;
      procedure SaveToStream(OutStream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap); override;

      // Make AlphaChannel image from AlphaPalette and values in Source
      procedure MakeAlphaChannelFromAlphaPalette(Source: TLinearBitmap);
      // Make AlphaChannel image from ColorKey and values in Source
      procedure MakeAlphaChannelFromColorKey(Source: TLinearBitmap; ColorKey: TColor);
    end;

var
  Default : TPNGLoader;

function PaethPredictor(a,b,c: Byte): Byte;
// Do lossy transform and return best scan line filter
function OptimizeForPNG(Image: TLinearBitmap; QuantizationSteps: Integer; TransparentColor: TColor=-1): Integer;
procedure TransformRGB2LOCO(Image: TLinearBitmap);
procedure TransformLOCO2RGB(Image: TLinearBitmap);
// Return color map for sorting by luminance
procedure SortPalette(const Pal: TPalette; var ColorMap: TColorMap);

implementation

uses Adler32;

function PaethPredictor(a,b,c: Byte): Byte;
var
  p, pa, pb, pc : Integer;
begin
   // a = left, b = above, c = upper left
   p:=a+b-c;         // Initial estimate
   pa:=abs(p-a);     // Distances to a, b, c
   pb:=abs(p-b);
   pc:=abs(p-c);
   // Return nearest of a,b,c, breaking ties in order a,b,c.
   if (pa<=pb) and (pa<=pc) then Result:=a
   else if pb<=pc then Result:=b
   else Result:=c;
end;

// Return color map for sorting by luminance
procedure SortPalette(const Pal: TPalette; var ColorMap: TColorMap);
type
  TColorRec = record
                Value : Integer;
                Index : Integer;
              end;
var
  List : array[0..255] of TColorRec;

  procedure QSort(Min, Max: Integer);
  var
    A, B : Integer;
    T : TColorRec;
    Z : Integer;
  begin
    A:=Min;
    while Min<Max do
    begin
      B:=Max; Z:=List[(A+B) shr 1].Value;
      repeat
        while List[A].Value<Z do Inc(A);
        while Z<List[B].Value do Dec(B);
        if A<=B then
        begin
          T:=List[A]; List[A]:=List[B]; List[B]:=T;
          Inc(A); Dec(B);
        end;
      until A>B;
      if Min<B then QSort(Min,B);
      Min:=A;
    end;
  end;

var
  I : Integer;
begin  // sorter efter hvilke 2 farver der ofte er nærmest
  for I:=0 to 255 do
  begin
    List[I].Index:=I;
    List[I].Value:=2*Pal[I].R+3*Pal[I].G+Pal[I].B;
  end;
  QSort(0,255);
  for I:=0 to 255 do ColorMap.Map[List[I].Index]:=I;
end;

function ColorDiff(const C1,C2: RGBRec): Integer;
begin
  Result:=Abs(C1.B-C2.B)+Abs(C1.G-C2.G)+Abs(C1.R-C2.R);
end;

function OptimizeForPNG(Image: TLinearBitmap; QuantizationSteps: Integer; TransparentColor: TColor=-1): Integer;
var
  X, Y, P, I : Integer;
  Line, LastLine : PByteArray;
  BPP, HalfStep : Integer;
  NewPal : TPalette;
  ColorMap : TColorMap;
  XModBPP, NewValue : Integer;
begin
  if Image.PixelFormat=pf8bit then
  begin
    if not Image.IsGrayScale then // Palette image
    begin
      // Create new palette
      SortPalette(Image.Palette^,ColorMap);
      if InRange(TransparentColor,0,255) then
      begin
        I:=TransparentColor;
        for X:=0 to 255 do if ColorMap.Map[X]=TransparentColor then
        begin
          I:=X;
          Break;
        end;
        ColorMap.Map[I]:=ColorMap.Map[TransparentColor];
        ColorMap.Map[TransparentColor]:=TransparentColor;
      end;

      // Apply palette changes
      for I:=0 to 255 do NewPal[ColorMap.Map[I]]:=Image.Palette^[I];
      ColorMap.Apply(Image);
      Image.Palette^:=NewPal;

      // Optimize for Paeth filtering
      LastLine:=Image.Map;
      for Y:=1 to Image.Height-1 do
      begin
        Line:=Image.ScanLine[Y];
        for X:=1 to Image.BytesPerLine-1 do
        begin
          if (Line^[X]=TransparentColor) and (TransparentColor<>-1) then Continue; // Transparent
          P:=PaethPredictor(Line^[X-1],LastLine^[X],LastLine^[X-1]); // Paeth filter
          if (ColorDiff(NewPal[P],NewPal[Line^[X]])<QuantizationSteps) and (P<>TransparentColor) then Line^[X]:=P;
        end;
        LastLine:=Line;
      end;
      Result:=slfPaeth;
      Exit;
    end;
    BPP:=1;
  end
  else BPP:=3;
  // 24 bit or grayscale, optimize for average filter
  HalfStep:=(QuantizationSteps+1) div 2;
  LastLine:=Image.Map;
  XModBPP:=0;
  for Y:=1 to Image.Height-1 do
  begin
    Line:=Image.ScanLine[Y];
    for X:=BPP to Image.BytesPerLine-1 do
    begin
      if TransparentColor<>-1 then // Dont't change transparent pixels
      begin
         if BPP=1 then
         begin
           if Line^[X]=TransparentColor then Continue;
         end
         else
         begin
           XModBPP:=X mod 3;
           if PInteger(@Line^[X-XModBPP])^ and $ffffff=TransparentColor then Continue;
         end;
      end;

      P:=(Word(Line^[X-BPP])+LastLine^[X]) div 2; // Average filter
      if Abs(P-Line^[X])<=QuantizationSteps then NewValue:=P
      else
      begin
        I:=Byte(Line^[X]-P) mod QuantizationSteps;
        if I<HalfStep then NewValue:=Max(Line^[X]-I,0)
        else NewValue:=Min(Line^[X]+QuantizationSteps-I,255);
      end;

       // Dont't change pixel to transparent color key
      if TransparentColor=-1 then Line^[X]:=NewValue
      else if BPP=1 then
      begin
        if NewValue<>TransparentColor then Line^[X]:=NewValue;
      end
      else // BPP=3, TransparentColor<>-1
      begin
        Line^[X]:=NewValue;
        if (XModBPP=2) and (PInteger(@Line^[X-2])^ and $ffffff=TransparentColor) then Line^[X]:=NewValue xor 1;
      end;
    end;
    LastLine:=Line;
  end;
  Result:=slfAverage;
end;

procedure TransformRGB2LOCO(Image: TLinearBitmap);
var
  X, Y : Integer;
  Pix : PRGBArray;
begin
  if Image.PixelFormat<>pf24bit then raise Exception.Create(rsInvalidPixelFormat);
  with Image do
  for Y:=0 to Height-1 do
  begin
    Pix:=ScanLine[Y];
    for X:=0 to Width-1 do with Pix^[X] do
    begin
      Dec(R,G);
      Dec(B,G);
    end;
  end;
end;

procedure TransformLOCO2RGB(Image: TLinearBitmap);
var
  X, Y : Integer;
  Pix : PRGBArray;
begin
  if Image.PixelFormat<>pf24bit then raise Exception.Create(rsInvalidPixelFormat);
  with Image do
  for Y:=0 to Height-1 do
  begin
    Pix:=ScanLine[Y];
    for X:=0 to Width-1 do with Pix^[X] do
    begin
      Inc(R,G);
      Inc(B,G);
    end;
  end;
end;

type
  TPNGChunkType = array[1..4] of Char;

//==================================================================================================
// TIDATStream
//==================================================================================================
type
  TIDATStream = class(TFilterStream)
    private
      ChunkData : DWord;
    public
      constructor Create(Next: TCRC32Stream; FirstLength: DWord);
      function Read(var Buf; Count: integer): Integer; override;
    end;

constructor TIDATStream.Create(Next: TCRC32Stream; FirstLength: DWord);
begin
  inherited Create(Next);
  ChunkData:=FirstLength;
  FCanRead:=Next.CanRead;
end;

function TIDATStream.Read(var Buf; Count: Integer): Integer;
var
  Get, Got, CRC : Integer;
  ChunkType : TPNGChunkType;
begin
  Result:=0;
  while Result<Count do
  begin
    if ChunkData=0 then // End of chunk
    begin
      //Got:=TCRC32Stream(Next).CRC;
      Next.Read(CRC,4);
      //if GetSwap4(CRC)<>Got then raise Exception.Create(rsCRCError); // <<<<<<<<<<<<<<<<<<<<<<<<<<<

      Next.Read(ChunkData,4); Swap4(ChunkData); // Read length
      TCRC32Stream(Next).Reset;
      Next.Read(ChunkType,4); // Read type
      if ChunkType<>'IDAT' then raise Exception.Create(rsInvalidPNGData);
    end;

    Get:=Count-Result;
    if Get>Integer(ChunkData) then Get:=ChunkData;
    Got:=Next.Read(TByteArray(Buf)[Result],Get);
    Inc(Result,Got);
    Dec(ChunkData,Got);
    if Got<Get then Break; // Read less than expected
  end;
end;

//==================================================================================================
// TPNGLoader
//==================================================================================================

constructor TPNGLoader.Create;
begin
  TransparentColor:=-1;
  ScanLineFilter:=slfAutoMinSum;
  inherited;
end;

function TPNGLoader.CanLoad(const Ext: string): Boolean;
begin
  Result:=(Ext='PNG') or (Ext='MNG');
end;

function TPNGLoader.CanSave(const Ext: string): Boolean;
begin
  Result:=(Ext='PNG') or (Ext='MNG');
end;

function TPNGLoader.GetLoadFilter: string;
begin
  Result:=rsPNGImageFile+' (*.png)|*.png|'+
          rsMNGImageFile+' (*.mng)|*.mng';
end;

procedure TPNGLoader.NewImage;
begin
  FreeAndNilData(Palette);
  FreeAndNilData(AlphaPalette);
  FreeAndNil(AlphaChannel);
  TransparentColor:=-1;
  Gamma:=0;
end;

var
  PNGHeader : array[1..8] of Char = #137'PNG'#13#10#26#10;
  MNGHeader : array[1..8] of Char = #138'MNG'#13#10#26#10;

type
  TChunkIHDR = packed record
                 Width             : DWord;
                 Height            : DWord;
                 BitDepth          : Byte;
                 ColorType         : Byte;
                 CompressionMethod : Byte;
                 FilterMethod      : Byte;
                 InterlaceMethod   : Byte;
               end;

  TChunkMHDR = packed record
                 FrameWidth        : DWord;
                 FrameHeight       : DWord;
                 TicksPerSecond    : DWord;
                 NominalLayerCount : DWord;
                 NominalFrameCount : DWord;
                 NominalPlayTime   : DWord;
                 SimplicityProfile : DWord;
               end;

  TPNGPalRec = packed record
                 R, G, B : Byte;
               end;
  TPNGPalRec2 = packed record
                  R, G, B : Word;
                end;

const
  Adam7 : array[0..7,0..7] of Byte = ((1,6,4,6,2,6,4,6),
                                      (7,7,7,7,7,7,7,7),
                                      (5,6,5,6,5,6,5,6),
                                      (7,7,7,7,7,7,7,7),
                                      (3,6,4,6,3,6,4,6),
                                      (7,7,7,7,7,7,7,7),
                                      (5,6,5,6,5,6,5,6),
                                      (7,7,7,7,7,7,7,7));

  Adam7DX : array[1..7] of DWord = (8,8,4,4,2,2,1);
  Adam7DY : array[1..7] of DWord = (8,8,8,4,4,2,2);
  Adam7OffestX : array[1..7] of DWord = (0,4,0,2,0,1,0);
  Adam7OffestY : array[1..7] of DWord = (0,0,4,0,2,0,1);

type
  T2ByteRec = packed record
                B1, B2 : Byte;
              end;

//------------------------------------------------------------------------------------------------------------------------------
procedure TPNGLoader.LoadFromStream(Stream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  InStream : TBufferedStream;
  CRCStream : TCRC32Stream;
  ChunkLength : DWord;
  CheckCRC : Boolean;
  IHDR : TChunkIHDR;
  Planes : Integer;
  IsMNG     : Boolean;

  procedure ReadPalette;
  var
    C, ColorCount : Integer;
    Pal : PPalette;
    PalRec : TPNGPalRec;
  begin
    if Assigned(Bitmap.Palette) then Pal:=Bitmap.Palette // Use image palette
    else if ExtraInfo then
    begin
      if Palette=nil then New(Palette);
      Pal:=Palette;
    end
    else
    begin
      CopyStream(InStream,nil,ChunkLength);
      CheckCRC:=False;
      Exit;
    end;

    ColorCount:=ChunkLength div 3;
    for C:=0 to ColorCount-1 do
    begin
      CRCStream.Read(PalRec,SizeOf(PalRec));
      Pal^[C].R:=PalRec.R;
      Pal^[C].G:=PalRec.G;
      Pal^[C].B:=PalRec.B;
    end;
    ZeroMem(Pal^[ColorCount],3*(256-ColorCount));
  end;

  procedure ReadImageData;

  type TAdam7Planes = array[1..7] of PByte;

    procedure Adam7DeInterlace(const Passes: TAdam7Planes; Image: TLinarBitmap);
    var
      PassPix : TAdam7Planes;
      PassPix24 : array[1..7] of ^RGBRec absolute PassPix;
      Pix : ^Byte;
      Pix24 : ^RGBRec absolute Pix;
      X, Y, I : Cardinal;
    begin
      for I:=1 to 7 do PassPix[I]:=Passes[I];
      Pix:=Pointer(Image.Map);
      if Image.PixelFormat=pf24bit then
      begin
        for Y:=0 to Image.Height-1 do
          for X:=0 to Image.Width-1 do
          begin
            I:=Adam7[Y and 7,X and 7];
            Pix24^:=PassPix24[I]^;
            Inc(PassPix24[I]);
            Inc(Pix24);
          end;
      end
      else // 8 bit
      begin
        for Y:=0 to Image.Height-1 do
          for X:=0 to Image.Width-1 do
          begin
            I:=Adam7[Y and 7,X and 7];
            Pix^:=PassPix[I]^;
            Inc(PassPix[I]);
            Inc(Pix);
          end;
      end;
    end;

  var
    IDATStream : TIDATStream;
    DeflateStream : TDeflateStream;
    X, Y, I, Passes : Cardinal;
    LineCount_1, LineLength_1 : Integer;
    Filter : Byte;
    ZLIBHead : packed record
                 CMF, FLG : Byte;
               end;
    Pix, AlphaPix, SourcePix : ^Byte;
    AlphaPix16 : ^Word absolute AlphaPix;
    RGBPix  : ^RGBRec absolute Pix;
    SourcePix2 : ^Word absolute SourcePix;
    SourceRGBPix : ^TPNGPalRec absolute SourcePix;
    SourceRGBPix2 : ^TPNGPalRec2 absolute SourcePix;

    ImageLine, LastLine, SwapLine : PByteArray;
    Adam7PassesMap, Adam7PassesAlpha : TAdam7Planes;
    BPP, BytesPerPNGLine : Cardinal;
    Adler32 : TAdler32;
    Adam7Interlaced : Boolean;
  begin
    if not Bitmap.Present then raise Exception.Create(rsInvalidPNGData);
    Adler32.Init;

    BytesPerPNGLine:=0;
    LineCount_1:=0;
    LineLength_1:=0;
    IDATStream:=TIDATStream.Create(CRCStream,ChunkLength);
    try
      IDATStream.Read(ZLIBHead,2); // ZLIB header
      if (ZLIBHead.CMF and $f<>8) or (ZLIBHead.CMF shr 4>7) then raise Exception.Create(rsInvalidPNGData);

      BPP:=(Planes*IHDR.BitDepth+7) div 8; // Find pixel size

      case IHDR.InterlaceMethod of
        0 : begin                         // No interlacing
              Passes:=1;
              Adam7Interlaced:=False;
              LineLength_1:=Bitmap.Width-1;
              LineCount_1:=Bitmap.Height-1;
              BytesPerPNGLine:=(Bitmap.Width*Planes*IHDR.BitDepth+7) div 8; // Find number of bytes ber line
              Pix:=@Bitmap.Map^;
              if Assigned(AlphaChannel) then AlphaPix:=@AlphaChannel.Map^;
            end;
        1 : begin                         // Adam7 interlacing
              Passes:=7;
              Adam7Interlaced:=True;
            end;
      else raise Exception.Create(rsInvalidPNGData);
      end;
      ZeroMem(Adam7PassesMap,SizeOf(Adam7PassesMap));
      ZeroMem(Adam7PassesAlpha,SizeOf(Adam7PassesAlpha));
      DeflateStream:=TDeflateStream.Create(IDATStream);
      try
        for I:=1 to Passes do
        begin
          if Adam7Interlaced then // Prepare for Adam7 pass
          begin
            LineLength_1:=(Bitmap.Width and $fffffff8) div Adam7DX[I];
            X:=(DWord(Bitmap.Width) and 7-Adam7OffestX[I]+Adam7DX[I]-1) div Adam7DX[I];
            if X>0 then Inc(LineLength_1,X);

            LineCount_1:=(Bitmap.Height and $fffffff8) div Adam7DY[I];
            Y:=(DWord(Bitmap.Height) and 7-Adam7OffestY[I]+Adam7DY[I]-1) div Adam7DY[I];
            if Y>0 then Inc(LineCount_1,Y);

            BytesPerPNGLine:=(LineLength_1*Planes*IHDR.BitDepth+7) div 8; // Find number of bytes ber line
            GetMem(Adam7PassesMap[I],LineCount_1*LineLength_1*(1+Byte(Planes>2) shl 2));
            Pix:=@Adam7PassesMap[I]^;
            if Assigned(AlphaChannel) then
            begin
              GetMem(Adam7PassesAlpha[I],LineCount_1*LineLength_1);
              AlphaPix:=@Adam7PassesAlpha[I]^;
            end;
            Dec(LineLength_1); Dec(LineCount_1);
          end;

          GetMem(ImageLine,BytesPerPNGLine);
          GetMem(LastLine,BytesPerPNGLine);
          ZeroMem(ImageLine^,BytesPerPNGLine);
          try
            if (LineCount_1>=0) and (BytesPerPNGLine>0) then
            for Y:=0 to LineCount_1 do
            begin
              SwapLine:=ImageLine;
              ImageLine:=LastLine;
              LastLine:=SwapLine;

              DeflateStream.Read(Filter,1); // Read filter type
              DeflateStream.Read(ImageLine^,BytesPerPNGLine); // Read line data

              Adler32.Update(Filter);                // Update Adler32 check
              Adler32.Calc(ImageLine^,BytesPerPNGLine);

              // De-filter line
              case Filter of
                0 : ; // None
                1 : for X:=BPP to BytesPerPNGLine-1 do Inc(ImageLine^[X],ImageLine^[X-BPP]); // Sub
                2 : for X:=0 to BytesPerPNGLine-1 do Inc(ImageLine^[X],LastLine^[X]); // Up
                3 : begin // Avarage
                      for X:=0 to BPP-1 do Inc(ImageLine^[X],LastLine^[X] div 2);
                      for X:=BPP to BytesPerPNGLine-1 do Inc(ImageLine^[X],(Word(ImageLine^[X-BPP])+LastLine^[X]) div 2);
                    end;
                4 : begin // Paeth
                      for X:=0 to BPP-1 do Inc(ImageLine^[X],PaethPredictor(0,LastLine^[X],0));
                      for X:=BPP to BytesPerPNGLine-1 do
                        Inc(ImageLine^[X],PaethPredictor(ImageLine^[X-BPP],LastLine^[X],LastLine^[X-BPP]));
                    end;
              else raise Exception.Create(rsInvalidPNGData);
              end;

              // Copy pixels to image
              SourcePix:=@ImageLine^;
              case IHDR.BitDepth of
                1  : for X:=0 to LineLength_1 do
                     begin
                       Pix^:=Byte(SourcePix^ shl (X and 7)) shr 7;
                       if X and 7=7 then Inc(SourcePix);
                       Inc(Pix);
                     end;
                2  : for X:=0 to LineLength_1 do
                     begin
                       Pix^:=Round(((SourcePix^ shr ((not X and 3) shl 1)) and $3));
                       if X and 3=3 then Inc(SourcePix);
                       Inc(Pix);
                     end;
                4  : for X:=0 to LineLength_1 do
                     begin
                       Pix^:=Round(((SourcePix^ shr ((not X and 1) shl 2)) and $f));
                       if Boolean(X and 1) then Inc(SourcePix);
                       Inc(Pix);
                     end;
                8  : case Planes of
                       1 : begin
                             Move(ImageLine^,Pix^,BytesPerPNGLine);
                             Inc(Pix,BytesPerPNGLine);
                           end;
                       2 : begin
                             if Assigned(AlphaChannel) then
                               for X:=0 to LineLength_1 do
                               begin
                                 Pix^:=SourcePix^;
                                 Inc(Pix); Inc(SourcePix);
                                 AlphaPix^:=SourcePix^;
                                 Inc(AlphaPix); Inc(SourcePix);
                               end
                             else
                               for X:=0 to LineLength_1 do
                               begin
                                 Pix^:=SourcePix^;
                                 Inc(Pix); Inc(SourcePix,2);
                               end
                           end;
                       3 : begin
                             for X:=0 to LineLength_1 do
                             begin
                               RGBPix^.R:=SourceRGBPix^.R;
                               RGBPix^.G:=SourceRGBPix^.G;
                               RGBPix^.B:=SourceRGBPix^.B;
                               Inc(RGBPix); Inc(SourceRGBPix);
                             end
                           end;
                       4 : begin
                             if Assigned(AlphaChannel) then
                               for X:=0 to LineLength_1 do
                               begin
                                 RGBPix^.R:=SourceRGBPix^.R;
                                 RGBPix^.G:=SourceRGBPix^.G;
                                 RGBPix^.B:=SourceRGBPix^.B;
                                 Inc(RGBPix); Inc(SourceRGBPix);
                                 AlphaPix^:=SourcePix^;
                                 Inc(AlphaPix); Inc(SourcePix);
                               end
                             else
                               for X:=0 to LineLength_1 do
                               begin
                                 RGBPix^.R:=SourceRGBPix^.R;
                                 RGBPix^.G:=SourceRGBPix^.G;
                                 RGBPix^.B:=SourceRGBPix^.B;
                                 Inc(RGBPix); Inc(SourcePix,4);
                               end
                           end;
                     end;
                16 : case Planes of
                       1 : for X:=0 to LineLength_1 do
                           begin
                             Pix^:=Hi(SourcePix2^); Inc(Pix);
                             Pix^:=Lo(SourcePix2^); Inc(Pix);
                             Inc(SourcePix2);
                           end;
                       2 : begin
                             if Assigned(AlphaChannel) then
                               for X:=0 to LineLength_1 do
                               begin
                                 Pix^:=Hi(SourcePix2^); Inc(Pix);
                                 Pix^:=Lo(SourcePix2^); Inc(Pix);
                                 Inc(SourcePix2);
                                 AlphaPix^:=Lo(SourcePix2^);
                                 Inc(AlphaPix); Inc(SourcePix2);
                               end
                             else
                               for X:=0 to LineLength_1 do
                               begin
                                 Pix^:=Hi(SourcePix2^); Inc(Pix);
                                 Pix^:=Lo(SourcePix2^); Inc(Pix);
                                 Inc(SourcePix2,2);
                               end
                           end;
                       3 : for X:=0 to LineLength_1 do
                           begin
                             RGBPix^.R:=Lo(SourceRGBPix2^.R);
                             RGBPix^.G:=Lo(SourceRGBPix2^.G);
                             RGBPix^.B:=Lo(SourceRGBPix2^.B);
                             Inc(RGBPix); Inc(SourceRGBPix2);
                           end;
                       4 : begin
                             if Assigned(AlphaChannel) then
                               for X:=0 to LineLength_1 do
                               begin
                                 RGBPix^.R:=Lo(SourceRGBPix2^.R);
                                 RGBPix^.G:=Lo(SourceRGBPix2^.G);
                                 RGBPix^.B:=Lo(SourceRGBPix2^.B);
                                 Inc(RGBPix); Inc(SourceRGBPix2);
                                 AlphaPix^:=Lo(SourcePix2^);
                                 Inc(AlphaPix); Inc(SourcePix2);
                               end
                             else
                               for X:=0 to LineLength_1 do
                               begin
                                 RGBPix^.R:=Lo(SourceRGBPix2^.R);
                                 RGBPix^.G:=Lo(SourceRGBPix2^.G);
                                 RGBPix^.B:=Lo(SourceRGBPix2^.B);
                                 Inc(RGBPix); Inc(SourcePix2,4);
                               end
                           end;
                     end;
                else raise Exception.Create(rsInvalidPNGData);
              end;
              if Assigned(ProgressUpdate) and (LineCount_1>0) then ProgressUpdate(Y*100 div DWord(LineCount_1));
            end;
          finally
            FreeMem(LastLine);
            FreeMem(ImageLine);
          end;
        end;

        if Adam7Interlaced then // De-interlace if required
        begin
          Adam7DeInterlace(Adam7PassesMap,Bitmap);
          if Assigned(AlphaChannel) then Adam7DeInterlace(Adam7PassesAlpha,AlphaChannel);
        end;

      finally
        for I:=1 to 7 do if Assigned(Adam7PassesMap[I]) then FreeMem(Adam7PassesMap[I]);
        for I:=1 to 7 do if Assigned(Adam7PassesAlpha[I]) then FreeMem(Adam7PassesAlpha[I]);
        DeflateStream.Free;
      end;

      if IDATStream.ChunkData>4 then CopyStream(IDATStream,nil,IDATStream.ChunkData-4); // Skip unused bytes

      IDATStream.Read(X,4); // Adler-32 check value
      if X<>Adler32.CheckValue then Exception.Create(rsAdler32Error);
    finally
      IDATStream.Free;
    end;
    InStream.NoDataExcept:=False;
    if (IHDR.FilterMethod=64) and IsMNG then TransformLOCO2RGB(Bitmap)
    else if IHDR.FilterMethod<>0 then raise Exception.Create(rsInvalidPNGData);
  end;

  procedure ReadGamma;
  var
    G : DWord;
  begin
    CRCStream.Read(G,4);
    Gamma:=GetSwap4(G)/100000;
  end;

  procedure ReadTransparency;
  var
    Read, I : DWord;
    A : Byte;
  begin
    Read:=0;
    case IHDR.ColorType of
      0 : begin // Grayscale
            TransparentColor:=0;
            CRCStream.Read(A,1);
            CRCStream.Read(TransparentColor,1);
            TransparentColor:=TransparentColor or (Integer(A) shl 8);
            Read:=2;
          end;
      2 : if IHDR.BitDepth=8 then
          begin // RGB color
            TransparentColor:=0;
            CRCStream.Read(A,1);
            CRCStream.Read(A,1);
            TPALETTEENTRY(TransparentColor).peRed:=A;
            CRCStream.Read(A,1);
            CRCStream.Read(A,1);
            TPALETTEENTRY(TransparentColor).peGreen:=A;
            CRCStream.Read(A,1);
            CRCStream.Read(A,1);
            TPALETTEENTRY(TransparentColor).peBlue:=A;
            Read:=6;
          end;
      3 : if ExtraInfo then // 8-bit palette
          begin
            Read:=ChunkLength;
            GetMem(AlphaPalette,256);
            CRCStream.Read(AlphaPalette^,ChunkLength);
            FillChar(AlphaPalette^[ChunkLength],256-ChunkLength,255);
          end
          else
          begin
            Read:=ChunkLength;
            for I:=1 to ChunkLength do
            begin
              CRCStream.Read(A,1);
              if A=0 then
              begin
                TransparentColor:=I-1;
                Read:=I;
                Break;
              end;
            end;
          end;
    end;
    if Read<ChunkLength then CopyStream(CRCStream,nil,ChunkLength-Read);
  end;

  procedure ReadImageHeader;
  begin
    if ChunkLength<>SizeOf(TChunkIHDR) then raise Exception.Create(rsInvalidPNGData);
    CRCStream.Read(IHDR,SizeOf(IHDR));

    BitsPerPixel:=IHDR.BitDepth;
    Swap4(IHDR.Width);
    Swap4(IHDR.Height);
    // Create image
    case IHDR.ColorType of
      0 : begin
            if IHDR.BitDepth=16 then Bitmap.New(IHDR.Width,IHDR.Height,pf16bit)
            else
            begin
              Bitmap.New(IHDR.Width,IHDR.Height,pf8bit);
              if IHDR.BitDepth<8 then
              begin
                ZeroMem(Bitmap.Palette^,SizeOf(Bitmap.Palette^));
                MakeGrayPal(Bitmap.Palette^,1 shl IHDR.BitDepth);
              end
              else Bitmap.Palette^:=GrayPal;
            end;
            Planes:=1;
          end;
      2 : begin
            Bitmap.New(IHDR.Width,IHDR.Height,pf24bit);
            Planes:=3;
          end;
      3 : begin
            Bitmap.New(IHDR.Width,IHDR.Height,pf8bit);
            Planes:=1;
          end;
      4 : begin
            if IHDR.BitDepth=16 then Bitmap.New(IHDR.Width,IHDR.Height,pf16bit)
            else
            begin
              Bitmap.New(IHDR.Width,IHDR.Height,pf8bit);
              Bitmap.Palette^:=GrayPal;
            end;
            if ExtraInfo then
            begin
              AlphaChannel:=TLinarBitmap.Create;
              AlphaChannel.New(IHDR.Width,IHDR.Height,pf8bit);
              AlphaChannel.Palette^:=GrayPal;
            end;
            Planes:=2;
          end;
      6 : begin
            Bitmap.New(IHDR.Width,IHDR.Height,pf24bit);
            if ExtraInfo then
            begin
              AlphaChannel:=TLinarBitmap.Create;
              AlphaChannel.New(IHDR.Width,IHDR.Height,pf8bit);
              AlphaChannel.Palette^:=GrayPal;
            end;
            Planes:=4;
          end;
    else raise Exception.Create(rsInvalidPNGData);
    end;
  end;

var
  HeaderStr : string[8];
  CRC, Read : DWord;
  ChunkType : TPNGChunkType;
begin
  NewImage;
  Bitmap.Dispose;
  InStream:=TBufferedStream.Create(-1,0,Stream);
  try
    // Check PNG header
    Byte(HeaderStr[0]):=InStream.Read(HeaderStr[1],8);
    if HeaderStr=PNGHeader then IsMNG:=False
    else if HeaderStr=MNGHeader then IsMNG:=True
    else raise Exception.Create(rsInvalidPNGHeader);

    CRCStream:=TCRC32Stream.Create(InStream);
    try
      repeat // Process chunks
        CheckCRC:=True;
        InStream.Read(ChunkLength,4); Swap4(ChunkLength);
        CRCStream.Reset;
        Read:=CRCStream.Read(ChunkType,4);
        if Read=4 then
        begin
          if ChunkType='IHDR' then ReadImageHeader
          else if ChunkType='PLTE' then ReadPalette
          else if ChunkType='IDAT' then ReadImageData
          else if ChunkType='gAMA' then ReadGamma
          else if ChunkType='tRNS' then ReadTransparency
          else if ChunkType<>'IEND' then
          begin
            // Check for unknown critical chunk
            if (Byte(ChunkType[1]) and 32=0) and // Critical
               not ((ChunkType='MHDR') or (ChunkType='MEND') or (ChunkType='DEFI')) // MNG specific, can be ignored if we just want the first image
              then raise Exception.Create(rsUnsupportedPNGData);
            CopyStream(InStream,nil,ChunkLength+4);
            CheckCRC:=False; // Ignore CRC for unknown chunks
          end;
          if CheckCRC then
          begin
            Read:=InStream.Read(CRC,4);
            if GetSwap4(CRC)<>CRCStream.CRC then raise Exception.Create(rsCRCError);
          end;
        end;
      until (ChunkType='IEND') or (Read=0);
      if not Bitmap.Present then raise Exception.Create(rsUnsupportedPNGData);
    finally
      CRCStream.Free;
    end;
  finally
    InStream.Free;
  end;
end;

//------------------------------------------------------------------------------------------------------------------------------
procedure TPNGLoader.SaveToStream(OutStream: TSeekableStream; const Ext: string; Bitmap: TLinarBitmap);
var
  CRC : DWord;
  CRCStream : TCRC32Stream;
  ChunkLength, Planes : DWord;
  IHDR : TChunkIHDR;
  ChunkHeader : array[1..4] of Char;
  LineFilter : Integer;

  procedure WritePalette;
  var
    OutPalette : PPalette;
    C, LastColor : Integer;
    PalRec : TPNGPalRec;
  begin
    if IHDR.ColorType=3 then OutPalette:=Bitmap.Palette
    else OutPalette:=Palette;
    LastColor:=0;
    for C:=255 downto 1 do if (OutPalette^[C].R<>0) or (OutPalette^[C].G<>0) or (OutPalette^[C].B<>0) then
    begin
      LastColor:=C;
      Break;
    end;

    ChunkLength:=GetSwap4((LastColor+1)*3);
    OutStream.Write(ChunkLength,4);
    CRCStream.Reset;
    ChunkHeader:='PLTE';
    CRCStream.Write(ChunkHeader,4);
    for C:=0 to LastColor do
    begin
      PalRec.R:=OutPalette^[C].R;
      PalRec.G:=OutPalette^[C].G;
      PalRec.B:=OutPalette^[C].B;
      CRCStream.Write(PalRec,SizeOf(PalRec));
    end;
    CRC:=GetSwap4(CRCStream.CRC);
    OutStream.Write(CRC,4);
  end;

  procedure WriteImageGamma;
  var
    G : DWord;
  begin
    ChunkLength:=GetSwap4(4);
    OutStream.Write(ChunkLength,4);
    CRCStream.Reset;
    ChunkHeader:='gAMA';
    CRCStream.Write(ChunkHeader,4);
    G:=GetSwap4(Round(Gamma*100000));
    CRCStream.Write(G,4);
    CRC:=GetSwap4(CRCStream.CRC);
    OutStream.Write(CRC,4);
  end;

  procedure WriteTranparency;
  var
    I : Integer;
    A, Zero : Byte;
  begin
    CRCStream.Reset;
    ChunkHeader:='tRNS';
    Zero:=0;
    case IHDR.ColorType of
      0 : begin // Grayscale
            ChunkLength:=GetSwap4(2);
            OutStream.Write(ChunkLength,4);
            CRCStream.Write(ChunkHeader,4);
            A:=Hi(TransparentColor);
            CRCStream.Write(A,1);
            CRCStream.Write(TransparentColor,1);
          end;
      2 : begin // RGB color
            ChunkLength:=GetSwap4(6);
            OutStream.Write(ChunkLength,4);
            CRCStream.Write(ChunkHeader,4);
            A:=TPALETTEENTRY(TransparentColor).peRed;
            CRCStream.Write(Zero,1);
            CRCStream.Write(A,1);
            A:=TPALETTEENTRY(TransparentColor).peGreen;
            CRCStream.Write(Zero,1);
            CRCStream.Write(A,1);
            A:=TPALETTEENTRY(TransparentColor).peBlue;
            CRCStream.Write(Zero,1);
            CRCStream.Write(A,1);
          end;
      3 : begin // 8-bit palette
            ChunkLength:=GetSwap4(1+TransparentColor);
            OutStream.Write(ChunkLength,4);
            CRCStream.Write(ChunkHeader,4);
            A:=255;
            for I:=1 to TransparentColor do CRCStream.Write(A,1);
            CRCStream.Write(Zero,1);
          end;
    end;
    CRC:=GetSwap4(CRCStream.CRC);
    OutStream.Write(CRC,4);
  end;

  procedure WriteImageData;
  var
    ImageLine, LastLine, SwapLine : PByteArray;
    BytesPerLine, BPP : DWord;

    procedure SubFilter(FilterLine: PByteArray);
    var X : Integer;
    begin
      Move(ImageLine^,FilterLine^,BPP);
      for X:=BPP to BytesPerLine-1 do FilterLine^[X]:=ImageLine^[X]-ImageLine^[X-Integer(BPP)];
    end;

    procedure UpFilter(FilterLine: PByteArray);
    var X : Integer;
    begin
      for X:=0 to BytesPerLine-1 do FilterLine^[X]:=ImageLine^[X]-LastLine^[X];
    end;

    procedure AvarageFilter(FilterLine: PByteArray);
    var X : DWord;
    begin
      for X:=0 to BPP-1 do FilterLine^[X]:=ImageLine^[X]-LastLine^[X] div 2;
      for X:=BPP to BytesPerLine-1 do FilterLine^[X]:=ImageLine^[X]-(Word(ImageLine^[X-BPP])+LastLine^[X]) div 2;
    end;

    procedure PaethFilter(FilterLine: PByteArray);
    var X : DWord;
    begin
      for X:=0 to BPP-1 do FilterLine^[X]:=ImageLine^[X]-PaethPredictor(0,LastLine^[X],0);
      for X:=BPP to BytesPerLine-1 do
        FilterLine^[X]:=ImageLine^[X]-PaethPredictor(ImageLine^[X-BPP],LastLine^[X],LastLine^[X-BPP]);
    end;

    function TestFilter(FilterLine: PByteArray; FilterType: Integer): Integer;
    var X : Integer;
    begin
      Result:=0;
      if LineFilter=slfAutoMinSum then // Sum filtered values
      begin
        for X:=0 to BytesPerLine-1 do Result:=Result+Abs(ShortInt(FilterLine^[X]));
      end
      else if LineFilter=slfAutoMostRuns then  // Count runs of at least 5 bytes
      begin
        for X:=4 to BytesPerLine-1 do
          if (FilterLine^[X]=FilterLine^[X-4]) and
             (FilterLine^[X]=FilterLine^[X-3]) and
             (FilterLine^[X]=FilterLine^[X-2]) and
             (FilterLine^[X]=FilterLine^[X-1]) then Dec(Result);
      end
      else Assert(False);
    end;

  var
    ZLIBHead : packed record
                 CMF, FLG : Byte;
               end;
    LengthFieldPosition, EndPosition : DWord;
    Adler32 : TAdler32;
    X, Y, I : Integer;
    BestFilter : Byte;
    Test, BestTest : Integer;
    FilterLine : array[0..4] of PByteArray;
    DeflateStream : TDeflateStream;
    Pix, DestPix : PByte;
    Pix2 : PWord absolute Pix;
    RGBPix  : ^RGBRec absolute Pix;
    DestRGBPix : ^RGBRec absolute DestPix;
    BufStream : TBufferedStream;
  begin
    LengthFieldPosition:=OutStream.Position;
    OutStream.Write(ChunkLength,4); // Write dummy length - must be updated later
    CRCStream.Reset;
    BufStream:=TBufferedStream.Create(0,-1,CRCStream);
    try
      ChunkHeader:='IDAT';
      BufStream.Write(ChunkHeader,4); // Write chunk header

      ZLIBHead.CMF:=120;
      ZLIBHead.FLG:=218;
      BufStream.Write(ZLIBHead,2); // ZLIB header

      BytesPerLine:=DWord(Bitmap.Width)*Planes*IHDR.BitDepth div 8; // Find number of bytes ber line
      BPP:=Planes*IHDR.BitDepth div 8; if BPP=0 then BPP:=1; // Find pixel size

      DeflateStream:=TDeflateStream.Create(BufStream);
      for I:=1 to 4 do GetMem(FilterLine[I],BytesPerLine);
      GetMem(ImageLine,BytesPerLine);
      GetMem(LastLine,BytesPerLine);
      try
        //DeflateStream.CompressionMethod:=cmAutoHuffman
        //DeflateStream.CompressionMethod:=cmFixedHuffman;
        //DeflateStream.CompressionMethod:=cmStore;
        Adler32.Init;
        ZeroMem(ImageLine^,BytesPerLine);
        Pix:=@Bitmap.Map^;
        for Y:=0 to Bitmap.Height-1 do
        begin
          SwapLine:=ImageLine;
          ImageLine:=LastLine;
          LastLine:=SwapLine;

          // Copy pixels from image
          DestPix:=@ImageLine^;
          case IHDR.BitDepth of
            8  : case Planes of
                   1 : begin
                         Move(Pix^,ImageLine^,BytesPerLine);
                         Inc(Pix,BytesPerLine);
                       end;
                   3 : begin
                         for X:=0 to Bitmap.Width-1 do
                         begin
                           DestRGBPix^.B:=RGBPix^.R;
                           DestRGBPix^.G:=RGBPix^.G;
                           DestRGBPix^.R:=RGBPix^.B;
                           Inc(RGBPix); Inc(DestRGBPix);
                         end
                       end;
                   else raise Exception.Create(rsInvalidPixelFormat); // Not supported yet
                 end;
            16 : case Planes of
                   1 : begin
                         for X:=0 to Bitmap.Width-1 do
                         begin
                           DestPix^:=Hi(Pix2^);
                           Inc(DestPix);
                           DestPix^:=Lo(Pix2^);
                           Inc(DestPix);
                           Inc(Pix2);
                         end;
                       end;
                   else raise Exception.Create(rsInvalidPixelFormat); // Not supported yet
                 end;
            else raise Exception.Create(rsInvalidPixelFormat); // Not supported yet
          end;

          // Scan line filter
          if (LineFilter<0) or (LineFilter=slfNone)    then FilterLine[0]:=ImageLine;     // None
          if (LineFilter<0) or (LineFilter=slfSub)     then SubFilter(FilterLine[1]);     // Sub
          if (LineFilter<0) or (LineFilter=slfUp)      then UpFilter(FilterLine[2]);      // Up
          if (LineFilter<0) or (LineFilter=slfAverage) then AvarageFilter(FilterLine[3]); // Avarage
          if (LineFilter<0) or (LineFilter=slfPaeth)   then PaethFilter(FilterLine[4]);;  // Paeth
          if LineFilter<0 then // Auto-detect best filter
          begin
            BestTest:=High(BestTest);
            for I:=0 to 4 do
            begin
              Test:=TestFilter(FilterLine[I],I);
              if Test<BestTest then
              begin
                BestTest:=Test;                     
                BestFilter:=I;
              end;
            end;
          end
          else BestFilter:=LineFilter;

          // Write filter type
          Adler32.Update(BestFilter);
          DeflateStream.Write(BestFilter,1);

          // Write filtered line
          Adler32.Calc(FilterLine[BestFilter]^,BytesPerLine);
          DeflateStream.Write(FilterLine[BestFilter]^,BytesPerLine);
        end;
      finally
        FreeMem(LastLine);
        FreeMem(ImageLine);
        for I:=1 to 4 do FreeMem(FilterLine[I]);
        DeflateStream.Free;
      end;
      CRC:=Adler32.CheckValue;
      BufStream.Write(CRC,4); // Write Adler32 checksum
    finally
      BufStream.Free;
    end;

    // Update length field
    EndPosition:=OutStream.Position;
    ChunkLength:=GetSwap4(EndPosition-LengthFieldPosition-8);
    OutStream.Position:=LengthFieldPosition;
    OutStream.Write(ChunkLength,4);
    OutStream.Position:=EndPosition;
    CRC:=GetSwap4(CRCStream.CRC);
    OutStream.Write(CRC,4); // Write CRC
  end;

var
  OptimImage : TLinearBitmap;
  TestFilter, BestSize : Integer;
  MemStream : TMemStream;
  IsMNG : Boolean;
begin
  IsMNG:=Ext='MNG';
  LineFilter:=ScanLineFilter;
  if (QuantizationSteps=0) or (Bitmap.PixelFormat=pf16bit) or (IsMNG and (Bitmap.PixelFormat=pf24bit)) then
  begin
    OptimImage:=nil;
    if LineFilter=slfAutoTryAll then // Try all filters
    begin
      BestSize:=High(BestSize);
      MemStream:=TMemStream.Create;
      try
        for TestFilter:=slfAutoTryAll+1 to slfPaeth do
        begin
          ScanLineFilter:=TestFilter;
          MemStream.Reset;
          SaveToStream(MemStream,Ext,Bitmap);
          if MemStream.Size<BestSize then
          begin
            BestSize:=MemStream.Size;
            LineFilter:=TestFilter;
          end;
          if Assigned(ProgressUpdate) then ProgressUpdate((TestFilter-slfAutoTryAll)*100 div (slfPaeth-slfAutoTryAll+1));
        end;
      finally
        ScanLineFilter:=slfAutoTryAll;
        MemStream.Free;
      end;
    end;
  end
  else // Do lossy compression
  begin
    OptimImage:=TLinearBitmap.Create(Bitmap);
    try
      LineFilter:=OptimizeForPNG(OptimImage,QuantizationSteps,TransparentColor);
      Bitmap:=OptimImage;
    except
      OptimImage.Free;
      raise;
    end;
  end;
  try
    // Write header
    if IsMNG then OutStream.Write(MNGHeader,SizeOf(MNGHeader)) // MNG
    else OutStream.Write(PNGHeader,SizeOf(PNGHeader));         // PNG

    // Write image header, IHDR
    IHDR.Width:=GetSwap4(Bitmap.Width);
    IHDR.Height:=GetSwap4(Bitmap.Height);
    if (BitsPerPixel in [1,2,4]) and (Bitmap.PixelFormat=pf8bit) then IHDR.BitDepth:=BitsPerPixel
    else if Bitmap.PixelFormat=pf16bit then IHDR.BitDepth:=16
    else IHDR.BitDepth:=8;
    IHDR.CompressionMethod:=0;
    IHDR.FilterMethod:=0;
    IHDR.InterlaceMethod:=0;
    if Bitmap.PixelFormat in [pf8bit,pf16bit] then
    begin
      if (IHDR.BitDepth<8) or not Bitmap.IsGrayScale then
      begin
        IHDR.ColorType:=3; // Palette
        Planes:=1;
      end
      else
      begin
        IHDR.ColorType:=0; // Grayscale
        Planes:=1;
      end
    end
    else if Bitmap.PixelFormat=pf24bit then
    begin
      IHDR.ColorType:=2; // 24 bit
      Planes:=3;

      if IsMNG then // Do LOCO color transform
      begin
        OptimImage:=TLinearBitmap.Create(Bitmap);
        try
          TransformRGB2LOCO(OptimImage);
          Bitmap:=OptimImage;
        except
          OptimImage.Free;
          raise;
        end;
        IHDR.FilterMethod:=64;
      end;
    end
    else raise ELinearBitmap.Create(rsInvalidPixelFormat);
    ChunkLength:=GetSwap4(SizeOf(IHDR));
    OutStream.Write(ChunkLength,4);
    CRCStream:=TCRC32Stream.Create(OutStream);
    try
      ChunkHeader:='IHDR';
      CRCStream.Write(ChunkHeader,4);
      CRCStream.Write(IHDR,SizeOf(IHDR));
      CRC:=GetSwap4(CRCStream.CRC);
      OutStream.Write(CRC,4);

      if (IHDR.ColorType=3) or Assigned(Palette) then WritePalette; // Write palette if present

      if Gamma<>0 then WriteImageGamma; // Write palette if specified

      if TransparentColor<>-1 then WriteTranparency;

      WriteImageData; // Write bitmap

      // Write IEND
      ChunkLength:=0;
      OutStream.Write(ChunkLength,4);
      CRCStream.Reset;
      ChunkHeader:='IEND';
      CRCStream.Write(ChunkHeader,4);
      CRC:=GetSwap4(CRCStream.CRC);
      OutStream.Write(CRC,4);
    finally
      CRCStream.Free;
    end;
  finally
    OptimImage.Free;
  end;
end;

procedure TPNGLoader.MakeAlphaChannelFromAlphaPalette(Source: TLinearBitmap);
var I : Integer;
begin
  Assert(Source.PixelFormat=pf8bit);
  if AlphaChannel=nil then AlphaChannel:=TLinearBitmap.Create;
  AlphaChannel.New(Source.Width,Source.Height,pf8bit);
  for I:=0 to AlphaChannel.Size-1 do AlphaChannel.Map^[I]:=AlphaPalette[Source.Map^[I]];
end;

procedure TPNGLoader.MakeAlphaChannelFromColorKey(Source: TLinearBitmap; ColorKey: TColor);
var
  I : Integer;
  Pix : PColor;
begin
  Assert(Source.PixelFormat=pf24bit);
  ColorKey:=RGB2BGR(ColorKey);
  if AlphaChannel=nil then AlphaChannel:=TLinearBitmap.Create;
  AlphaChannel.New(Source.Width,Source.Height,pf8bit);
  Pix:=Pointer(Source.Map);
  for I:=0 to AlphaChannel.Size-1 do
  begin
    if (Pix^ and $ffffff)=ColorKey then AlphaChannel.Map^[I]:=0
    else AlphaChannel.Map^[I]:=255;
    Inc(DWord(Pix),3);
  end;
end;

destructor TPNGLoader.Destroy;
begin
  inherited Destroy;
  if Assigned(Palette) then FreeMem(Palette);
  if Assigned(AlphaPalette) then FreeMem(AlphaPalette);
  AlphaChannel.Free;
end;

//==================================================================================================
// TPNGGraphic
//==================================================================================================

procedure TPNGGraphic.LoadFromStream(Stream: TStream);
var
  Filter : TDelphiFilterStream;
begin
  Filter:=TDelphiFilterStream.Create(Stream);
  try
    FImage.LoadFromStream(Filter,'PNG');
  finally
    Filter.Free;
  end;
end;

procedure TPNGGraphic.SaveToStream(Stream: TStream);
var
  Filter : TDelphiFilterStream;
begin
  Filter:=TDelphiFilterStream.Create(Stream);
  try
    FImage.SaveToStream(Filter,'PNG');
  finally
    Filter.Free;
  end;
end;

//==================================================================================================
// TMNGGraphic
//==================================================================================================

procedure TMNGGraphic.LoadFromStream(Stream: TStream);
var
  Filter : TDelphiFilterStream;
begin
  Filter:=TDelphiFilterStream.Create(Stream);
  try
    FImage.LoadFromStream(Filter,'MNG');
  finally
    Filter.Free;
  end;
end;

procedure TMNGGraphic.SaveToStream(Stream: TStream);
var
  Filter : TDelphiFilterStream;
begin
  Filter:=TDelphiFilterStream.Create(Stream);
  try
    FImage.SaveToStream(Filter,'MNG');
  finally
    Filter.Free;
  end;
end;

initialization
  Default:=TPNGLoader.Create;
  LinarBitmap.AddLoader(Default);
  TPicture.RegisterFileFormat('PNG',rsPNGImageFile,TPNGGraphic);
  TPicture.RegisterFileFormat('MNG',rsMNGImageFile,TMNGGraphic);
finalization
  TPicture.UnregisterGraphicClass(TPNGGraphic);
  TPicture.UnregisterGraphicClass(TMNGGraphic);
  Default.Free;
end.

