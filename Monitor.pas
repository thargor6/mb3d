////////////////////////////////////////////////////////////////////////////////
//
// Monitor.pas - Memory monitor
// ----------------------------
// Version:   2003-02-05
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Last changes:
//   Monitor is auto-enabled when assertions and debugging is enabled.
//
unit Monitor;

{DEFINE MonitorObjects}  // Define MonitorObjects to use object monitor
{DEFINE UseMonitorTags}  // Define UseMonitorTags to give each object a tag #

{D-} // Turn debug info off

interface

uses Classes;

{$IFDEF MonitorObjects}

const
  MemLogFile = 'memlog.txt';

type
  TMonitorObject = class(TObject)
    {$IFDEF UseMonitorTags}
    private
      MonitorTag : Integer;
    {$ENDIF}
    public
      constructor Create;
      destructor Destroy; override;
    end;

procedure GetMem(var P; Size: Integer);
procedure FreeMem(const P; Size: Integer=-1);

{$ELSE}
type TMonitorObject = TObject;
{$ENDIF}

// Return list of active objects and memory blocks
function GetMonitorLog(FreeObjects: Boolean=False): TStrings;

// Call example: Assert(MonitorComponent(Self)) in component constructor.
// This will ensure that the monitor is removed when assertions are turned off.
function MonitorComponent(Component: TComponent): Boolean;

implementation

{$IFNDEF MonitorObjects}

function GetMonitorLog(FreeObjects: Boolean): TStrings;
begin
  Result:=nil;
end;

function MonitorComponent(Component: TComponent): Boolean;
begin
  Result:=True;
end;

{$ELSE}

uses Windows, Contnrs, MMSystem, SysUtils, Dialogs, FileUtils, SyncObjs;

var
  PointerList, ObjectList : TStringList;
  Log : TStringList;
  Sync : TCriticalSection;
  TagNumber : Integer = 0;

function GetMonitorLog(FreeObjects: Boolean): TStrings;
var
  I, Count : Integer;
  Str : string;
begin
  Result:=TStringList.Create;
  Sync.Acquire;
  try
    Result.Assign(Log);
    for I:=ObjectList.Count-1 downto 0 do
    try
      Str:=ObjectList[I];
      if FreeObjects then ObjectList.Objects[I].Free;
      Result.Add('At $'+Str+' not freed');
    except
      Result.Add('At $'+ObjectList[I]+' Inherited destructor not called (or project needs rebuilding)');
    end;

    for I:=0 to PointerList.Count-1 do Result.Add('At $'+PointerList[I]+' bytes not freed');
  finally
    Sync.Release;
  end;

  TStringList(Result).Sort;
  I:=0;
  while I<Result.Count-1 do
  begin
    Count:=1;
    while (I<Result.Count-1) and (Result[I]=Result[I+1]) do
    begin
      Result.Delete(I+1);
      Inc(Count);
    end;
    if Count>1 then Result[I]:=Result[I]+' * '+IntToStr(Count);
    Inc(I);
  end;
end;

//==============================================================================================================================
// TComponentMonitor
//==============================================================================================================================

type
  TComponentMonitor = class(TComponent)
    public
      constructor Create(AOwner: TComponent; Addr: Cardinal); reintroduce;
      destructor Destroy; override;
    end;

function MonitorComponent(Component: TComponent): Boolean;
var
  Addr: Cardinal;
begin
  asm
    mov eax,[ebp+4]
    mov Addr,eax
  end;
  Result:=True;
  TComponentMonitor.Create(Component,Addr);
end;

constructor TComponentMonitor.Create(AOwner: TComponent; Addr: Cardinal);
begin
  inherited Create(AOwner);
  Sync.Acquire;
  try
    {$IFDEF UseMonitorTags}
    MonitorTag:=TagNumber;
    Inc(TagNumber);
    ObjectList.AddObject(IntToHex(Addr,8)+', time='+IntToStr(TimeGetTime)+', tag='+IntToStr(MonitorTag)+': '+Owner.ClassName,Self);
    {$ELSE}
    ObjectList.AddObject(IntToHex(Addr,8)+': '+Owner.ClassName,Self);
    {$ENDIF}
  finally
    Sync.Release;
  end;
end;

destructor TComponentMonitor.Destroy;
var
  I : Integer;
begin
  Sync.Acquire;
  try
    I:=ObjectList.IndexOfObject(Self);
    if I>=0 then ObjectList.Delete(I);
  finally
    Sync.Release;
  end;
  inherited;
end;

//==============================================================================================================================
// TMonitorObject
//==============================================================================================================================
constructor TMonitorObject.Create;
var
  Addr: Cardinal;
begin
  asm
    mov eax,[ebp+4]
    mov Addr,eax
  end;
  inherited;
  Sync.Acquire;
  try
    {$IFDEF UseMonitorTags}
    MonitorTag:=TagNumber;
    Inc(TagNumber);
    ObjectList.AddObject(IntToHex(Addr,8)+', time='+IntToStr(TimeGetTime)+', tag='+IntToStr(MonitorTag)+': '+ClassName,Self);
    {$ELSE}
    ObjectList.AddObject(IntToHex(Addr,8)+': '+ClassName,Self);
    {$ENDIF}
  finally
    Sync.Release;
  end;
end;

destructor TMonitorObject.Destroy;
var
  I : Integer;
begin
  Sync.Acquire;
  try
    I:=ObjectList.IndexOfObject(Self);
    if I>=0 then ObjectList.Delete(I)
    else Log.Add(ClassName+' at $'+IntToHex(Integer(Self),8)+' allready freed or inherited constructor/destructor not called')
  finally
    Sync.Release;
  end;
  inherited;
end;

//==============================================================================================================================
procedure GetMem(var P; Size: Integer);
var
  Addr: Cardinal;
begin
  asm
    mov eax,[ebp+4]
    mov Addr,eax
  end;
  System.GetMem(Pointer(P),Size);
  Sync.Acquire;
  try
    {$IFDEF UseMonitorTags}
    PointerList.AddObject(IntToHex(Addr,8)+', tag='+IntToStr(TagNumber)+': '+IntToStr(Size),Pointer(P));
    Inc(TagNumber);
    {$ELSE}
    PointerList.AddObject(IntToHex(Addr,8)+': '+IntToStr(Size),Pointer(P));
    {$ENDIF}
  finally
    Sync.Release;
  end;
end;

procedure FreeMem(const P; Size: Integer=-1);
var
  I : Integer;
begin
  Sync.Acquire;
  try
    I:=PointerList.IndexOfObject(Pointer(P));
    if I=-1 then
    begin
      if Size<>-1 then Log.Add(Format('Data at $%p allready freed',[Pointer(P)]))
    end
    else PointerList.Delete(I);
  finally
    Sync.Release;
  end;

  if Size<>-1 then System.FreeMem(Pointer(P),Size)
  else System.FreeMem(Pointer(P));
end;

initialization
  ObjectList:=TStringList.Create;
  ObjectList.Capacity:=100;

  PointerList:=TStringList.Create;
  PointerList.Capacity:=100;

  Log:=TStringList.Create;

  Sync:=TCriticalSection.Create;

finalization
  with GetMonitorLog(True) do
  begin
    if (Count>0) or (GetFileSize(ProgramPath+MemLogFile)<>0) then
    try
      SaveToFile(ProgramPath+MemLogFile);
    except
    end;
    if Count>0 then
      MessageBox(0,PChar(Text),'Monitor has detected a memory leak',MB_OK or MB_ICONWARNING);
    Free;
  end;
  Sync.Free;
  Log.Free;
  PointerList.Free;
  ObjectList.Free;
{$ENDIF}
end.

