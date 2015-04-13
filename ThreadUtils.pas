unit ThreadUtils;

// allocating, freeing mem for threadstats records giving an interface between
// threads and user interface.

interface

uses Windows, Classes, TypeDefinitions;

function GetNewThreadStatRecord(var CTSid: Integer; Count, HandleTyp: Integer; MessageHwnd: HWND): TPCalcThreadStats;
function GetActiveThreadCount(CTSid: Integer): Integer;
procedure GetMinY(CTSid: Integer; var yy: Double; var yimi, ymin, Tcount: Integer);
function GetPCTSfromID(CTSid: Integer): TPCalcThreadStats;

var
  CTSa: array[0..63] of TPCalcThreadStats;
  CTStmpi: Integer;
  CTSglobalId: Integer = 0;

implementation

uses Mand, Math;

function CTSarrayIsFree(CTSai: Integer): LongBool;
var i: Integer;
begin
    Result := True;
    if CTSa[CTSai] <> nil then
    begin
      for i := 1 to CTSa[CTSai].iTotalThreadCount do
      if CTSa[CTSai].CTrecords[i].isActive > 0 then
      begin
        Result := False;
        Break;
      end;
    end;
end;

function GetNextFreeIndex(var FreeCI: Integer): LongBool;
var i, c, f, n, tries: Integer;
begin
    Result := False;
    tries := 3;
    repeat
      c := 0;
      for i := 0 to 63 do
      begin
        if CTSarrayIsFree(i) then
        begin
          if not Result then
          begin
            Result := True;
            FreeCI := i;
          end;
          Inc(c);
          if c > 3 then Break;
        end;
      end;
      if c <= 3 then
      try
        for n := 1 to 3 do
        begin
          c := CTSglobalId;
          f := -1;
          for i := 0 to 63 do if (CTSa[i] <> nil) and (CTSa[i].CTSid < c) then
          begin
            c := CTSa[i].CTSid;
            f := i;
          end;
          if f >= 0 then
          begin
            for i := 1 to 64 do if CTSa[f].CTrecords[i].isActive <> 0 then
            try // thread.Terminate;
              TerminateThread((TObject(CTSa[f].CThandles[i]) as TThread).Handle, 0);
            except end;
        {  try    // suspend threads?
            for i := 1 to 64 do if CTSa[f].CTrecords[i].isActive <> 0 then
              (TObject(CTSa[f].CThandles[i]) as TThread).Suspend;
          except end;   }
            Dispose(CTSa[f]);
          end;
        end;
      except
      end;
      Dec(tries);
    until Result or (tries <= 0);
end;

function GetNewThreadStatRecord(var CTSid: Integer; Count, HandleTyp: Integer; MessageHwnd: HWND): TPCalcThreadStats;
var FreeCIndex, i: Integer;
begin
    Result := nil;
    CTSid := 0;
    CTSglobalId := (CTSglobalId and $3FFFFFFF) + 1;
    if GetNextFreeIndex(FreeCIndex) then
    begin
      if CTSa[FreeCIndex] <> nil then
      begin
        Dispose(CTSa[FreeCIndex]);
        CTSa[FreeCIndex] := nil;
      end;
      New(CTSa[FreeCIndex]);
      CTSa[FreeCIndex].iTotalThreadCount := Count;
      CTSa[FreeCIndex].CTSid := CTSglobalId;
      CTSa[FreeCIndex].pMessageHwnd := MessageHwnd;
      CTSa[FreeCIndex].HandleType := HandleTyp;
      for i := 1 to Count do CTSa[FreeCIndex].CTrecords[i].isActive := 1;
      CTSid := CTSglobalId;
      Result := CTSa[FreeCIndex];
    end;
end;

function GetIndexFromID(CTSid: Integer): Integer;
var i: Integer;
begin
    Result := -1;
    if CTSid = 0 then Exit;
    for i := 0 to 63 do if (CTSa[i] <> nil) and (CTSa[i].CTSid = CTSid) then
    begin
      Result := i;
      Break;
    end;
end;

function GetPCTSfromID(CTSid: Integer): TPCalcThreadStats;
var i: Integer;
begin
    i := GetIndexFromID(CTSid);
    if i < 0 then Result := nil else Result := CTSa[i];
end;

function GetActiveThreadCount(CTSid: Integer): Integer;
var i, ci: Integer;
begin
    Result := 0;
    ci := GetIndexFromID(CTSid);
    if ci >= 0 then
      for i := 1 to CTSa[ci].iTotalThreadCount do
        if CTSa[ci].CTrecords[i].isActive > 0 then Inc(Result);
end;

procedure GetMinY(CTSid: Integer; var yy: Double; var yimi, ymin, Tcount: Integer);
var xx, ymax: Double;
    ci, y: Integer;
begin
    yy := 0;
    yimi := 0;
    ymin := 0;
    Tcount := 0;
    ci := GetIndexFromID(CTSid);
    if ci < 0 then Exit;
    ymin := 999999;
    with CTSa[ci]^ do
    begin
      ymax := (ctCalcRect.Bottom - ctCalcRect.Top + 1) / iTotalThreadCount;
      xx := 1 / Max(1, ctCalcRect.Right - ctCalcRect.Left + 1);
      yimi := 0;
      for y := 1 to iTotalThreadCount do
      with CTrecords[y] do
      begin
        if iActualYpos < ymin then
        begin
          ymin := iActualYpos;
          yimi := y;
        end;
        if isActive > 0 then
        begin
          Inc(Tcount);
          yy := yy + Min(ymax, Max(0, iActualYpos - ctCalcRect.Top - y + 1) / iTotalThreadCount +
                               Max(0, iActualXpos - ctCalcRect.Left) * xx);
        end
        else yy := yy + ymax;
      end;
    end;
end;


initialization

  for CTStmpi := 0 to 63 do CTSa[CTStmpi] := nil;

end.
