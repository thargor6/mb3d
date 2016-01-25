unit CalcVoxelSliceThread;

interface

uses
  Windows, Classes, TypeDefinitions;

type
  TCalcVoxelSliceThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;
function CalcVoxelSlice(Header: TPMandHeader10; PCTS: TPCalcThreadStats;
                        FSIstart, FSIoffset: Integer): Boolean;

implementation

uses Mand, Math, DivUtils, formulas, LightAdjust, Math3D, HeaderTrafos, Calc;

function CalcVoxelSlice(Header: TPMandHeader10; PCTS: TPCalcThreadStats;
                        FSIstart, FSIoffset: Integer): Boolean;
var x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    CalcVoxelSliceThread: array of TCalcVoxelSliceThread;
begin
  Result := False;
  try
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    MCTparas := getMCTparasFromHeader(Header^, True);
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
      MCTparas.FSIstart := FSIstart;
      MCTparas.FSIoffset := FSIoffset;
      MCTparas.PCalcThreadStats := PCTS;
      SetLength(CalcVoxelSliceThread, ThreadCount);
    end;
  finally
  end;
  if Result then
  begin
    for x := 0 to ThreadCount - 1 do
    begin
      PCTS^.CTrecords[x + 1].iActualYpos := -1;
      MCTparas.iThreadId := x + 1;
      try
        CalcVoxelSliceThread[x] := TCalcVoxelSliceThread.Create(True);
        CalcVoxelSliceThread[x].FreeOnTerminate := True;
        CalcVoxelSliceThread[x].MCTparas        := MCTparas;
        CalcVoxelSliceThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        PCTS.CTrecords[x + 1].isActive := 1;
      except
        ThreadCount := x;
        Break;
      end;
    end;
    PCTS.HandleType := 0;
    for x := 0 to ThreadCount - 1 do CalcVoxelSliceThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS^.iTotalThreadCount := ThreadCount;
    for x := 0 to ThreadCount - 1 do CalcVoxelSliceThread[x].Start;
  end;    
end;


{ T2DcalcThread }

procedure TCalcVoxelSliceThread.Execute;
var CC: TVec3D;
    PC: PCardinal;
    x, y: Integer;
begin
  try
    with MCTparas do
    begin
      IniIt3D(@MCTparas, @Iteration3Dext);
     { Iteration3Dext.J4 := dJUw;
      Iteration3Dext.Ju4 := dJUw;
      FastMove(dJUx, Iteration3Dext.J1, 168);
      FastMove(dJUx, Iteration3Dext.Ju1, 24);
      FastMove(Smatrix4d, Iteration3Dext.Smatrix4, 64);  }
      Iteration3Dext.CalcSIT := False;
      y := iThreadId - 1;
      while y < iMandHeight do
      begin
        PC := PCardinal(FSIstart + FSIoffset * y);
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        for x := 1 to iMandWidth do
        begin
          mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x - 1);
          if NormalsOnDE then //here: use distance estimator for proof of "pixel in set"
          begin               //ColorOption, here: set is white if 1, else black


          end
          else
          begin
            mMandFunction(@Iteration3Dext.C1);
            if (Iteration3Dext.ItResultI < MaxItsResult) xor (ColorOption <> 0) then PC^ := 0 else PC^ := $FFFFFF;
          end;
          Inc(PC);
          if PCalcThreadStats^.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats^.pLBcalcStop^ then Break;
        PCalcThreadStats^.CTrecords[iThreadID].iActualYpos := y;
        Inc(y, iThreadCount);
      end;
    end;
  finally
    with MCTparas do
    begin
      PCalcThreadStats^.CTrecords[iThreadID].isActive := 0;
      if not PCalcThreadStats^.pLBcalcStop^ then
        PCalcThreadStats^.CTrecords[iThreadID].iActualYpos := iMandHeight - 1;
      PostMessage(PCalcThreadStats^.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
  end;
end;

end.

