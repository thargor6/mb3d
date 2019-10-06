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
    FIterationIdx: Integer;
    FIterationCallback: TIterationCallback;
    FSurfaceSharpness: Double;
    FFacesList: TFacesList;
    procedure Init;

    procedure ScannerInit; virtual; abstract;
    procedure ScannerScan; virtual; abstract;
    function GetWorkList: TList; virtual; abstract;
  public
    constructor Create(const VertexGenConfig: TVertexGen2Config; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const FacesList: TFacesList; const SurfaceSharpness: Double);
    destructor Destroy;override;
    procedure Scan;
    property IterationIdx: Integer read FIterationIdx write FIterationIdx;
    property IterationCallback: TIterationCallback read FIterationCallback write FIterationCallback;
  end;

  TParallelScanner2 = class (TObjectScanner2)
  private
    FSurfaceSharpness:  double;
    FCalcColors: boolean;
  protected
    FSlicesU, FSlicesV: Integer;
    FUMin, FVMin: Double;
    FUMinIndex: Integer;
    FDU, FDV: Double;
    procedure ScannerInit; override;
    procedure ScannerScan; override;
    procedure ScannerScan0;
    procedure ScannerScan1;
    function GetWorkList: TList; override;
    procedure CalculateDistance(const FConfig: TObjectScanner2Config; const X, Y, Z: Double; var Distance, ColorIdx1, ColorIdx2: Single);
 end;

implementation

uses
  Windows, Math, Math3D, Calc, BulbTracer2, DivUtils, HeaderTrafos;

{ ------------------------------ TObjectScanner ------------------------------ }
constructor TObjectScanner2.Create(const VertexGenConfig: TVertexGen2Config; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const FacesList: TFacesList; const SurfaceSharpness: Double);
begin
  inherited Create;
  FConfig := TObjectScanner2Config.Create;
  with FConfig do begin
    FVertexGenConfig := VertexGenConfig;
    FMCTparas := MCTparas;
    FM3Vfile := M3Vfile;
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

procedure TParallelScanner2.ScannerScan0;
var
  I, J, K: Integer;
  CurrPos: TD3Vector;
  MCCube: TMCCube;

  procedure CalculateDensity(const Position: TPD3Vector; var Distance, ColorIndex1, ColorIndex2:Single);
  begin
    CalculateDistance(FConfig, Position^.X, Position^.Y, Position^.Z, Distance, ColorIndex1, ColorIndex2);
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
            CalculateDensity(@MCCube.V[K].Position, MCCube.V[K].Weight, MCCube.V[K].ColorIdx1, MCCube.V[K].ColorIdx2);
          end;
          TMCCubes.CreateFacesForCube(@MCCube, ISO_VALUE, FFacesList, FCalcColors);
          CurrPos.Z := CurrPos.Z + FStepSize;
        end;

        CurrPos.Y := CurrPos.Y + FDV;

        if Assigned( IterationCallback )  then
          IterationCallback( IterationIdx );

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

procedure TParallelScanner2.ScannerScan1;
var
  I, J, K: Integer;
  CurrPos: TD3Vector;
  MCCube: TMCCube;
  ColorIdx1, ColorIdx2: Single;
  Weights, ColorIdxs: array of array of array of Single;

  procedure CalculateDensity(const Position: TPD3Vector; var Distance, ColorIndex1, ColorIndex2:Single);
  begin
    CalculateDistance(FConfig, Position^.X, Position^.Y, Position^.Z, Distance, ColorIndex1, ColorIndex2);
  end;

begin
  SetLength(Weights, FSlicesU+1, FSlicesV+1, FSlicesV+1);
  try
    SetLength(ColorIdxs, FSlicesU+1, FSlicesV+1, FSlicesV+1);
    try
      // precalc weights
      with FConfig do begin
        CurrPos.X := FUMin;
        for I := 0 to FSlicesU do begin
          CurrPos.Y := FVMin;
          for J := 0 to FSlicesV do begin
            CurrPos.Z := FZMin;
            for K := 0 to FSlicesV do begin
              CalculateDensity(@CurrPos, Weights[I, J, K], ColorIdx1, ColorIdx2);
              ColorIdxs[I, J, K] := TMCCubes.EncodeColorIdx(ColorIdx1, ColorIdx2);
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
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 50.0 / FSlicesU);
          end;
        end;
      end;

      // trace the object
      with FConfig do begin
        CurrPos.X := FUMin;
        for I := 0 to FSlicesU - 1 do begin
          Sleep(1);

          CurrPos.Y := FVMin;
          for J := 0 to FSlicesV - 1 do begin

            CurrPos.Z := FZMin;
            for K := 0 to FSlicesV - 1 do begin
              TMCCubes.InitializeCube(@MCCube, @CurrPos, FConfig.FStepSize);

              MCCube.V[0].Weight := Weights[I, J, K];
              TMCCubes.DecodeColorIdx(ColorIdxs[I, J, K], MCCube.V[0].ColorIdx1, MCCube.V[0].ColorIdx2);
              MCCube.V[1].Weight := Weights[I+1, J, K];
              TMCCubes.DecodeColorIdx(ColorIdxs[I+1, J, K], MCCube.V[1].ColorIdx1, MCCube.V[1].ColorIdx2);
              MCCube.V[2].Weight := Weights[I+1, J+1, K];
              TMCCubes.DecodeColorIdx(ColorIdxs[I+1, J+1, K], MCCube.V[2].ColorIdx1, MCCube.V[2].ColorIdx2);
              MCCube.V[3].Weight := Weights[I, J+1, K];
              TMCCubes.DecodeColorIdx(ColorIdxs[I, J+1, K], MCCube.V[3].ColorIdx1, MCCube.V[3].ColorIdx2);
              MCCube.V[4].Weight := Weights[I, J, K+1];
              TMCCubes.DecodeColorIdx(ColorIdxs[I, J, K+1], MCCube.V[4].ColorIdx1, MCCube.V[4].ColorIdx2);
              MCCube.V[5].Weight := Weights[I+1, J, K+1];
              TMCCubes.DecodeColorIdx(ColorIdxs[I+1, J, K+1], MCCube.V[5].ColorIdx1, MCCube.V[5].ColorIdx2);
              MCCube.V[6].Weight := Weights[I+1, J+1, K+1];
              TMCCubes.DecodeColorIdx(ColorIdxs[I+1, J+1, K+1], MCCube.V[6].ColorIdx1, MCCube.V[6].ColorIdx2);
              MCCube.V[7].Weight := Weights[I, J+1, K+1];
              TMCCubes.DecodeColorIdx(ColorIdxs[I, J+1, K+1], MCCube.V[7].ColorIdx1, MCCube.V[7].ColorIdx2);

              TMCCubes.CreateFacesForCube(@MCCube, ISO_VALUE, FFacesList, FCalcColors);
              CurrPos.Z := CurrPos.Z + FStepSize;
            end;

            CurrPos.Y := CurrPos.Y + FStepSize;

            if Assigned( IterationCallback )  then
              IterationCallback( IterationIdx );

            with FMCTparas do begin
              if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
                PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU div 2 + 50;
                exit;
              end;
            end;

          end;
          CurrPos.X := CurrPos.X + FStepSize;
          with FMCTparas do begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := 50 + Round(I * 50.0 / FSlicesU);
          end;
        end;
      end;
    finally
      SetLength(ColorIdxs, 0, 0, 0);
      ColorIdxs := nil;
    end;
  finally
    SetLength(Weights, 0, 0, 0);
    Weights := nil;
  end;
end;

procedure TParallelScanner2.ScannerScan;
begin
  ScannerScan1;
end;

procedure TParallelScanner2.CalculateDistance(const FConfig: TObjectScanner2Config; const X, Y, Z: Double; var Distance, ColorIdx1, ColorIdx2: Single);
const
  DE_SCALE = 10;
var
  de: Double;
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

    de := FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas);

    Distance := 1.0 - FSurfaceSharpness * de;
    if FCalcColors then begin
      CalcSIgradient1;
      ColorIdx1 := CalcColorsIdx(@iDif, @psiLight, @FLightVals);
      CalcSIgradient3;
      ColorIdx2 := CalcColorsIdx(@iDif, @psiLight, @FLightVals);
    end;
  end;
end;

end.

