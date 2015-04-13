unit FormulaClass;

interface

uses Windows, Classes, TypeDefinitions;

type
  TFormulaClass = class
  private
    iFormulaType:    Integer;    //0: usual iteration loop   1: repeat from  2: InterpolStart 3: InterpolEnd
    iVersion:        Integer;
    SIMDlevel:       Integer;    //bitcombinated: 0: no simd, 1: SSE2, 2: SSE3, 4: SSSE3, 8: SSE4.1
    dDEscale:        Double;
    dADEscale:       Double;
    dSIpow:          Double;
    dRstop:          Double;
    iConstCount:     Integer;
    bCPmemReserved:  LongBool;
    VarBuffer:       array of Byte;
    procedure        Init;
    procedure        Cleanup;
  public
    pConstPointer16: Pointer;
    pCodePointer:    TPhybridIteration;         //points to formula one iteration or to other functions
    pIniPointer:     TPFormulaInitialization;
    FormulaName:     AnsiString;
    Description:     AnsiString;
    iDEoption:       Integer;
    iOptionCount:    Integer;
    sOptionStrings:  array of AnsiString;
    byOptionTypes:   array of Byte;
    dOptionVals:     array of Double;
    function    LoadFormula(FormulaName: AnsiString): LongBool;
    procedure   AssignOld(OldFormula: PTCustomFormula);
 //   procedure   FillWithValues(
    constructor Create;
    destructor  Destroy; override;
  end;
  TFormulaObject = class     //alternated hybrid, DEcombinate on a higher level with several TFormulaObjects
  private
    iFOVersion:       Integer;
    BoundingType:     Integer;    //0: RectBox  1: Ellipsoid
    BoundingMidPoint: array[0..3] of Single;
    BoundingRadius:   array[0..3] of Single;
    TransPoseMode:    Integer;    //0: no transpose  1: do object transpose
    JuliaMode:        Integer;    //0: no julia mode  1: do julia mode
    TransPose:        array[0..2, 0..3] of Single;  //scaled matrix and translation for 3d positioning+scaling+roatation
    JuliaVals:        array[0..3] of Double;
    iFormulaCount:    Integer;
    iFwasInitialized: array of Integer;
    Formulas:         array of TFormulaClass;  //also for repeat function or Interpolhybrid with next formula, ipolstart(copy vec to buf) ipolend(ipol with buf)
  end;
//THybridClass = class or record ... formula hybrids with bounding box/sphere, colortab? for use with DE comb and other hybrids

implementation

uses formulas, DivUtils, CustomFormulas;

function TFormulaClass.LoadFormula(FormulaName: AnsiString): LongBool;
var CustomFormula: TCustomFormula;
    CustomFname: array[0..31] of Byte;
begin
    IniCustomF(@CustomFormula);      //using old functions for loading... (initialization is still missing)
    PutStringInCustomF(CustomFname, FormulaName);
    Result := LoadCustomFormulaFromHeader(CustomFname, CustomFormula, dOptionVals);
    if Result then
    begin
      AssignOld(@CustomFormula);
      Description := CFdescription;
    end;
    FreeCF(@CustomFormula);
end;

procedure TFormulaClass.AssignOld(OldFormula: PTCustomFormula);
var i: Integer;
begin
    Cleanup;
    Init;
    SIMDlevel := OldFormula.SIMDlevel;
    dDEscale := OldFormula.dDEscale;
    dADEscale := OldFormula.dADEscale;
    dSIpow := OldFormula.dSIpow;
    dRstop := OldFormula.dRstop;
    iFormulaType := 0;
    iConstCount := OldFormula.iConstCount;
    iVersion := OldFormula.iVersion;
    iDEoption := OldFormula.iDEoption;
    iOptionCount := OldFormula.iCFOptionCount;
    SetLength(byOptionTypes, iOptionCount);
    SetLength(dOptionVals, iOptionCount);
    SetLength(sOptionStrings, iOptionCount);
    for i := 0 to iOptionCount - 1 do
    begin
      sOptionStrings[i] := OldFormula.sOptionStrings[i];
      byOptionTypes[i] := OldFormula.byOptionTypes[i];
    end;
    if OldFormula.pCodePointer = @EmptyFormula then
      OldFormula.bCPmemReserved := False;
    bCPmemReserved := OldFormula.bCPmemReserved;
    SetLength(VarBuffer, 1024);
    pConstPointer16 := Pointer((Integer(@VarBuffer[0]) + 271) and $FFFFFFF0);
    if OldFormula.pConstPointer16 = nil then
      OldFormula.pConstPointer16 := PAligned16;

    if OldFormula.pConstPointer16 = PAligned16 then
      FastMove(PAligned16^, pConstPointer16^, 216)
    else
      FastMove(Pointer(Integer(OldFormula.pConstPointer16) - 256)^,
               Pointer(Integer(pConstPointer16) - 256)^, 1008);
    if not bCPmemReserved then
      pCodePointer := OldFormula.pCodePointer
    else
    begin
      pCodePointer := VirtualAlloc(nil, 4096, {MEM_RESERVE} MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      FastMove(OldFormula.pCodePointer^, pCodePointer^, 4096);
    end;
    if Pointer(pIniPointer) <> nil then
      VirtualFree(pIniPointer, 1024, MEM_DECOMMIT);
    pIniPointer := nil;
end;

constructor TFormulaClass.Create;
begin
    inherited Create;
    Init;
end;

procedure TFormulaClass.Init;
begin
    pCodePointer := @EmptyFormula;
    pConstPointer16 := PAligned16;
    pIniPointer := nil;
    iFormulaType := 0;
    iOptionCount := 0;
    iConstCount := 0;
    bCPmemReserved := False;
    Description := '';
    FormulaName := '';
    pConstPointer16 := PAligned16;
end;

destructor TFormulaClass.Destroy;
//var i: Integer;
begin
    Cleanup;
    inherited Destroy;
end;

procedure TFormulaClass.Cleanup;
begin
    if bCPmemReserved and (pCodePointer <> @EmptyFormula) then
      VirtualFree(pCodePointer, {0}4096, {MEM_RELEASE} MEM_DECOMMIT);
    if pIniPointer <> nil then
      VirtualFree(pIniPointer, 1024, MEM_DECOMMIT);
    pIniPointer := nil;
    pCodePointer := @EmptyFormula;
    pConstPointer16 := PAligned16;
    bCPmemReserved := False;
    SetLength(VarBuffer, 0);
    SetLength(byOptionTypes, 0);
    SetLength(dOptionVals, 0);
    SetLength(sOptionStrings, 0);
    Description := '';
end;

end.
