(*
  BulbTracer2 for MB3D
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
unit ObjectScanner2;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, TypeDefinitions, BulbTracer2Config,
  VertexList, Generics.Collections;

type
  TObjectScanner2Config = class
  protected
    FPreCalcTraceFilename: string;
    FIteration3Dext: TIteration3Dext;
    FVertexGenConfig: TVertexGen2Config;
    FMCTparas: TMCTparameter;
    FM3Vfile: TM3Vfile;
    FLightVals: TLightVals;
    FXMin, FXMax, FYMin, FYMax, FZMin, FZMax, FCentreX, FCentreY, FCentreZ: Double;
    FStepSize, FScale: Double;
  end;

  TIterationCallback = procedure (const Idx: Integer) of Object;

  TObjectScanner2 = class
  protected
    FConfig: TObjectScanner2Config;
    FThreadIdx: Integer;
    FIterationCallback: TIterationCallback;
    FSurfaceSharpness: Double;
    FFacesList: TFacesList;
    FTraceOnly: Boolean;
    FOutputFilename: string;
    procedure Init;

    procedure ScannerInit; virtual; abstract;
    procedure ScannerScan; virtual; abstract;
    function GetWorkList: TList; virtual; abstract;
  public
    constructor Create(const VertexGenConfig: TVertexGen2Config; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const FacesList: TFacesList; const SurfaceSharpness: Double; const TraceOnly: boolean; const PreCalcTraceFilename: String);
    destructor Destroy;override;
    procedure Scan;
    property ThreadIdx: Integer read FThreadIdx write FThreadIdx;
    property OutputFilename: string read FOutputFilename write FOutputFilename;
    property IterationCallback: TIterationCallback read FIterationCallback write FIterationCallback;
  end;

  TParallelScanner2 = class (TObjectScanner2)
  private
    FSurfaceSharpness: double;
    FCalcColors: boolean;
    function CalcWeight( const DE: Single ): Single;
  protected
    FSlicesU, FSlicesV: Integer;
    FUMin, FVMin: Double;
    FUMinIndex: Integer;
    FDU, FDV: Double;
    procedure ScannerInit; override;
    procedure ScannerScan; override;
    procedure ScannerScan0;
    procedure ScannerScan3;
    function GetWorkList: TList; override;
    procedure CalculateDistance(const FConfig: TObjectScanner2Config; const X, Y, Z: Double; var DE, ColorIdx, ColorR, ColorG, ColorB: Single);
 end;

implementation

uses
  Windows, Math, Math3D, Calc, BulbTracer2, DivUtils, HeaderTrafos, MeshIOUtil;

{ ------------------------------ TObjectScanner ------------------------------ }
constructor TObjectScanner2.Create(const VertexGenConfig: TVertexGen2Config; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const FacesList: TFacesList; const SurfaceSharpness: Double; const TraceOnly: boolean; const PreCalcTraceFilename: String);
begin
  inherited Create;
  FConfig := TObjectScanner2Config.Create;
  FTraceOnly := TraceOnly;
  with FConfig do begin
    FVertexGenConfig := VertexGenConfig;
    FMCTparas := MCTparas;
    FM3Vfile := M3Vfile;
    FPreCalcTraceFilename := PreCalcTraceFilename;
    IniIt3D(@FMCTparas, @FIteration3Dext);
    MakeLightValsFromHeaderLight(@FM3Vfile.VHeader, @FLightVals, 1, FM3Vfile.VHeader.bStereoMode);
  end;
  FFacesList := FacesList;
  FSurfaceSharpness := SurfaceSharpness;
end;

destructor TObjectScanner2.Destroy;
begin
  FConfig.Free;
  inherited Destroy;
end;

procedure TObjectScanner2.Init;
begin
  with FConfig do begin
    FXMin := 0.0;
    FXMax := Max(FM3Vfile.VHeader.Width, FM3Vfile.VHeader.Height);
    FCentreX := FXMin + (FXMax - FXMin) * 0.5;
    FYMin := 0.0;
    FYMax := FXMax;
    FCentreY := FYMin + (FYMax - FYMin) * 0.5;
    FZMin := 0.0;
    FZMax := FXMax;
    FCentreZ := FZMin + (FZMax - FZMin) * 0.5;
    FScale := 2.2 / (FM3Vfile.VHeader.dZoom * FM3Vfile.Zscale * (FZMax - 1)); //new stepwidth
  end;
  ScannerInit;
end;

procedure TObjectScanner2.Scan;
begin
  Init;
  ScannerScan;
end;
{ ----------------------------- TParallelScanner ----------------------------- }
const
  ISO_VALUE = 0.0;

procedure TParallelScanner2.ScannerInit;
begin
  FSurfaceSharpness := FConfig.FVertexGenConfig.SurfaceSharpness;
  FCalcColors := FConfig.FVertexGenConfig.CalcColors;

  with FConfig do begin
    with FVertexGenConfig.URange, FMCTparas do begin
      FSlicesU := CalcStepCount(iThreadID, PCalcThreadStats.iTotalThreadCount);
      if FSlicesU < 1 then
        exit;
      FUMin :=  FXMin + CalcRangeMin(iThreadID, PCalcThreadStats.iTotalThreadCount) * (FXMax - FXMin);
      FUMinIndex := CalcRangeMinIndex(iThreadID, PCalcThreadStats.iTotalThreadCount);
      FDU := StepSize * (FXMax - FXMin);
    end;
    with FVertexGenConfig.VRange do begin
      FSlicesV := StepCount;
      FVMin := FYMin + RangeMin * (FYMax - FYMin);
      FDV := StepSize * (FYMax - FYMin);
    end;

    FStepSize := (FXMax - FXMin) / (FSlicesV - 1);
  end;
end;

function TParallelScanner2.GetWorkList: TList;
var
  I: Integer;
  U, DU: Double;
begin
  Init;
  Result := TObjectList.Create;
  try
    DU := FConfig.FVertexGenConfig.URange.StepSize *  (FConfig.FXMax - FConfig.FXMin);
    U := FConfig.FXMin;
    for I := 0 to FConfig.FVertexGenConfig.URange.StepCount do begin
      Result.Add( TDoubleWrapper.Create( U ) );
      U := U + DU;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TParallelScanner2.CalcWeight( const DE: Single ): Single;
begin
  Result := 1.0 - FSurfaceSharpness * DE;
end;

procedure TParallelScanner2.ScannerScan0;
var
  I, J, K: Integer;
  CurrPos: TD3Vector;
  MCCube: TMCCube;
  DE: Single;

  procedure CalculateDE(const Position: TPD3Vector; var DE, ColorIndex, ColorR, ColorG, ColorB: Single);
  begin
    CalculateDistance( FConfig, Position^.X, Position^.Y, Position^.Z, DE, ColorIndex, ColorR, ColorG, ColorB );
  end;

begin
  with FConfig do begin
    CurrPos.X := FUMin;
    for I := 0 to FSlicesU - 1 do begin
      Sleep(1);

      CurrPos.Y := FVMin;
      for J := 0 to FSlicesV - 1 do begin

        CurrPos.Z := FZMin;
        while(CurrPos.Z <= FZMax) do begin
          TMCCubes.InitializeCube(@MCCube, @CurrPos, FConfig.FStepSize);
          for K := 0 to 7 do begin
            CalculateDE(@MCCube.V[K].Position, DE, MCCube.V[K].ColorIdx, MCCube.V[K].ColorR, MCCube.V[K].ColorG, MCCube.V[K].ColorB );
            MCCube.V[K].Weight := CalcWeight( DE );
          end;
          TMCCubes.CreateFacesForCube(@MCCube, ISO_VALUE, FFacesList, FCalcColors);
          CurrPos.Z := CurrPos.Z + FStepSize;
        end;

        CurrPos.Y := CurrPos.Y + FDV;

        if Assigned( IterationCallback )  then
          IterationCallback( ThreadIdx );

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
            exit;
          end;
        end;

      end;
      CurrPos.X := CurrPos.X + FDU;
      with FMCTparas do begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 100.0 / FSlicesU);
      end;
    end;
  end;
end;

procedure TParallelScanner2.ScannerScan3;
var
  TraceZMin, TraceZMax: double;

  procedure CalculateDE( const Position: TPD3Vector; var DE, ColorIndex, ColorR, ColorG, ColorB: Single );
  begin
    CalculateDistance( FConfig, Position^.X, Position^.Y, Position^.Z, DE, ColorIndex, ColorR, ColorG, ColorB );
  end;

  procedure CreateMesh;
  const
    // TODO
    // MaxPreCalcValuesPerBlock = 257 * 257 * 257;
    MaxPreCalcValuesPerBlock = 100 * 100 * 100;
  var
    I, J, K: Integer;
    CurrUSlice, MaxPrecalcUSlices: Integer;

    CurrPos: TD3Vector;
    MCCube: TMCCube;
    ColorIdx, ColorR, ColorG, ColorB: Single;
    DE: array of array of array of Single;
    ColorIdxs: array of array of array of TColorValue;
    ColorRs: array of array of array of TColorValue;
    ColorGs: array of array of array of TColorValue;
    ColorBs: array of array of array of TColorValue;

    PreCalcHeaderList: TList;

    procedure PreCalcWeights;
    var
      I, J, K: Integer;
    begin
      // precalc weights
      with FConfig do begin
        CurrPos.X := FUMin + CurrUSlice * FStepSize;
        for I := 0 to MaxPrecalcUSlices do begin
          CurrPos.Y := FVMin;
          for J := 0 to FSlicesV do begin
            CurrPos.Z := FZMin;
            for K := 0 to FSlicesV do begin
              CalculateDE( @CurrPos, DE[I, J, K], ColorIdx, ColorR, ColorG, ColorB );
              ColorIdxs[I, J, K] := FloatToColorValue( ColorIdx );
              ColorRs[I, J, K] := FloatToColorValue( ColorR );
              ColorGs[I, J, K] := FloatToColorValue( ColorG );
              ColorBs[I, J, K] := FloatToColorValue( ColorB );
              CurrPos.Z := CurrPos.Z + FStepSize;
            end;
            CurrPos.Y := CurrPos.Y + FStepSize;

            with FMCTparas do begin
              if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
                PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU div 2 + 50;
                exit;
              end;
            end;

          end;
          CurrPos.X := CurrPos.X + FStepSize;
          with FMCTparas do begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round( (CurrUSlice + I * 0.5)  / FSlicesU * 75.0 );
          end;
        end;
      end;
    end;

    procedure FreePreCalcHeaderList;
    var
      I: Integer;
    begin
      if PreCalcHeaderList <> nil  then begin
        for I := 0 to PreCalcHeaderList.Count - 1 do begin
          if PreCalcHeaderList[I] <> nil then
            FreeMem(PreCalcHeaderList[I]);
        end;
        PreCalcHeaderList.Clear;
        FreeAndNil( PreCalcHeaderList );
      end;
    end;

    procedure InitPreCalcHeaderList;
    var
      Filename: string;
      I: integer;
      PHeader: TPBTraceDataHeader;
    begin
      if PreCalcHeaderList = nil then begin
        PreCalcHeaderList := TList.Create;
        I := 0;
        while True do begin
          Filename := CreateTraceFilename( FConfig.FPreCalcTraceFilename, ThreadIdx, I );
          if TraceDataExists(Filename) then begin
            GetMem(PHeader, SizeOf(TBTraceDataHeader));
            PreCalcHeaderList.Add(PHeader);
            LoadTraceHeader(Filename, PHeader );
            Inc(I);
          end
          else
            break;
        end;
      end;
    end;

    procedure PreLoadWeights;
    var
      I, J, K, HIdx, TraceIdx: integer;
      TraceFilename: String;
      XFromIdx, XToIdx, FromOffset, ToOffset: integer;
      PHeader: TPBTraceDataHeader;
      PData: TPBTraceData;
      CurrDataRecord: TPBTraceData;
    begin
      InitPreCalcHeaderList;
      XFromIdx := CurrUSlice;
      XToIdx := XFromIdx + MaxPrecalcUSlices + 1;
      FromOffset := XFromIdx * (FSlicesV+1) * (FSlicesV+1);
      ToOffset := XToIdx * (FSlicesV+1) * (FSlicesV+1);

      for HIdx := 0 to PreCalcHeaderList.Count - 1 do begin
        PHeader := PreCalcHeaderList[HIdx];
        if ( (PHeader^.TraceOffset >= FromOffset ) and (PHeader^.TraceOffset <= ToOffset) ) or
           ( (PHeader^.TraceOffset + PHeader^.TraceCount >= FromOffset) and (PHeader^.TraceOffset + PHeader^.TraceCount <= ToOffset )) then begin

          TraceFilename := CreateTraceFilename( FConfig.FPreCalcTraceFilename, ThreadIdx, HIdx );
          OutputDebugString(PChar('Loading Trace('+IntToStr(ThreadIdx)+'): '+TraceFilename));
          LoadTraceData(TraceFilename, PData, PHeader);
          try
            TraceIdx := CurrUSlice *(FSlicesV+1)*(FSlicesV+1);
            for I := 0 to MaxPrecalcUSlices do begin
              for J := 0 to FSlicesV do begin
                for K := 0 to FSlicesV do begin
                  if ( TraceIdx >= PHeader.TraceOffset ) and (TraceIdx < PHeader.TraceOffset + PHeader.TraceCount) then begin
                    CurrDataRecord := PData;
                    Inc(CurrDataRecord, TraceIdx-PHeader.TraceOffset);

                    DE[I, J, K] := CurrDataRecord^.DE;
                    ColorIdxs[I, J, K] := CurrDataRecord^.ColorIdx;
                    ColorRs[I, J, K] := CurrDataRecord^.ColorR;
                    ColorGs[I, J, K] := CurrDataRecord^.ColorG;
                    ColorBs[I, J, K] := CurrDataRecord^.ColorB;
                  end;
                  Inc(TraceIdx);
                end;
              end;
            end;
          finally
            FreeMem( PData );
          end;
        end;
      end;
    end;

  begin
    CurrUSlice := 0;
    PreCalcHeaderList := nil;
    TraceZMin := FConfig.FVertexGenConfig.TraceZMin;
    TraceZMax := FConfig.FVertexGenConfig.TraceZMax;
    try
      MaxPrecalcUSlices := Min(Max(MaxPreCalcValuesPerBlock div ((FSlicesV+1) * (FSlicesV+1)), 1), FSlicesU+1);
      while CurrUSlice < FSlicesU do begin
        SetLength(DE, MaxPrecalcUSlices+1, FSlicesV+1, FSlicesV+1);
        try
          SetLength(ColorIdxs, MaxPrecalcUSlices+1, FSlicesV+1, FSlicesV+1);
          try
            SetLength(ColorRs, MaxPrecalcUSlices+1, FSlicesV+1, FSlicesV+1);
            try
              SetLength(ColorGs, MaxPrecalcUSlices+1, FSlicesV+1, FSlicesV+1);
              try
                SetLength(ColorBs, MaxPrecalcUSlices+1, FSlicesV+1, FSlicesV+1);
                try
                  if FConfig.FPreCalcTraceFilename = '' then
                    PreCalcWeights
                  else
                    PreLoadWeights;
                   // trace the object
                  with FConfig do begin
                    CurrPos.X := FUMin + CurrUSlice * FStepSize;
                    for I := 0 to MaxPrecalcUSlices-1 do begin
                      Sleep(1);

                      CurrPos.Y := FVMin;
                      for J := 0 to FSlicesV - 1 do begin

                        CurrPos.Z := FZMin;
                        for K := 0 to FSlicesV - 1 do begin
                          if (CurrPos.Z >= TraceZMin) and (CurrPos.Z <= TraceZMax) then begin
                            TMCCubes.InitializeCube(@MCCube, @CurrPos, FConfig.FStepSize);

                            MCCube.V[0].Weight := CalcWeight( DE[I, J, K] );
                            MCCube.V[0].ColorIdx := ColorValueToFloat( ColorIdxs[I, J, K] );
                            MCCube.V[0].ColorR := ColorValueToFloat( ColorRs[I, J, K] );
                            MCCube.V[0].ColorG := ColorValueToFloat( ColorGs[I, J, K] );
                            MCCube.V[0].ColorB := ColorValueToFloat( ColorBs[I, J, K] );

                            MCCube.V[1].Weight := CalcWeight( DE[I+1, J, K] );
                            MCCube.V[1].ColorIdx := ColorValueToFloat( ColorIdxs[I+1, J, K] );
                            MCCube.V[1].ColorR := ColorValueToFloat( ColorRs[I+1, J, K] );
                            MCCube.V[1].ColorG := ColorValueToFloat( ColorGs[I+1, J, K] );
                            MCCube.V[1].ColorB := ColorValueToFloat( ColorBs[I+1, J, K] );

                            MCCube.V[2].Weight := CalcWeight( DE[I+1, J+1, K] );
                            MCCube.V[2].ColorIdx := ColorValueToFloat( ColorIdxs[I+1, J+1, K] );
                            MCCube.V[2].ColorR := ColorValueToFloat( ColorRs[I+1, J+1, K] );
                            MCCube.V[2].ColorG := ColorValueToFloat( ColorGs[I+1, J+1, K] );
                            MCCube.V[2].ColorB := ColorValueToFloat( ColorBs[I+1, J+1, K] );
                            MCCube.V[3].ColorIdx := ColorValueToFloat( ColorIdxs[I, J+1, K] );
                            MCCube.V[3].ColorR := ColorValueToFloat( ColorRs[I, J+1, K] );
                            MCCube.V[3].ColorG := ColorValueToFloat( ColorGs[I, J+1, K] );
                            MCCube.V[3].ColorB := ColorValueToFloat( ColorBs[I, J+1, K] );


                            MCCube.V[3].Weight := CalcWeight( DE[I, J+1, K] );
                            MCCube.V[4].Weight := CalcWeight( DE[I, J, K+1] );
                            MCCube.V[4].ColorIdx := ColorValueToFloat( ColorIdxs[I, J, K+1] );
                            MCCube.V[4].ColorR := ColorValueToFloat( ColorRs[I, J, K+1] );
                            MCCube.V[4].ColorG := ColorValueToFloat( ColorGs[I, J, K+1] );
                            MCCube.V[4].ColorB := ColorValueToFloat( ColorBs[I, J, K+1] );

                            MCCube.V[5].Weight := CalcWeight( DE[I+1, J, K+1] );
                            MCCube.V[5].ColorIdx := ColorValueToFloat( ColorIdxs[I+1, J, K+1] );
                            MCCube.V[5].ColorR := ColorValueToFloat( ColorRs[I+1, J, K+1] );
                            MCCube.V[5].ColorG := ColorValueToFloat( ColorGs[I+1, J, K+1] );
                            MCCube.V[5].ColorB := ColorValueToFloat( ColorBs[I+1, J, K+1] );

                            MCCube.V[6].Weight := CalcWeight( DE[I+1, J+1, K+1] );
                            MCCube.V[6].ColorIdx := ColorValueToFloat( ColorIdxs[I+1, J+1, K+1] );
                            MCCube.V[6].ColorR := ColorValueToFloat( ColorRs[I+1, J+1, K+1] );
                            MCCube.V[6].ColorG := ColorValueToFloat( ColorGs[I+1, J+1, K+1] );
                            MCCube.V[6].ColorB := ColorValueToFloat( ColorBs[I+1, J+1, K+1] );

                            MCCube.V[7].Weight := CalcWeight( DE[I, J+1, K+1] );
                            MCCube.V[7].ColorIdx := ColorValueToFloat( ColorIdxs[I, J+1, K+1] );
                            MCCube.V[7].ColorR := ColorValueToFloat( ColorRs[I, J+1, K+1] );
                            MCCube.V[7].ColorG := ColorValueToFloat( ColorGs[I, J+1, K+1] );
                            MCCube.V[7].ColorB := ColorValueToFloat( ColorBs[I, J+1, K+1] );

                            TMCCubes.CreateFacesForCube(@MCCube, ISO_VALUE, FFacesList, FCalcColors);
                          end;
                          CurrPos.Z := CurrPos.Z + FStepSize;
                        end;

                        CurrPos.Y := CurrPos.Y + FStepSize;

                        if Assigned( IterationCallback )  then
                          IterationCallback( ThreadIdx );

                        with FMCTparas do begin
                          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
                            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU div 2 + 50;
                            exit;
                          end;
                        end;

                      end;
                      CurrPos.X := CurrPos.X + FStepSize;
                      with FMCTparas do begin
                        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round( (CurrUSlice + MaxPrecalcUSlices * 0.5 + I * 0.5)  / FSlicesU * 75.0 );
                      end;
                    end;
                  end;
                finally
                  SetLength(ColorBs, 0, 0, 0);
                  ColorBs := nil;
                end;
              finally
                SetLength(ColorGs, 0, 0, 0);
                ColorGs := nil;
              end;
            finally
              SetLength(ColorRs, 0, 0, 0);
              ColorRs := nil;
            end;
          finally
            SetLength(ColorIdxs, 0, 0, 0);
            ColorIdxs := nil;
          end;
        finally
          SetLength(DE, 0, 0, 0);
          DE := nil;
        end;
        CurrUSlice := CurrUSlice + MaxPrecalcUSlices;
      end;
    finally
      FreePreCalcHeaderList;
    end;
  end;

  procedure CreateAndSaveTraceData;
  const
    MaxTracesPerFile = 500000;
  var
    I, J, K, CurrFileIdx: Integer;
    TraceFilename: string;
    CurrPos: TD3Vector;
    BTraceData, CurrBTraceData: TPBTraceData;
    DE, ColorIndex, ColorR, ColorG, ColorB: Single;
    Header: TBTraceDataHeader;
  begin
    GetMem(BTraceData, MaxTracesPerFile * SizeOf(TBTraceData));
    try
      CurrFileIdx := 0;
      with FConfig do begin
        Header.TraceOffset := 0;
        Header.TraceCount := 0;
        Header.TraceResolution := FSlicesV;
        Header.WithColors := Ord(FCalcColors);

        CurrPos.X := FUMin;
        for I := 0 to FSlicesU + 3 do begin
          CurrPos.Y := FVMin;
          for J := 0 to FSlicesV do begin
            CurrPos.Z := FZMin;
            for K := 0 to FSlicesV do begin
              CurrBTraceData := BTraceData;
              Inc(CurrBTraceData, Header.TraceCount);

              CalculateDE(@CurrPos, DE, ColorIndex, ColorR, ColorG, ColorB );

              CurrBTraceData^.DE := DE;

              CurrBTraceData^.ColorIdx := FloatToColorValue( ColorIndex );
              CurrBTraceData^.ColorR := FloatToColorValue( ColorR );
              CurrBTraceData^.ColorG := FloatToColorValue( ColorG );
              CurrBTraceData^.ColorB := FloatToColorValue( ColorB );
              Inc( Header.TraceCount );
              if Header.TraceCount >= MaxTracesPerFile then begin
                TraceFilename := CreateTraceFilename(OutputFilename, ThreadIdx, CurrFileIdx);
                SaveTraceHeader( TraceFilename, @Header );
                SaveTraceData( TraceFilename, BTraceData, @Header );

                Inc(Header.TraceOffset, Header.TraceCount);
                Header.TraceCount := 0;
                Inc( CurrFileIdx );
              end;
              CurrPos.Z := CurrPos.Z + FStepSize;
            end;
            CurrPos.Y := CurrPos.Y + FStepSize;

            with FMCTparas do begin
              if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
                PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
                exit;
              end;
            end;
          end;
          CurrPos.X := CurrPos.X + FStepSize;
          with FMCTparas do begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 100.0 / FSlicesU);
          end;
        end;
      end;
      if Header.TraceCount > 0 then with FConfig do begin
        TraceFilename := CreateTraceFilename(OutputFilename, ThreadIdx, CurrFileIdx);
        SaveTraceHeader( TraceFilename, @Header );
        SaveTraceData( TraceFilename, BTraceData, @Header );
      end;
    finally
      FreeMem(BTraceData);
    end;
  end;

begin
  if FTraceOnly then
    CreateAndSaveTraceData
  else
    CreateMesh;
end;


procedure TParallelScanner2.ScannerScan;
begin
  ScannerScan3;
end;

procedure TParallelScanner2.CalculateDistance(const FConfig: TObjectScanner2Config; const X, Y, Z: Double; var DE, ColorIdx, ColorR, ColorG, ColorB: Single);
var
  CC: TVec3D;
  psiLight: TsiLight5;
  iDif: TSVec;

 procedure CalcSIgradient1;
 var
   s: Single;
 begin
    with FConfig do begin
      if FMCTparas.ColorOnIt <> 0 then
        RMdoColorOnIt(@FMCTparas);
      RMdoColor(@FMCTparas);

      if FMCTparas.FormulaType > 0 then begin //col on DE:
        s := Abs(FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas) * 40);
        if FIteration3Dext.ItResultI < FMCTparas.MaxItsResult then begin
          MinMaxClip15bit(s, FMCTparas.mPsiLight.SIgradient);
          FMCTparas.mPsiLight.NormalY := 5000;
        end
        else
          FMCTparas.mPsiLight.SIgradient := Round(Min0MaxCS(s, 32767)) + 32768;
      end
      else begin
        if FIteration3Dext.ItResultI < FMCTparas.iMaxIt then begin   //MaxItResult not intit without calcDE!
          s := FIteration3Dext.SmoothItD * 32767 / FMCTparas.iMaxIt;
          MinMaxClip15bit(s, FMCTparas.mPsiLight.SIgradient);
          FMCTparas.mPsiLight.NormalY := 5000;
        end
        else
          FMCTparas.mPsiLight.SIgradient := FMCTparas.mPsiLight.OTrap + 32768;
      end;
    end;
  end;

  procedure CalcSIgradient3;
  var
    RSFmul: Single;
  begin
    with FConfig do begin
      if FMCTparas.ColorOnIt <> 0 then
        RMdoColorOnIt(@FMCTparas);
      RMdoColor(@FMCTparas); //here for otrap
      if FMCTparas.ColorOption > 4 then FMCTparas.mPsiLight.SIgradient := 32768 or FMCTparas.mPsiLight.SIgradient else
        FIteration3Dext.CalcSIT := True;
        FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas);
        RSFmul := FIteration3Dext.SmoothItD * FMCTparas.mctsM;
        MinMaxClip15bit(RSFmul, FMCTparas.mPsiLight.SIgradient);
        FMCTparas.mPsiLight.SIgradient := 32768 or FMCTparas.mPsiLight.SIgradient;
    end;
  end;

  function CalcColorsIdx(iDif: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals): Single;
  var
    ir: Integer;
  begin
    with PLVals^ do  begin
      if (iColOnOT and 1) = 0 then ir := PsiLight.SIgradient
                              else ir := PsiLight.OTrap and $7FFF;
      ir := Round(MinMaxCS(-1e9, ((ir - sCStart) * sCmul + iDif[0]) * 16384, 1e9));
      if bColCycling then ir := ir and 32767 else
      begin
        if ir < 0 then
        begin
          Result := 0.0;
          Exit;
        end
        else if ir >= ColPos[9] then
        begin
          Result := 1.0;
          Exit;
        end;
      end;
      Result := ir / ColPos[9];
    end;
  end;

  procedure CalcColors(iDif: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals);
  var stmp: Single;
     ir, iL1, iL2: Integer;
  begin
    with PLVals^ do  begin
      if (iColOnOT and 1) = 0 then ir := PsiLight.SIgradient
                              else ir := PsiLight.OTrap and $7FFF;
      ir := Round(MinMaxCS(-1e9, ((ir - sCStart) * sCmul + iDif[0]) * 16384, 1e9));
      iL2 := 5;
      if bColCycling then ir := ir and 32767 else
      begin
        if ir < 0 then
        begin
          iDif^ := PLValigned.ColDif[0];
          Exit;
        end
        else if ir >= ColPos[9] then
        begin
          iDif^ := PLValigned.ColDif[9];
          Exit;
        end;
      end;
      if ColPos[iL2] < ir then
      begin
        repeat Inc(iL2) until (iL2 = 10) or (ColPos[iL2] >= ir);
      end
      else while (ColPos[iL2 - 1] >= ir) and (iL2 > 1) do Dec(iL2);
      if bNoColIpol then
      begin
        iDif^ := PLValigned.ColDif[iL2 - 1];
      end
      else
      begin
        iL1 := iL2 - 1;
        if iL2 > 9 then iL2 := 0;
        stmp := (ir - ColPos[iL1]) * sCDiv[iL1];
        iDif^ := LinInterpolate2SVecs(PLValigned.ColDif[iL2], PLValigned.ColDif[iL1], stmp);
      end;
    end;
  end;

begin
  with FConfig do begin
    FMCTparas.mPsiLight := TPsiLight5(@psiLight);

    FMCTparas.Ystart := TPVec3D(@FM3Vfile.VHeader.dXmid)^;                                   //abs offs!
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[0], FM3Vfile.VHeader.Width * -0.5 + FM3Vfile.Xoff / FScale);
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[1], FM3Vfile.VHeader.Height * -0.5 + FM3Vfile.Yoff / FScale);
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[2], Z - FM3Vfile.Zslices * 0.5 + FM3Vfile.Zoff / FScale);
    mCopyAddVecWeight(@CC, @FMCTparas.Ystart, @FMCTparas.Vgrads[1], Y);

    FIteration3Dext.CalcSIT := True;
    mCopyAddVecWeight(@FIteration3Dext.C1, @CC, @FMCTparas.Vgrads[0], X);

    DE := FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas);

    if FCalcColors then begin
      CalcSIgradient1;
      CalcColors(@iDif, @psiLight, @FLightVals);
      ColorR := iDif[0];
      ColorG := iDif[1];
      ColorB := iDif[2];
      ColorIdx := CalcColorsIdx(@iDif, @psiLight, @FLightVals);
      // TODO: alternative way
      {
        CalcSIgradient3;
        ColorIdx := CalcColorsIdx(@iDif, @psiLight, @FLightVals);
        CalcColors(@iDif, @psiLight, @FLightVals);
        ColorR := iDif[0];
        ColorG := iDif[1];
        ColorB := iDif[2];
      }
    end;
  end;
end;


end.

