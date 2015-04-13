unit Paint;
//
//  for painting the image out of the paras, only for animation previews, just mainthread
//
interface

uses Mand, TypeDefinitions;

procedure PaintM(Header: TPMandHeader11; LightVals: TPLightVals; PsiLight: TPsiLight5; SLstart, SLoffset: Integer);

implementation

uses PaintThread, LightAdjust, Math3D, DivUtils, Math, HeaderTrafos;

procedure PaintM(Header: TPMandHeader11; LightVals: TPLightVals; PsiLight: TPsiLight5; SLstart, SLoffset: Integer);
var x, y, wid, Dfunc: Integer;
    PC: PCardinal;
    PSL: TPsiLight5;
    PLV: TPaintLightVals;
    aspect, sFOV, wid1d: Single;
    d: Double;
    SPosX, SPosY, SPosXadd, SPosYadd: TSVec;
    PaintVGrads: TMatrix3;
    PaintParameter: TPaintParameter;
begin
    wid := Header.Width;
    if Header.bPlanarOptic = 2 then sFOV := Pi else
      sFOV := Header.dFOVy * Pid180;
    if (wid > 15) and (wid < 32767) then
    begin
      Dfunc := Header.Light.TBoptions shr 30; // 2:dfunc=2 1:dfunc=0
      wid1d := 1 / wid;
      CalcStepWidth(Header);
      PaintVGrads := NormaliseMatrixTo(Header.dStepWidth, @Header.hVGrads);
      PaintParameter.ppWidth  := Header.Width;
      PaintParameter.ppHeight := Header.Height;
      PaintParameter.ppYinc   := 1;
      PaintParameter.PLVals   := @LightVals;
      PaintParameter.pVgrads  := @PaintVGrads;
      PaintParameter.sFOVy    := sFOV;
      PaintParameter.ppXOff   := CalcXoff(Header);
      PaintParameter.ppPlanarOptic := Min(2, Header.bPlanarOptic and 3);
      d := Min(1.5, Max(0.01, sFOV * 0.5));
      PaintParameter.ppPlOpticZ := Cos(d) * d / Sin(d);
      CalcPPZvals(Header^, PaintParameter.Zcorr, PaintParameter.ZcMul, PaintParameter.ZZstmitDif);
      PaintParameter.StepWidth := Header.dStepWidth;
      PaintParameter.pPsiLight := PsiLight;

      PSL := PsiLight;
      if Header.bPlanarOptic = 2 then aspect := 2 else
        aspect := wid / Header.Height;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosY, SPosYadd, SPosXadd);
      for y := 0 to Header.Height - 1 do
      begin
        SPosX    := SPosY;
        PLV.yPos := y / Header.Height;
        PC       := PCardinal(SLstart + SLoffset * y);
        PreCalcDepthCol(Dfunc, @PLV, LightVals.PLValigned);
        for x := 1 to wid do
        begin
          PLV.xPos := x * wid1d;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PSL, @SPosX);
          LightVals.lvCalcPixelcolor(PC, PSL, LightVals, @PLV);
          Inc(PSL);
          Inc(PC);
          if PLV.iPlanarOptic <> 2 then AddSPos(SPosX, SPosXadd);
        end;
        if PLV.iPlanarOptic <> 2 then AddSPos(SPosY, SPosYadd);
      end;
    end;
end;

end.
