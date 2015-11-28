unit MapSequences;

interface

uses
  Classes, SysUtils;

type
  TMapSequence = class
  private
    FDestChannel: Integer;
    FImageFilename: String;
    FFirstImage: Integer;
    FLastImage: Integer;
    FLoop: Boolean;
  public
    function GetFilename(const Frame: Integer): String;
    property DestChannel: Integer read FDestChannel;
    property ImageFilename: String read FImageFilename;
    property FirstImage: Integer read FFirstImage;
    property LastImage: Integer read FLastImage;
    property Loop: Boolean read FLoop;
  end;

  TMapSequenceList = class
  private
    FList: TStringList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TMapSequence;
  public
    constructor Create;
    destructor Destroy;override;
    procedure Clear;
    function GetSequence(const Channel: Integer): TMapSequence;
    procedure AddSequence(const Sequence: TMapSequence);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMapSequence read GetItem;
  end;

  TMapSequenceListPersister = class
  private
    class function GetInitFilename: String;
  public
    class procedure Load(const Sequences: TMapSequenceList);
    class procedure Save(const Sequences: TMapSequenceList);
  end;

  TMapSequenceListProvider = class
  public
    class function GetInstance: TMapSequenceList;
  end;

  TMapSequenceFrameNumberHolder = class
  public
    class procedure SetCurrFrameNumber(const Frame: Integer); // To avoid to change the API of loading maps which is also from ASM
    class function GetCurrFrameNumber: Integer;
  end;

implementation

uses
  Contnrs, Windows, Mand;

{ ------------------------------ TMapSequence -------------------------------- }
function TMapSequence.GetFilename(const Frame: Integer): String;
var
  I, NumLen: Integer;
  PosExtension, PosNumStart, LFrame: Integer;
  hs: String;
begin
  Result := '';

  PosExtension := -1;
  for I := Length(FImageFilename) downto 1 do
    if FImageFilename[I] = '.' then begin
      PosExtension := I;
      break;
    end;
  if PosExtension < 0 then
    exit;

  PosNumStart := -1;
  for I := PosExtension - 1  downto 1 do
    if (FImageFilename[I] < '0') or (FImageFilename[I]>'9') then begin
      PosNumStart := I + 1;
      break;
    end;
  if (PosNumStart < 0) or (PosNumStart = PosExtension) then
    exit;

  NumLen := PosExtension - PosNumStart;

  LFrame := Frame + FirstImage - 1;
  if LFrame < FirstImage then
    LFrame := FirstImage
  else if LFrame > LastImage then
    LFrame := LastImage;
  hs := IntToStr( LFrame );

  while Length(hs)<NumLen do
    hs := '0' + hs;

  Result := Copy(FImageFilename, 1, PosNumStart - 1) + hs + Copy(FImageFilename, PosExtension, Length(FImageFilename) - PosExtension +1);
end;
{ ---------------------------- TMapSequenceList ------------------------------ }
constructor TMapSequenceList.Create;
begin
  inherited Create;
  FList := TStringList.Create;
  FList.CaseSensitive := True;
  FList.Sorted := True;
end;

destructor TMapSequenceList.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TMapSequenceList.Clear;
var
  I: Integer;
begin
  for I := 0 to FList.Count -1 do
    if FList.Objects[I] <> nil then
      FList.Objects[I].Free;
  FList.Clear;
end;

function TMapSequenceList.GetSequence(const Channel: Integer): TMapSequence;
var
  Idx: Integer;
begin
  Idx := FList.IndexOf(IntToStr(Channel));
  if Idx >= 0 then
    Result := TMapSequence(FList.Objects[Idx])
  else
    Result := nil;
end;

procedure TMapSequenceList.AddSequence(const Sequence: TMapSequence);
var
  Key: String;
begin
  Key := IntToStr(Sequence.DestChannel);
  if FList.IndexOf(Key) >= 0 then
    raise Exception.Create('An sequence for target channel <'+Key+'> already exists');
  FList.AddObject(Key, Sequence);
end;

function TMapSequenceList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMapSequenceList.GetItem(Index: Integer): TMapSequence;
begin
  Result := TMapSequence(FList.Objects[Index]);
end;
{ ------------------------ TMapSequenceListPersister ------------------------- }
const
  PropName_Count = 'Count';
  PropName_DestChannel = 'DestChannel';
  PropName_ImageFilename = 'ImageFilename';
  PropName_FirstImage = 'FirstImage';
  PropName_LastImage = 'LastImage';
  PropName_Loop = 'Loop';

class function TMapSequenceListPersister.GetInitFilename: String;
begin
  Result := Mand.AppFolder + 'Mandelbulb3DMSeq.ini';
end;

class procedure TMapSequenceListPersister.Load(const Sequences: TMapSequenceList);
var
  Lst: TStringList;
  I, Count: Integer;
  Filename, PostFix: String;
  Sequence: TMapSequence;
begin
  Sequences.Clear;
  Filename := GetInitFilename;
  if FileExists(Filename) then begin
    Lst := TStringList.Create;
    try
      Lst.LoadFromFile(Filename);
      Count := StrToInt('0'+Lst.Values[PropName_Count]);
      for I := 0 to Count - 1 do begin
        PostFix := '#'+IntToStr(I);
        Sequence := TMapSequence.Create;
        Sequences.AddSequence(Sequence);
        Sequence.FDestChannel := StrToInt('0'+Lst.Values[PropName_DestChannel+PostFix]);
        Sequence.FImageFilename := Lst.Values[PropName_ImageFilename+PostFix];
        Sequence.FFirstImage := StrToInt('0'+Lst.Values[PropName_FirstImage+PostFix]);
        Sequence.FLastImage := StrToInt('0'+Lst.Values[PropName_LastImage+PostFix]);
        Sequence.FLoop := Boolean(StrToInt('0'+Lst.Values[PropName_Loop+PostFix]));
      end;
    finally
      Lst.Free;
    end;
  end;
end;

class procedure TMapSequenceListPersister.Save(const Sequences: TMapSequenceList);
var
  Lst: TStringList;
  I: Integer;
  Sequence: TMapSequence;
  PostFix: String;
begin
  Lst := TStringList.Create;
  try
    Lst.Values[PropName_Count] := IntToStr(Sequences.Count);
    for I := 0 to Sequences.Count - 1 do begin
      Sequence := Sequences.Items[I];
      PostFix := '#'+IntToStr(I);
      Lst.Values[PropName_DestChannel+PostFix] := IntToStr(Sequence.DestChannel);
      Lst.Values[PropName_ImageFilename+PostFix] := Sequence.ImageFilename;
      Lst.Values[PropName_FirstImage+PostFix] := IntToStr(Sequence.FirstImage);
      Lst.Values[PropName_LastImage+PostFix] := IntToStr(Sequence.LastImage);
      Lst.Values[PropName_Loop+PostFix] := IntToStr(Ord(Sequence.Loop));
    end;
    Lst.SaveToFile(GetInitFilename);
  finally
    Lst.Free;
  end;
end;
{ ------------------------ TMapSequenceListProvider -------------------------- }
var
  GMapSequenceList: TMapSequenceList;

class function TMapSequenceListProvider.GetInstance: TMapSequenceList;
begin
  if GMapSequenceList = nil then begin
    GMapSequenceList := TMapSequenceList.Create;
    TMapSequenceListPersister.Load(GMapSequenceList);
  end;
  Result := GMapSequenceList;
end;
{ -------------------- TMapSequenceFrameNumberHolder ------------------------- }
var
  CurrFrameNumber: Integer;

class procedure TMapSequenceFrameNumberHolder.SetCurrFrameNumber(const Frame: Integer);
begin
  CurrFrameNumber := Frame;
  OutputDebugString(PChar('#Frame Index '+IntToStr(Frame)));
end;

class function TMapSequenceFrameNumberHolder.GetCurrFrameNumber: Integer;
begin
  Result := CurrFrameNumber;
end;

initialization
  GMapSequenceList := nil;
  CurrFrameNumber := 1;
finalization
  if GMapSequenceList<>nil then
    GMapSequenceList.Free;
end.

