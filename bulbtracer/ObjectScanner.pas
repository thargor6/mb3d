{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit ObjectScanner;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, TypeDefinitions, BulbTracerConfig, VertexList;

type
  TObjectScannerConfig = class
  protected
    FIteration3Dext: TIteration3Dext;
    FVertexGenConfig: TVertexGenConfig;
    FMCTparas: TMCTparameter;
    FM3Vfile: TM3Vfile;
    FXMin, FXMax, FYMin, FYMax, FZMin, FZMax, FCentreX, FCentreY, FCentreZ: Double;
    FStepSize, FScale, FMaxRayDist: Double;
  end;

  TRayCaster = class
  protected
    function IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double): Boolean;
    function CalculateNormal(const FConfig: TObjectScannerConfig; const Direction, FacePos: TD3Vector; const N: TPD3Vector; const WasInside: Boolean): Boolean;
  public
    procedure CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector); virtual; abstract;
  end;

  TCreatePointCloudRayCaster = class (TRayCaster)
  private
    FVertexList: TPS3VectorList;
  public
    constructor Create(VertexList: TPS3VectorList);
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
    FRayCaster: TRayCaster;
    procedure Init;

    procedure ScannerInit; virtual; abstract;
    procedure ScannerScan; virtual; abstract;
  public
    constructor Create(const VertexGenConfig: TVertexGenConfig; const MCTparas: TMCTparameter; const M3Vfile: TM3Vfile; const RayCaster: TRayCaster);
    destructor Destroy;override;
    procedure ScanObject;
  end;

  TSphericalScanner = class (TObjectScanner)
  protected
    FSlicesTheta, FSlicesPhi: Integer;
    FThetaMin, FPhiMin: Double;
    FDTheta, FDPhi: Double;
    FRadius, FStartDist: Double;
    procedure ScannerInit; override;
    procedure ScannerScan; override;
  end;

  TCubicScanner = class (TObjectScanner)
  protected
    FSlicesU, FSlicesV: Integer;
    FUMin, FVMin: Double;
    FDU, FDV: Double;
  protected
    procedure ScannerInit; override;
    procedure ScannerScan; override;
  end;


implementation

uses
  Windows, Math, Math3D, Calc, BulbTracer, DivUtils;

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

procedure TObjectScanner.ScanObject;
begin
  Init;
  ScannerScan;
end;
{ ----------------------------- TSphericalScanner ---------------------------- }
procedure TSphericalScanner.ScannerInit;
begin
  with FConfig do begin
    with FVertexGenConfig.URange, FMCTparas do begin
      FSlicesTheta := CalcStepCount(iThreadID, PCalcThreadStats.iTotalThreadCount);
      if FSlicesTheta < 1 then
        exit;
      FThetaMin := CalcRangeMin(iThreadID, PCalcThreadStats.iTotalThreadCount) * DegToRad( 360.0 );
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
      SinCos(Theta, SinTheta, CosTheta);
      Phi := FPhiMin;
      for J := 0 to FSlicesPhi -1 do begin
        SinCos(Phi, SinPhi, CosPhi);

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
{ ------------------------------- TCubicScanner ------------------------------ }
procedure TCubicScanner.ScannerInit;
begin
  with FConfig do begin
    with FVertexGenConfig.URange, FMCTparas do begin
      FSlicesU := CalcStepCount(iThreadID, PCalcThreadStats.iTotalThreadCount);
      if FSlicesU < 1 then
        exit;
      FUMin :=  FXMin + CalcRangeMin(iThreadID, PCalcThreadStats.iTotalThreadCount) * (FXMax - FXMin);
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

procedure TCubicScanner.ScannerScan;
var
  I, J: Integer;
  U, V: Double;
  CurrPos, Dir: TD3Vector;
begin
  with FConfig do begin
    U := FUMin;
    for I := 0 to FSlicesU - 1 do begin
      V := FVMin;
      for J := 0 to FSlicesV - 1 do begin

        Dir.X := 0.0;
        Dir.Y := 0.0;
        Dir.Z := FStepSize;

        CurrPos.X := U;
        CurrPos.Y := V;
        CurrPos.Z := FZMin;

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
{ --------------------------------- TRayCaster ------------------------------- }
function TRayCaster.IsInsideBulb(const FConfig: TObjectScannerConfig; const X, Y, Z: Double): Boolean;
var
  de: Double;
  CC: TVec3D;
  s: Single;
  psiLight: TsiLight5;
begin
  with FConfig do begin

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
           (FIteration3Dext.ItResultI >= FMCTparas.AOdither) then Result := True
                                                  else Result := False;
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
      else Result := False;
    end;

(*
    if Result then begin
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
//      OutputDebugString(PChar('SIgradient: '+IntToStr(FMCTparas.mPsiLight.Zpos)));
    end;
*)
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

  TDVectorMath.ScalarMul(0.1, N, N);

  if WasInside then
    TDVectorMath.Flip(N);
  Result := True;
end;
{ ---------------------- TCreatePointCloudRayCaster -------------------------- }
constructor TCreatePointCloudRayCaster.Create(VertexList: TPS3VectorList);
begin
  inherited Create;
  FVertexList := VertexList;
end;

procedure TCreatePointCloudRayCaster.CastRay(const FConfig: TObjectScannerConfig; const FromPos, Direction: TD3Vector);
var
  PrevInside, CurrInside: Boolean;
  RayDist: Double;
  CurrPos: TD3Vector;
begin
  RayDist := FConfig.FStepSize;
  PrevInside := False;
  TDVectorMath.Assign(@CurrPos, @FromPos);
  TDVectorMath.AddTo(@CurrPos, @Direction);
  while(RayDist < FConfig.FMaxRayDist) do begin
    CurrInside := IsInsideBulb(FConfig, CurrPos.X, CurrPos.Y, CurrPos.Z);
    if PrevInside <> CurrInside then begin
      if (CurrPos.X >= FConfig.FXMin) and (CurrPos.X <= FConfig.FXMax) and (CurrPos.Y >= FConfig.FYMin) and (CurrPos.Y <= FConfig.FYMax) and (CurrPos.Z >= FConfig.FZMin) and (CurrPos.Z <= FConfig.FZMax) then begin
//// TODO reintroduce normals-calculation
(*
        if FConfig.FVertexGenConfig.CalculateNormals then begin
          if CalculateNormal(FConfig, Direction, CurrPos, @N, CurrInside) then
            FVertexList.AddVertex(CurrPos, N);
        end
        else
*)
          FVertexList.AddVertex(CurrPos);
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

      if PsiLight.SIgradient > 32767 then CalcColorsInside(@Result[1], @Result[0], PsiLight, @LVals)
                                     else CalcColors(@Result[1], @Result[0], PsiLight, @LVals);

