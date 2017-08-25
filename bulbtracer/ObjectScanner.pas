{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit ObjectScanner;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, TypeDefinitions, BulbTracerConfig,
  VertexList, Generics.Collections;

type
  TObjectScannerConfig = class
  protected
    FJitter: Double;
    FIteration3Dext: TIteration3Dext;
    FVertexGenConfig: TVertexGenConfig;
    FMCTparas: TMCTparameter;
    FM3Vfile: TM3Vfile;
    FLightVals: TLightVals;
    FXMin, FXMax, FYMin, FYMax, FZMin, FZMax, FCentreX, FCentreY, FCentreZ: Double;
    FStepSize, FScale, FMaxRayDist: Double;
  end;

  TRayCaster = class
  protected
    function IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double ): Boolean; overload;
    function IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double; const DoCalcColor: Boolean; var ColorR, ColorG, ColorB: Double ): Boolean; overload;
    function CalculateNormal(const FConfig: TObjectScannerConfig; const Direction, FacePos: TD3Vector; const N: TPD3Vector; const WasInside: Boolean ): Boolean;
  public
    procedure CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector); virtual; abstract;
  end;

  TCreatePointCloudRayCaster = class (TRayCaster)
  private
    FVertexList, FNormalsList, FColorList: TPS3VectorList;
  public
    constructor Create(VertexList, NormalsList, ColorList: TPS3VectorList);
    procedure CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector); override;
  end;

  TCreateMeshRayCaster = class (TRayCaster)
  private
    FISOValue: Double;
    FFacesList: TFacesList;
  public
    constructor Create(FacesList: TFacesList; const ISOValue: Double);
    procedure CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector); override;
  end;

  TObjectScanner = class
  protected
    FConfig: TObjectScannerConfig;
    FUseShuffledWorkList: Boolean;
    FRayCaster: TRayCaster;
    procedure Init;

    procedure ScannerInit; virtual; abstract;
    procedure ScannerScan; virtual; abstract;
  public
    constructor Create(const VertexGenConfig: TVertexGenConfig; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const RayCaster: TRayCaster);
    destructor Destroy;override;
    procedure Scan;
    function GetWorkList: TList; virtual; abstract;
    property UseShuffledWorkList: Boolean read FUseShuffledWorkList;
  end;

  TSphericalScanner = class (TObjectScanner)
  protected
    FSlicesTheta, FSlicesPhi: Integer;
    FThetaMin, FPhiMin: Double;
    FThetaMinIndex: Integer;
    FDTheta, FDPhi: Double;
    FRadius, FStartDist: Double;
    procedure ScannerInit; override;
    procedure ScannerScan; override;
    function GetWorkList: TList; override;
  end;

  TParallelScanner = class (TObjectScanner)
  protected
    FSlicesU, FSlicesV: Integer;
    FUMin, FVMin: Double;
    FUMinIndex: Integer;
    FDU, FDV: Double;
  protected
    procedure ScannerInit; override;
    procedure ScannerScan; override;
    function GetWorkList: TList; override;
  end;

  TCubicScanner = class (TObjectScanner)
  protected
    FSlicesU, FSlicesV: Integer;
    FUMinIndex: Integer;
    FVMin_XY, FVMin_ZY, FVMin_XZ: Double;
    FDV_XY, FDV_ZY, FDV_XZ: Double;
  protected
    procedure ScannerInit; override;
    procedure ScannerScan; override;
    function GetWorkList: TList; override;
  end;

implementation

uses
  Windows, Math, Math3D, Calc, BulbTracer, DivUtils, HeaderTrafos;

{ ------------------------------ TObjectScanner ------------------------------ }
constructor TObjectScanner.Create(const VertexGenConfig: TVertexGenConfig; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const RayCaster: TRayCaster);
begin
  inherited Create;
  FConfig := TObjectScannerConfig.Create;
  with FConfig do begin
    FVertexGenConfig := VertexGenConfig;
    FMCTparas := MCTparas;
    FM3Vfile := M3Vfile;
    IniIt3D(@FMCTparas, @FIteration3Dext);
    MakeLightValsFromHeaderLight(@FM3Vfile.VHeader, @FLightVals, 1, FM3Vfile.VHeader.bStereoMode);
    case FVertexGenConfig.MeshType of
      mtPointCloud:
        begin
          FConfig.FJitter := 0.75;
          FUseShuffledWorkList := True;
        end;
      mtMesh:
        begin
          FConfig.FJitter := 0.0;
          FUseShuffledWorkList := False;
        end;
    end;
  end;
  FRayCaster := RayCaster;
end;

destructor TObjectScanner.Destroy;
begin
  FConfig.Free;
  inherited Destroy;
end;

procedure TObjectScanner.Init;
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

procedure TObjectScanner.Scan;
begin
  Init;
  ScannerScan;
end;
{ ----------------------------- TSphericalScanner ---------------------------- }
const
  JITTER_MIN = 0.001;

procedure TSphericalScanner.ScannerInit;
begin
  with FConfig do begin
    with FVertexGenConfig.URange, FMCTparas do begin
      FSlicesTheta := CalcStepCount(iThreadID, PCalcThreadStats.iTotalThreadCount);
      if FSlicesTheta < 1 then
        exit;
      FThetaMin := CalcRangeMin(iThreadID, PCalcThreadStats.iTotalThreadCount) * DegToRad( 360.0 );
      FThetaMinIndex := CalcRangeMinIndex(iThreadID, PCalcThreadStats.iTotalThreadCount);
      FDTheta := StepSize * DegToRad(360.0) ;
    end;
    with FVertexGenConfig.VRange do begin
      FSlicesPhi := StepCount;
      FPhiMin := RangeMin * DegToRad( 360.0 );
      FDPhi := StepSize * DegToRad(360.0);
    end;

    FRadius := Sqrt(Sqr(FXMax-FXMin) + Sqr(FYMax-FYMin) + Sqr(FZMax-FZMin)) / 2.0;
    FStepSize := FRadius / FSlicesPhi;
    FStartDist := FRadius + 1.5 * FStepSize;
    FMaxRayDist := FStartDist;
  end;
end;

function TSphericalScanner.GetWorkList: TList;
var
  I: Integer;
  Theta, DTheta: Double;
begin
  Init;
  Result := TObjectList.Create;
  try
    DTheta := FConfig.FVertexGenConfig.URange.StepSize * DegToRad(360.0) ;
    Theta := 0.0;
    for I := 0 to FConfig.FVertexGenConfig.URange.StepCount do begin
      Result.Add( TDoubleWrapper.Create( Theta ) );
      Theta := Theta + DTheta;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TSphericalScanner.ScannerScan;
var
  I, J: Integer;
  Theta, SinTheta, CosTheta: Double;
  Phi, SinPhi, CosPhi: Double;
  CurrPos, Dir: TD3Vector;
begin
  with FConfig do begin
    Theta := FThetaMin;
    for I := 0 to FSlicesTheta - 1 do begin
      Sleep(1);
      if FJitter > JITTER_MIN then begin
        SinCos(Theta + FDTheta * ( 1.0 - Random ) * FJitter, SinTheta, CosTheta);
      end
      else begin
        SinCos(Theta, SinTheta, CosTheta);
      end;
      Phi := FPhiMin;
      for J := 0 to FSlicesPhi -1 do begin
        if FJitter > JITTER_MIN then begin
          SinCos(Phi + FDPhi * ( 1.0 - Random ) * FJitter, SinPhi, CosPhi);
        end
        else begin
          SinCos(Phi, SinPhi, CosPhi);
        end;

        Dir.X := - SinTheta * CosPhi * FStepSize;
        Dir.Y := - SinTheta * SinPhi * FStepSize;
        Dir.Z :=   CosTheta * FStepSize;

        CurrPos.X := FCentreX + FStartDist * SinTheta * CosPhi;
        CurrPos.Y := FCentreY + FStartDist * SinTheta * SinPhi;
        CurrPos.Z := FCentreZ - FStartDist * CosTheta;

        FRayCaster.CastRay(FConfig, CurrPos, Dir);

        Phi := Phi + FDPhi;

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesTheta;
            exit;
          end;
        end;

      end;
      Theta := Theta + FDTheta;
      with FMCTparas do begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 100.0 / FSlicesTheta);
      end;
    end;
  end;
end;
{ ----------------------------- TParallelScanner ----------------------------- }
procedure TParallelScanner.ScannerInit;
begin
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

    FMaxRayDist := FZMax - FZMin;
    FStepSize := (FXMax - FXMin) / (FSlicesV - 1);
  end;
end;

function TParallelScanner.GetWorkList: TList;
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

procedure TParallelScanner.ScannerScan;
var
  I, J, Idx: Integer;
  U, V: Double;
  CurrPos, Dir: TD3Vector;
begin
  with FConfig do begin
    U := FUMin;
    for I := 0 to FSlicesU - 1 do begin
      Sleep(1);

      if FUseShuffledWorkList then begin
        Idx := I + FUMinIndex;
        if ( Idx < 0 ) or ( Idx >= FConfig.FVertexGenConfig.SharedWorkList.Count ) then
          OutputDebugString(PChar('###################'+IntToStr(Idx)+' '+IntToStr( FUMinIndex ) + ' '+IntToStr(FConfig.FVertexGenConfig.SharedWorkList.Count)));

        U := TDoubleWrapper( FConfig.FVertexGenConfig.SharedWorkList[ Idx ] ).Value;
      end;

      V := FVMin;
      for J := 0 to FSlicesV - 1 do begin

        Dir.X := 0.0;
        Dir.Y := 0.0;
        Dir.Z := FStepSize;

        if FJitter > JITTER_MIN then begin
          CurrPos.X := U + FDV * (1.0 - Random) * FJitter;
          CurrPos.Y := V + FDV * (1.0 - Random) * FJitter;
          CurrPos.Z := FZMin;
        end
        else begin
          CurrPos.X := U;
          CurrPos.Y := V;
          CurrPos.Z := FZMin;
        end;

        FRayCaster.CastRay(FConfig, CurrPos, Dir);
        V := V + FDV;

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
            exit;
          end;
        end;

      end;
      U := U + FDU;
      with FMCTparas do begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 100.0 / FSlicesU);
      end;
    end;
  end;
end;

{ ------------------------------- TCubicScanner ------------------------------ }
procedure TCubicScanner.ScannerInit;
begin
  with FConfig do begin
    with FVertexGenConfig.URange, FMCTparas do begin
      FSlicesU := CalcStepCount(iThreadID, PCalcThreadStats.iTotalThreadCount);
      if FSlicesU < 1 then
        exit;
      FUMinIndex := CalcRangeMinIndex(iThreadID, PCalcThreadStats.iTotalThreadCount);
    end;
    with FVertexGenConfig.VRange do begin
      FSlicesV := StepCount;

      FVMin_XY := FYMin + RangeMin * (FYMax - FYMin);
      FDV_XY := StepSize * (FYMax - FYMin);

      FVMin_ZY := FYMin + RangeMin * (FYMax - FYMin);
      FDV_ZY := StepSize * (FYMax - FYMin);
      FVMin_ZY := FVMin_ZY + FDV_ZY / 2.0;

      FVMin_XZ := FZMin + RangeMin * (FZMax - FZMin);
      FDV_XZ := StepSize * (FZMax - FZMin);
      FVMin_XZ := FVMin_XZ + FDV_XZ / 2.0;
    end;

    FMaxRayDist := FZMax - FZMin;
    FStepSize := (FXMax - FXMin) / (FSlicesV - 1);
  end;
end;

function TCubicScanner.GetWorkList: TList;
var
  I: Integer;
  U_XY, U_ZY, U_XZ, DU_XY, DU_ZY, DU_XZ: Double;
begin
  Init;
  Result := TObjectList.Create;
  try
    DU_XY := FConfig.FVertexGenConfig.URange.StepSize *  (FConfig.FXMax - FConfig.FXMin);
    DU_ZY := FConfig.FVertexGenConfig.URange.StepSize *  (FConfig.FZMax - FConfig.FZMin);
    DU_XZ := FConfig.FVertexGenConfig.URange.StepSize *  (FConfig.FXMax - FConfig.FXMin);
    U_XY := FConfig.FXMin;
    U_ZY := FConfig.FZMin + DU_ZY / 2.0;
    U_XZ := FConfig.FXMin + DU_XZ / 2.0;
    for I := 0 to FConfig.FVertexGenConfig.URange.StepCount do begin
      Result.Add( TXYZWrapper.Create( U_XY, U_ZY, U_XZ ) );
      U_XY := U_XY + DU_XY;
      U_ZY := U_ZY + DU_ZY;
      U_XZ := U_XZ + DU_XZ;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TCubicScanner.ScannerScan;
var
  I, Idx: Integer;

  procedure ScanXY( const ScanForward: Boolean );
  var
    J: Integer;
    U, V: Double;
    CurrPos, Dir: TD3Vector;
  begin
    with FConfig do begin
      U := TXYZWrapper( FConfig.FVertexGenConfig.SharedWorkList[ Idx ] ).X;
      V := FVMin_XY;
      for J := 0 to FSlicesV - 1 do begin

        Dir.X := 0.0;
        Dir.Y := 0.0;
        if ScanForward then
          Dir.Z := FStepSize
        else
          Dir.Z := -FStepSize;


        if FJitter > JITTER_MIN then begin
          CurrPos.X := U + FDV_XY * (1.0 - Random) * FJitter;
          CurrPos.Y := V + FDV_XY * (1.0 - Random) * FJitter;
          if ScanForward then
            CurrPos.Z := FZMin + FDV_XY * (1.0 - Random) * FJitter
          else
            CurrPos.Z := FZMax - FDV_XY * (1.0 - Random) * FJitter;

        end
        else begin
          CurrPos.X := U;
          CurrPos.Y := V;
          if ScanForward then
            CurrPos.Z := FZMin
          else
            CurrPos.Z := FZMax;
        end;

        FRayCaster.CastRay(FConfig, CurrPos, Dir);
        V := V + FDV_XY;

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
            exit;
          end;
        end;

      end;
    end;
  end;

  procedure ScanZY( const ScanForward: Boolean );
  var
    J: Integer;
    U, V: Double;
    CurrPos, Dir: TD3Vector;
  begin
    with FConfig do begin
      U := TXYZWrapper( FConfig.FVertexGenConfig.SharedWorkList[ Idx ] ).Y;
      V := FVMin_ZY;
      for J := 0 to FSlicesV - 1 do begin

        if ScanForward then
          Dir.X := -FStepSize
        else
          Dir.X := FStepSize;
        Dir.Y := 0.0;
        Dir.Z := 0.0;

        if FJitter > JITTER_MIN then begin
          CurrPos.Y := U + FDV_ZY * (1.0 - Random) * FJitter;
          CurrPos.Z := V + FDV_ZY * (1.0 - Random) * FJitter;
          if ScanForward then
            CurrPos.X := FXMax + FDV_ZY * (1.0 - Random) * FJitter
          else
            CurrPos.X := FXMin - FDV_ZY * (1.0 - Random) * FJitter;
        end
        else begin
          CurrPos.Y := U;
          CurrPos.Z := V;
          if ScanForward then
            CurrPos.X := FXMax
          else
            CurrPos.X := FXMin;
        end;

        FRayCaster.CastRay(FConfig, CurrPos, Dir);
        V := V + FDV_ZY;

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
            exit;
          end;
        end;

      end;
    end;
  end;

  procedure ScanXZ( const ScanForward: Boolean );
  var
    J: Integer;
    U, V: Double;
    CurrPos, Dir: TD3Vector;
  begin
    with FConfig do begin
      U := TXYZWrapper( FConfig.FVertexGenConfig.SharedWorkList[ Idx ] ).Z;
      V := FVMin_XZ;
      for J := 0 to FSlicesV - 1 do begin

        Dir.X := 0.0;
        if ScanForward then
          Dir.Y := -FStepSize
        else
          Dir.Y := FStepSize;
        Dir.Z := 0;

        if FJitter > JITTER_MIN then begin
          CurrPos.X := U + FDV_XZ * (1.0 - Random) * FJitter;
          CurrPos.Z := V + FDV_XZ * (1.0 - Random) * FJitter;
          if ScanForward then
            CurrPos.Y := FYMax + FDV_XZ * (1.0 - Random) * FJitter
          else
            CurrPos.Y := FYMin - FDV_XZ * (1.0 - Random) * FJitter;
        end
        else begin
          CurrPos.X := U;
          CurrPos.Z := V;
          if ScanForward then
            CurrPos.Y := FYMax
          else
            CurrPos.Y := FYMin;
        end;

        FRayCaster.CastRay(FConfig, CurrPos, Dir);
        V := V + FDV_XZ;

        with FMCTparas do begin
          if PCalcThreadStats.CTrecords[iThreadID].iDEAvrCount < 0 then begin
            PCalcThreadStats.CTrecords[iThreadID].iActualYpos := FSlicesU;
            exit;
          end;
        end;

      end;
    end;
  end;

begin
  with FConfig do begin
    for I := 0 to FSlicesU - 1 do begin
      Sleep(1);

      Idx := I + FUMinIndex;
      if ( Idx < 0 ) or ( Idx >= FConfig.FVertexGenConfig.SharedWorkList.Count ) then
        OutputDebugString(PChar('###################'+IntToStr(Idx)+' '+IntToStr( FUMinIndex ) + ' '+IntToStr(FConfig.FVertexGenConfig.SharedWorkList.Count)));

      ScanXY( True );
      ScanXY( False );
      ScanZY( True );
      ScanZY( False );
      ScanXZ( True );
      ScanXZ( False );

      with FMCTparas do begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := Round(I * 100.0 / FSlicesU);
      end;
    end;
  end;
end;
{ --------------------------------- TRayCaster ------------------------------- }
var
  DummyColorR, DummyColorG, DummyColorB: Double;

function TRayCaster.IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double ): Boolean;
begin
  Result := IsInsideBulb( FConfig, X, Y, Z, False, DummyColorR, DummyColorG, DummyColorB);
end;

function TRayCaster.IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double; const DoCalcColor: Boolean; var ColorR, ColorG, ColorB: Double ): Boolean;
var
  de: Double;
  CC: TVec3D;
  s: Single;
  psiLight: TsiLight5;
  iDif: TSVec;
  LightParas: TPLightingParas9;
  xx: Single;

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

  procedure CalcSIgradient1;
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

  procedure CalcSIgradient2;
  var
    RSFmul: Single;
    itmp: Integer;
  begin
    with FConfig do begin
      if FMCTparas.ColorOnIt <> 0 then
        RMdoColorOnIt(@FMCTparas);
      RMdoColor(@FMCTparas); //here for otrap
      if FMCTparas.ColorOption > 4 then FMCTparas.mPsiLight.SIgradient := 32768 or FMCTparas.mPsiLight.SIgradient else
      if FMCTparas.bInsideRendering then  begin
        FIteration3Dext.CalcSIT := True;
        FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas);
        RSFmul := FIteration3Dext.SmoothItD * FMCTparas.mctsM;
        MinMaxClip15bit(RSFmul, FMCTparas.mPsiLight.SIgradient);
        FMCTparas.mPsiLight.SIgradient := 32768 or FMCTparas.mPsiLight.SIgradient;
      end
      else FMCTparas.mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(FIteration3Dext.Rout / FMCTparas.dRStop));
    end;
  end;

  procedure CalcSIgradient3;
  var
    RSFmul: Single;
    itmp: Integer;
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

begin
  with FConfig do begin
    LightParas := @FM3Vfile.VHeader.Light;
    FMCTparas.mPsiLight := TPsiLight5(@psiLight);
    FMCTparas.Ystart := TPVec3D(@FM3Vfile.VHeader.dXmid)^;                                   //abs offs!
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[0], FM3Vfile.VHeader.Width * -0.5 + FM3Vfile.Xoff / FScale);
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[1], FM3Vfile.VHeader.Height * -0.5 + FM3Vfile.Yoff / FScale);
    mAddVecWeight(@FMCTparas.Ystart, @FMCTparas.Vgrads[2], Z - FM3Vfile.Zslices * 0.5 + FM3Vfile.Zoff / FScale);
    mCopyAddVecWeight(@CC, @FMCTparas.Ystart, @FMCTparas.Vgrads[1], Y);
    FIteration3Dext.CalcSIT := False;
    mCopyAddVecWeight(@FIteration3Dext.C1, @CC, @FMCTparas.Vgrads[0], X);

    if FMCTparas.iSliceCalc = 0 then //on maxits , does not work in DEcomb mode!
    begin
      if FMCTparas.DEoption > 19 then
        FMCTparas.mMandFunctionDE(@FIteration3Dext.C1)
      else
        FMCTparas.mMandFunction(@FIteration3Dext.C1);
      if FMCTparas.bInAndOutside then begin
        if (FIteration3Dext.ItResultI < FMCTparas.iMaxIt) and
           (FIteration3Dext.ItResultI >= FMCTparas.AOdither) then
          Result := True
        else
          Result := False;
      end
      else
      begin
        if FIteration3Dext.ItResultI < FMCTparas.iMaxIt then
          Result := False
        else
          Result := True;
        if FMCTparas.bInsideRendering then Result := not Result;
      end;
    end
    else
    begin
      de := FMCTparas.CalcDE(@FIteration3Dext, @FMCTparas);   //in+outside: only if d between dmin and dmax
      if de < FMCTparas.DEstop then begin
        if FMCTparas.bInAndOutside and (de < FMCTparas.DEAOmaxL) then
          Result := False
        else
          Result := True;
      end
      else
        Result := False;
    end;

    if Result and DoCalcColor then begin
      CalcSIgradient3;
      CalcColors(@iDif, @psiLight, @FLightVals);
      ColorR := iDif[0];
      ColorG := iDif[1];
      ColorB := iDif[2];
    end
    else begin
      ColorR := 0;
      ColorG := 0;
      ColorB := 0;
    end;
  end;
end;

function TRayCaster.CalculateNormal(const FConfig: TObjectScannerConfig; const Direction, FacePos: TD3Vector; const N: TPD3Vector; const WasInside: Boolean): Boolean;
const
  EPS = 1.0e-5;
  SAMPLES = 6;
var
  I: Integer;
  Axis, A, N1, N2: TD3Vector;
  Angle, DAngle, SinA, CosA: Double;
  T: Array[0..SAMPLES - 1] of TD3Vector;
  NT: Array[0..SAMPLES - 1] of TD3Vector;
  NTValid: Array[0..SAMPLES - 1] of Boolean;
  IM, L, LL, B, SinA_L, CosA_LL, Tmp: TD3Matrix;
  TV, StartPos, NDirection, NDirectionB, CurrPos: TD3Vector;
  NStepSize, RayDist, MaxRayDist: Double;
  PrevInside, CurrInside: Boolean;
  P1, P2: TD3Vector;
  L1, L2: Double;
  NTCount: Integer;
begin
  TDVectorMath.Assign(@Axis, @Direction);
  TDVectorMath.Normalize(@Axis);
  TDVectorMath.NonParallel(@A, @Axis);
  TDVectorMath.CrossProduct(@A, @Axis, @T[0]);
  TDVectorMath.Normalize(@T[0]);

  DAngle := DegToRad(360.0 / SAMPLES);
  Angle := DAngle;
  NStepSize := FConfig.FStepSize / 100.0;

  (*
     http://steve.hollasch.net/cgindex/math/rotvec.html
      let
          [v] = [vx, vy, vz]      the vector to be rotated.
          [l] = [lx, ly, lz]      the vector about rotation
                | 1  0  0|
          [i] = | 0  1  0|           the identity matrix
                | 0  0  1|

                |   0  lz -ly |
          [L] = | -lz   0  lx |
                |  ly -lx   0 |

          d = sqrt(lx*lx + ly*ly + lz*lz)
          a                       the angle of rotation

      then

     matrix operations gives:

      [v] = [v]x{[i] + sin(a)/d*[L] + ((1 - cos(a))/(d*d)*([L]x[L]))}
  *)
  TDMatrixMath.Identity(@IM);
  with L do begin
    M[0, 0] := 0.0;
    M[0, 1] := Axis.Z;
    M[0, 2] := -Axis.Y;
    M[1, 0] := -Axis.Z;
    M[1, 1] := 0.0;
    M[1, 2] := Axis.X;
    M[2, 0] := Axis.Y;
    M[2, 1] := -Axis.X;
    M[2, 2] := 0.0;
  end;
  TDMatrixMath.Multiply(@L, @L, @LL);

  for I := 1 to SAMPLES - 1 do begin
    SinCos(Angle, SinA, CosA);
    TDMatrixMath.ScalarMul(SinA, @L, @SinA_L);
    TDMatrixMath.ScalarMul(1.0 - CosA, @LL, @CosA_LL);
    TDMatrixMath.Add(@IM, @SinA_L, @Tmp);
    TDMatrixMath.Add(@Tmp, @CosA_LL, @B);
    TDMatrixMath.VMultiply(@T[0], @B, @T[I]);
    Angle := Angle + DAngle;
  end;

  TDVectorMath.Assign(@NDirection, @Axis);
  TDVectorMath.ScalarMul(NStepSize, @NDirection, @NDirection);
  TDVectorMath.Assign(@NDirectionB, @NDirection);
  TDVectorMath.ScalarMul(-1.0, @NDirectionB, @NDirectionB);
  MaxRayDist := FConfig.FStepSize * 0.75;

  NTCount := 0;
  for I := 0 to SAMPLES - 1 do begin
    TDVectorMath.ScalarMul(NStepSize, @T[I], @TV);
    TDVectorMath.Add(@FacePos, @TV, @StartPos);

    NTValid[I] := False;

    L1 := -1;
    RayDist := NStepSize;
    TDVectorMath.Assign(@CurrPos, @StartPos);
    TDVectorMath.AddTo(@CurrPos, @NDirection);
    while(RayDist < MaxRayDist) do begin
      CurrInside := IsInsideBulb(FConfig, CurrPos.X, CurrPos.Y, CurrPos.Z);
      if WasInside <> CurrInside then begin
        L1 := RayDist;
        TDVectorMath.Assign(@P1, @CurrPos);
        break;
      end;
      RayDist := RayDist + NStepSize;
      TDVectorMath.AddTo(@CurrPos, @NDirection);
    end;

    L2 := -1;
    RayDist := NStepSize;
    TDVectorMath.Assign(@CurrPos, @StartPos);
    TDVectorMath.AddTo(@CurrPos, @NDirectionB);
    while(RayDist < MaxRayDist) do begin
      CurrInside := IsInsideBulb(FConfig, CurrPos.X, CurrPos.Y, CurrPos.Z);
      if WasInside <> CurrInside then begin
        L2 := RayDist;
        TDVectorMath.Assign(@P2, @CurrPos);
        break;
      end;
      RayDist := RayDist + NStepSize;
      TDVectorMath.AddTo(@CurrPos, @NDirectionB);
    end;

    if (L1 >= 0.0) and (L2 < 0.0)  then begin
      TDVectorMath.Assign(@NT[I], @P1);
      NTValid[I] := True;
    end
    else if (L1 < 0.0) and (L2 >= 0.0)  then begin
      TDVectorMath.Assign(@NT[I], @P2);
      NTValid[I] := True;
    end
    else if (L1 >= 0.0) and (L2 >= 0.0)  then begin
      if L1 < L2 then
        TDVectorMath.Assign(@NT[I], @P1)
      else
        TDVectorMath.Assign(@NT[I], @P2);
      NTValid[I] := True;
    end
    else begin
      TDVectorMath.Assign(@NT[I], @StartPos);
      NTValid[I] := True;
    end;
  end;

  TDVectorMath.Clear(N);
  for I := 0 to SAMPLES - 2 do begin
    N1.X := NT[I+1].X - FacePos.X;
    N1.Y := NT[I+1].Y - FacePos.Y;
    N1.Z := NT[I+1].Z - FacePos.Z;

    N2.X := NT[I].X - FacePos.X;
    N2.Y := NT[I].Y - FacePos.Y;
    N2.Z := NT[I].Z - FacePos.Z;

    TDVectorMath.CrossProduct(@N1, @N2, @TV);
    TDVectorMath.AddTo(N, @TV);
  end;
  N1.X := NT[0].X - FacePos.X;
  N1.Y := NT[0].Y - FacePos.Y;
  N1.Z := NT[0].Z - FacePos.Z;

  N2.X := NT[SAMPLES - 1].X - FacePos.X;
  N2.Y := NT[SAMPLES - 1].Y - FacePos.Y;
  N2.Z := NT[SAMPLES - 1].Z - FacePos.Z;
  TDVectorMath.CrossProduct(@N1, @N2, @TV);
  TDVectorMath.AddTo(N, @TV);
  TDVectorMath.Normalize(N);

//  TDVectorMath.ScalarMul(0.1, N, N);

  if WasInside then
    TDVectorMath.Flip(N);
  Result := True;
end;
{ ---------------------- TCreatePointCloudRayCaster -------------------------- }
constructor TCreatePointCloudRayCaster.Create(VertexList, NormalsList, ColorList: TPS3VectorList);
begin
  inherited Create;
  FVertexList := VertexList;
  FNormalsList := NormalsList;
  FColorList := ColorList;
end;

procedure TCreatePointCloudRayCaster.CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector);
const
  ColorScale = 2.0;
var
  PrevInside, CurrInside: Boolean;
  RayDist: Double;
  CurrPos, N: TD3Vector;
  R, G, B, LastInsideR, LastInsideG, LastInsideB: Double;
  LColor, RColor, LPosition, RPosition: Cardinal;
  CScale: Double;
  I: Integer;
  HasRanges, ValidPoint: Boolean;
begin
  RayDist := FConfig.FStepSize;
  PrevInside := False;
  LastInsideR := 0.0;
  LastInsideG := 0.0;
  LastInsideB := 0.0;
  TDVectorMath.Assign(@CurrPos, @FromPos);
  TDVectorMath.AddTo(@CurrPos, @Direction);
  HasRanges := FConfig.FVertexGenConfig.TraceRanges.Count > 0;
  while(RayDist < FConfig.FMaxRayDist) do begin
    CurrInside := IsInsideBulb(FConfig, CurrPos.X, CurrPos.Y, CurrPos.Z, FConfig.FVertexGenConfig.CalcColors, R, G, B);
    if CurrInside then begin
      LastInsideR := R;
      LastInsideG := G;
      LastInsideB := B;
    end;
    if PrevInside <> CurrInside then begin
      if (CurrPos.X >= FConfig.FXMin) and (CurrPos.X <= FConfig.FXMax) and (CurrPos.Y >= FConfig.FYMin) and (CurrPos.Y <= FConfig.FYMax) and (CurrPos.Z >= FConfig.FZMin) and (CurrPos.Z <= FConfig.FZMax) then begin
        ValidPoint := True;
        if HasRanges then begin
          for I := 0 to FConfig.FVertexGenConfig.TraceRanges.Count - 1 do begin
            if  TTraceRange( FConfig.FVertexGenConfig.TraceRanges[ I ] ).Evaluate( CurrPos.X, CurrPos.Y, CurrPos.Z ) then begin
              ValidPoint := False;
              break;
            end;
          end;
        end;

        if ValidPoint  then begin
          if FConfig.FVertexGenConfig.CalcNormals then begin
            if CalculateNormal(FConfig, Direction, CurrPos, @N, CurrInside) then begin
              if FConfig.FVertexGenConfig.CalcColors then begin
                FColorList.AddVertex(LastInsideR, LastInsideG, LastInsideB);
                FNormalsList.AddVertex(N);
                FVertexList.AddVertex(CurrPos);
              end;
            end;
          end
          else begin
            FVertexList.AddVertex(CurrPos);
            if FConfig.FVertexGenConfig.CalcColors then
              FColorList.AddVertex(LastInsideR, LastInsideG, LastInsideB);
          end;
        end;
      end;
      PrevInside := CurrInside;
    end;
    RayDist := RayDist + FConfig.FStepSize;
    TDVectorMath.AddTo(@CurrPos, @Direction);
  end;
end;
{ ------------------------- TCreateMeshRayCaster ----------------------------- }
constructor TCreateMeshRayCaster.Create(FacesList: TFacesList; const ISOValue: Double);
begin
  inherited Create;
  FFacesList := FacesList;
  FISOValue := ISOValue;
end;

procedure TCreateMeshRayCaster.CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector);
var
  I: Integer;
  RayDist: Double;
  CurrPos: TD3Vector;
  MCCube: TMCCube;
  D: Double;

  function CalculateDensity1(const Position: TPD3Vector): Single;
  begin
    Result := Ord(IsInsideBulb(FConfig, Position^.X, Position^.Y, Position^.Z));
  end;

  function CalculateDensity8(const Position: TPD3Vector): Single;
  begin
    Result := (
      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z + D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z + D))
    ) / 8.0;
  end;

  function CalculateDensityG8(const Position: TPD3Vector): Single;
  begin
    Result := (
      4.0 * Ord(IsInsideBulb(FConfig, Position^.X, Position^.Y, Position^.Z)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z + D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z + D))
    ) / 12.0;
  end;

  function CalculateDensity27(const Position: TPD3Vector): Single;
  begin
    Result := (
      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y - D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y, Position^.Z - D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y + D, Position^.Z - D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z - D)) +


      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y - D, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y, Position^.Z)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y + D, Position^.Z)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z)) +


      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y - D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y - D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y - D, Position^.Z + D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y, Position^.Z + D)) +

      Ord(IsInsideBulb(FConfig, Position^.X - D , Position^.Y + D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X  , Position^.Y + D, Position^.Z + D)) +
      Ord(IsInsideBulb(FConfig, Position^.X + D , Position^.Y + D, Position^.Z + D))
    ) / 27.0;
  end;

  function CalculateDensity(const Position: TPD3Vector): Single;
  begin
    case FConfig.FVertexGenConfig.Oversampling of
      osNone: Result := CalculateDensity1(Position);
      os2x2x2: Result := CalculateDensity8(Position);
      os3x3x3: Result := CalculateDensity27(Position);
    end;
  end;

begin
  RayDist := 0.0;
  TDVectorMath.Assign(@CurrPos, @FromPos);
  D := FConfig.FStepSize / 2.0;
  while(RayDist <= FConfig.FMaxRayDist) do begin
    TMCCubes.InitializeCube(@MCCube, @CurrPos, FConfig.FStepSize);
    for I := 0 to 7 do begin
      MCCube.V[I].Weight := CalculateDensity(@MCCube.V[I].Position);
    end;
    TMCCubes.CreateFacesForCube(@MCCube, FISOValue, FFacesList);

    RayDist := RayDist + FConfig.FStepSize;
    TDVectorMath.AddTo(@CurrPos, @Direction);
  end;
end;


end.

