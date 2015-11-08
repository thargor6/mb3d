unit FormulaNames;

interface

uses
  SysUtils, Classes;

type
  TFormulaCategory = (fc_3D, fc_3Da, fc_4D, fc_4Da, fc_Ads, fc_dIFS, fc_dIFSa);

  TFormulaName=class
    FCategory: TFormulaCategory;
    FFormulaName: String;
  public
    constructor Create(const Category: TFormulaCategory;const FormulaName: String);
    property Category: TFormulaCategory read FCategory;
    property FormulaName: String read FFormulaName;
  end;

  TFormulaNames = class
  private
    FFormulaNamesList: TList;
    function GetCount: Integer;
    function FNameIsIncluded(Name: String): Boolean;
    function GetFormulaName(Index: Integer): TFormulaName;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddFormulaName(Category: TFormulaCategory; const FormulaName: String);
    function GetFormulaNamesByCategory(const Category: TFormulaCategory): TStringList;
    function GetCategoryByFormulaName(const FormulaName: String): TFormulaCategory;
    property Count: Integer read GetCount;
    property Formulas[Index: Integer]: TFormulaName read GetFormulaName;
  end;

  TFormulaNamesLoader=class
  private
    class procedure AddFormulaName(FNames: TFormulaNames; FName: String; DEfunc: Integer);
  public
    class function GetFavouriteStatus(formulaname: String): Integer;  //-2: hide, -1: dislike, 0: normal, 1: like
    class function LoadFormulas: TFormulaNames;
  end;

const
  InternFormulasDEfunc: array[0..6] of Integer = (0,0,4,0,11,0,0);

implementation

uses
  Contnrs, HeaderTrafos, FileHandling, DivUtils, CustomFormulas;

{ ----------------------------- TFormulaName --------------------------------- }
constructor TFormulaName.Create(const Category: TFormulaCategory;const FormulaName: String);
begin
  inherited Create;
  FCategory := Category;
  FFormulaName := FormulaName;
end;
{ ----------------------------- TFormulaNames -------------------------------- }
constructor TFormulaNames.Create;
begin
  inherited Create;
  FFormulaNamesList := TObjectList.Create;
end;

destructor TFormulaNames.Destroy;
begin
  FFormulaNamesList.Free;
  inherited Destroy;
end;

function TFormulaNames.GetCount: Integer;
begin
  Result := FFormulaNamesList.Count;
end;

function TFormulaNames.FNameIsIncluded(Name: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FFormulaNamesList.Count - 1 do begin
    if CompareText(Trim(Name), StrLastWords( TFormulaName(FFormulaNamesList[I]).FormulaName  )) = 0 then begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFormulaNames.AddFormulaName(Category: TFormulaCategory; const FormulaName: String);
begin
  FFormulaNamesList.Add( TFormulaName.Create(Category, FormulaName) );
end;

function TFormulaNames.GetFormulaName(Index: Integer): TFormulaName;
begin
  Result := TFormulaName(FFormulaNamesList[Index]);
end;

// TODO Caching
function TFormulaNames.GetFormulaNamesByCategory(const Category: TFormulaCategory): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := 0 to Count-1 do begin
    if Formulas[I].Category = Category then
      Result.Add(Formulas[I].FormulaName);
  end;
end;

function TFormulaNames.GetCategoryByFormulaName(const FormulaName: String): TFormulaCategory;
var
  I: Integer;
begin
  for I := 0 to Count-1 do begin
    if Formulas[I].FormulaName = FormulaName then begin
      Result := Formulas[I].Category;
      exit;
    end;
  end;
  raise Exception.Create('TFormulaNames.GetCategoryByFormulaName: Formula <'+FormulaName+'> not found');
end;
{ -------------------------- TFormulaNamesLoader ----------------------------- }
class function TFormulaNamesLoader.GetFavouriteStatus(formulaname: String): Integer;  //-2: hide, -1: dislike, 0: normal, 1: like
var M: TStringList;
    i: Integer;
 //   bNotFound: LongBool;
begin
    Result := 1;
   // if (formulaname = '') or not FileExists(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt') then Exit;
    if (formulaname = '') or not FileExists(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt') then Exit;
    M := TStringList.Create;
    try
   //   M.LoadFromFile(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt');
      M.LoadFromFile(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt');
    except
      M.Clear;
    end;
//    bNotFound := True;
    for i := 1 to M.Count do
      if SameText(StrLastWords(M.Strings[i - 1]), formulaname) then
      begin
        Result := StrToInt(StrFirstWord(M.Strings[i - 1]));
        Break;
      end;
    M.Clear;
    M.Free;
end;

class procedure TFormulaNamesLoader.AddFormulaName(FNames: TFormulaNames;FName: String; DEfunc: Integer);
var
  stat: Integer;
begin
  stat := GetFavouriteStatus(FName);
  if stat > -2 then begin
    //FName := IntToStr(stat) + ' ' + FName;
    case DEfunc of
      2,11: FNames.AddFormulaName(fc_3Da, FName);
         4: FNames.AddFormulaName(fc_4D, FName);
       5,6: FNames.AddFormulaName(fc_4Da, FName);
     -1,-2: FNames.AddFormulaName(fc_Ads, FName);
        20: FNames.AddFormulaName(fc_dIFS, FName);
    21..22: FNames.AddFormulaName(fc_dIFSa, FName);
      else  // 3D
        FNames.AddFormulaName(fc_3D, FName);
    end;
  end;
end;

class function TFormulaNamesLoader.LoadFormulas: TFormulaNames;
var
  I: Integer;
  sdir, s2, se, s3: String;
  df: Integer;
  sr: TSearchRec;
  b: LongBool;
begin
  Result := TFormulaNames.Create;
  try
    for I := 0 to 6 do
      AddFormulaName(Result, InternFormulaNames[i], InternFormulasDEfunc[i]);
    AddFormulaName(Result, 'Aexion C', 0);
    s2 := '';
    sdir := IncludeTrailingPathDelimiter(IniDirs[3]);
    if FindFirst(sdir + '*.m3f', 0, sr) = 0 then
    repeat
      se := ChangeFileExt(sr.Name, '');
      s3 := UpperCase(se);
      b := (s3 <> 'TRAFASSELQUAT') or not CanLoadF('CommQuat');
      b := b and ((s3 <> '_FLIPXY') or not CanLoadF('_FlipXYc'));
      b := b and ((s3 <> '_FLIPXZ') or not CanLoadF('_FlipXZc'));
      b := b and ((s3 <> '_FLIPYZ') or not CanLoadF('_FlipYZc'));
      b := b and ((s3 <> 'ABOXMODKALIFIXED') or not CanLoadF('ABoxModKali'));
      b := b and (s3 <> 'SQKOCH') and (s3 <> 'DJD-QUAT') and (s3 <> '_IFS-TESS');
      if b and CanLoadCustomFormula(sdir + sr.Name, df) and
        (not Result.FNameIsIncluded(se)) then AddFormulaName(Result, se, df);
    until FindNext(sr) <> 0;
    FindClose(sr);
    s2 := sdir;
  except
    Result.Free;
    raise;
  end;
end;

end.


