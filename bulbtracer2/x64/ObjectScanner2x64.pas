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
unit ObjectScanner2x64;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, BulbTracer2Config,
  VertexList, Generics.Collections, MeshIOUtil;

type
  TObjectScanner2Config = class
  protected
    FPreCalcTraceFilename: string;
    FVertexGenConfig: TVertexGen2Config;
    FXMin, FXMax, FYMin, FYMax, FZMin, FZMax, FCentreX, FCentreY, FCentreZ: Double;
    FStepSize, FScale: Double;
  end;

  TIterationCallback = procedure (const Idx: Integer) of Object;

  TObjectScanner2 = class
  protected
    FMainHeader: TPBTraceMainHeader;
    FConfig: TObjectScanner2Config;
    FiThreadId: Integer;
    FThreadIdx: Integer;
    FIterationCallback: TIterationCallback;
    FSurfaceSharpness: Double;
    FFacesList: TFacesList;
    FOutputFilename: string;
    procedure Init;

    procedure ScannerInit; virtual; abstract;
    procedure ScannerScan; virtual; abstract;
    function GetWorkList: TList; virtual; abstract;
  public
    constructor Create(const VertexGenConfig: TVertexGen2Config; const FacesList: TFacesList; const SurfaceSharpness: Double; const PreCalcTraceFilename: String; const PMainHeader: TPBTraceMainHeader; const iThreadId: Integer);
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
    procedure ScannerScan3;
    function GetWorkList: TList; override;
 end;

implementation

uses
  Windows, Math, BulbTracer2;

{ ------------------------------ TObjectScanner ------------------------------ }
constructor TObjectScanner2.Create(const VertexGenConfig: TVertexGen2Config; const FacesList: TFacesList; const SurfaceSharpness: Double; const PreCalcTraceFilename: String; const PMainHeader: TPBTraceMainHeader; const iThreadId: Integer);
begin
  inherited Create;
  FConfig := TObjectScanner2Config.Create;
  FMainHeader := PMainHeader;
  FiThreadId := iThreadId;
  with FConfig do begin
    FVertexGenConfig := VertexGenConfig;
    FPreCalcTraceFilename := PreCalcTraceFilename;
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
    FXMax := Max(FMainHeader^.VHeaderWidth, FMainHeader^.VHeaderHeight);
    FCentreX := FXMin + (FXMax - FXMin) * 0.5;
    FYMin := 0.0;
    FYMax := FXMax;
    FCentreY := FYMin + (FYMax - FYMin) * 0.5;
    FZMin := 0.0;
    FZMax := FXMax;
    FCentreZ := FZMin + (FZMax - FZMin) * 0.5;
    FScale := 2.2 / (FMainHeader^.VHeaderZoom * FMainHeader^.VHeaderZScale * (FZMax - 1)); //new stepwidth
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
    with FVertexGenConfig.URange do begin
      FSlicesU := CalcStepCount(FiThreadID, FMainHeader^.ThreadCount);
      if FSlicesU < 1 then
        exit;
      FUMin :=  FXMin + CalcRangeMin(FiThreadID, FMainHeader^.ThreadCount) * (FXMax - FXMin);
      FUMinIndex := CalcRangeMinIndex(FiThreadID, FMainHeader^.ThreadCount);
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

procedure TParallelScanner2.ScannerScan3;

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
                          CurrPos.Z := CurrPos.Z + FStepSize;
                        end;

                        CurrPos.Y := CurrPos.Y + FStepSize;

                        if Assigned( IterationCallback )  then
                          IterationCallback( ThreadIdx );

                        // TODO
                        (*
                        with FMCTparas do begin
                          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
                            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU div 2 + 50;
                            exit;
                          end;
                        end;
                        *)

                      end;
                      CurrPos.X := CurrPos.X + FStepSize;
                      // TODO
                      (*
                      with FMCTparas do begin
                        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round( (CurrUSlice + MaxPrecalcUSlices * 0.5 + I * 0.5)  / FSlicesU * 75.0 );
                      end;*)
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

begin
  CreateMesh;
  OutputDebugString(PChar(Format('[%d] Done!',[ThreadIdx])));
end;


procedure TParallelScanner2.ScannerScan;
begin
  ScannerScan3;
end;

end.

