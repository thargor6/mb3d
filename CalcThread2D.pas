unit CalcThread2D;

interface

uses
  Windows, SysUtils, Classes, TypeDefinitions;

type
  T2DcalcThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

implementation

uses Mand, Math, DivUtils, formulas, LightAdjust, Math3D, Calc;

{ T2DcalcThread }

procedure T2DcalcThread.Execute;
var CC: TVec3D;
    s: Single;
    x, y: Integer;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      bInsideRendering := False;
      bCalcInside := False;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := y; 
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        for x := CalcRect.Left to CalcRect.Right do    
        begin
          Iteration3Dext.CalcSIT := True;
          PInteger(@mPsiLight.NormalX)^ := 0;
          PInteger(@mPsiLight.RoughZposFine)^ := $4E200000;
          PInteger(@mPsiLight.Shadow)^ := $13880010;
          mPsiLight.NormalZ := -32768;
          mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x); 
          if DEoption > 19 then mMandFunctionDE(@Iteration3Dext.C1)
                           else mMandFunction(@Iteration3Dext.C1);
          if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
          RMdoColor(@MCTparas);
          if FormulaType > 0 then  //col on DE:
          begin
            s := Abs(CalcDE(@Iteration3Dext, @MCTparas) * 40);
            if Iteration3Dext.ItResultI < MaxItsResult then
            begin
              MinMaxClip15bit(s, mPsiLight.SIgradient);
              mPsiLight.NormalY := 5000;
            end
            else mPsiLight.SIgradient := Round(Min0MaxCS(s, 32767)) + 32768;
          end
          else
          begin
            if Iteration3Dext.ItResultI < iMaxIt then   //MaxItResult not intit without calcDE!
            begin
              s := Iteration3Dext.SmoothItD * 32767 / iMaxIt;
              MinMaxClip15bit(s, mPsiLight.SIgradient);
              mPsiLight.NormalY := 5000;
            end
            else mPsiLight.SIgradient := mPsiLight.OTrap + 32768;
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := CalcRect.Bottom;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

end.
 