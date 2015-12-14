unit JITFormulas;

interface

uses
  SysUtils, Classes;

type

  TJITFormulaOption = class;
  TJITFormulaConstValue = class;
  TJITFormulaParamValue = class;

  TJITValueDatatype = (dtInteger,  dtInt64, dtSingle, dtDouble, dtString);

  TJITFormula = class
  private
    FFormulaname: String;
    FCode: String;
    FDescription: String;
    FOptions: TStringList;
    FConstValues: TList;
    FParamValues: TStringList;
    procedure ClearOptions;
    function GetOptionCount: Integer;
    procedure ClearConstValues;
    function GetConstValueCount: Integer;
    procedure ClearParamValues;
    function GetParamValueCount: Integer;
  public
    constructor Create;
    destructor Destroy;override;
    procedure SetOption(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
    procedure RemoveOption(const Name: String);overload;
    procedure RemoveOption(const Idx: Integer);overload;
    function GetOption(const Idx: Integer): TJITFormulaOption;overload;
    function GetOption(const Name: String): TJITFormulaOption;overload;
    procedure AddConstValue(const Datatype: TJITValueDatatype; const Value: Variant);
    procedure RemoveConstValue(const Idx: Integer);
    function GetConstValue(const Idx: Integer): TJITFormulaConstValue;
    procedure SetParamValue(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
    procedure RemoveParamValue(const Name: String);overload;
    procedure RemoveParamValue(const Idx: Integer);overload;
    function GetParamValue(const Idx: Integer): TJITFormulaParamValue;overload;
    function GetParamValue(const Name: String): TJITFormulaParamValue;overload;
    property Formulaname: String read FFormulaname write FFormulaname;
    property Code: String read FCode write FCode;
    property Description: String read FDescription write FDescription;
    property OptionCount: Integer read GetOptionCount;
    property ConstValueCount: Integer read GetConstValueCount;
    property ParamValueCount: Integer read GetParamValueCount;
  end;

  TNameValuePair = class
  private
    FName: String;
    FValue: Variant;
    FDatatype: TJITValueDatatype;
  public
    constructor Create;overload;
    constructor Create(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);overload;
    function ValueToString: String;
    property Name: String read FName write FName;
    property Value: Variant read FValue write FValue;
    property Datatype: TJITValueDatatype read FDatatype write FDatatype;
  end;

  TJITFormulaOption = class(TNameValuePair);
  TJITFormulaParamValue = class(TNameValuePair);

  TJITFormulaConstValue = class
  private
    FValue: Variant;
    FDatatype: TJITValueDatatype;
  public
    constructor Create;overload;
    constructor Create(const Datatype: TJITValueDatatype; const Value: Variant);overload;
    function ValueToString: String;
    property Value: Variant read FValue write FValue;
    property Datatype: TJITValueDatatype read FDatatype write FDatatype;
  end;

  TJITFormulaWriter = class
    class procedure SaveFormula(const Formula: TJITFormula; const Filename: String);
  end;

function StrToJITValueDatatype(const TypeStr: String): TJITValueDatatype;
function JITValueDatatypeToStr(const Datatype: TJITValueDatatype): String;

implementation

uses
  Contnrs, Variants;

function StrToJITValueDatatype(const TypeStr: String): TJITValueDatatype;
var
  UCTypeStr: String;
begin
  UCTypeStr := AnsiUpperCase(TypeStr);
  if UCTypeStr = 'INT64' then
    Result := dtInt64
  else if UCTypeStr = 'INTEGER' then
    Result := dtInteger
  else if UCTypeStr = 'DOUBLE' then
    Result := dtDouble
  else if UCTypeStr = 'SINGLE' then
    Result := dtSingle
  else if UCTypeStr = 'STRING' then
    Result := dtString
  else
    raise Exception.Create('StrToJITValueDatatype: Unknown datatype <'+TypeStr+'>');
end;

function JITValueDatatypeToStr(const Datatype: TJITValueDatatype): String;
begin
  case Datatype of
    dtInt64: Result := 'Int64';
    dtInteger: Result := 'Integer';
    dtDouble: Result := 'Double';
    dtSingle: Result := 'Single';
    dtString: Result := 'String';
  else
    raise Exception.Create('JITValueDatatypeStr: Unknown datatype <'+IntToStr(Ord(Datatype))+'>');
  end
end;
{ ---------------------------- TNameValuePair -------------------------------- }
function VariantToString(Value: Variant): String;
begin
  case VarType(Value) of
    varInteger, varSmallint, varSingle, varShortInt, varByte, varWord, varLongWord, varInt64, varUInt64:
      Result := IntToStr(Value);
    varDouble, varCurrency :
      Result := FloatToStr(Value);
    varString, varUString:
      Result := Value;
  else
    raise Exception.Create('Unsupported variant type <'+IntToStr(VarType(Value))+'>');
  end;
end;

constructor TNameValuePair.Create;
begin
  inherited Create;
end;

constructor TNameValuePair.Create(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
begin
  inherited Create;
  Self.Name := Name;
  Self.Datatype := Datatype;
  Self.Value := Value;
end;

function TNameValuePair.ValueToString: String;
begin
  Result := VariantToString(Value);
end;
{ -------------------------- TJITFormulaConstValue --------------------------- }
constructor TJITFormulaConstValue.Create;
begin
  inherited Create;
end;

constructor TJITFormulaConstValue.Create(const Datatype: TJITValueDatatype; const Value: Variant);
begin
  inherited Create;
  Self.Value := Value;
  Self.Datatype := Datatype;
end;

function TJITFormulaConstValue.ValueToString: String;
begin
  Result := VariantToString(Value);
end;
{ ------------------------------- TJITFormula -------------------------------- }
constructor TJITFormula.Create;
begin
  inherited Create;
  FOptions := TStringList.Create;
  FOptions.Duplicates := dupError;
  FOptions.Sorted := True;

  FConstValues := TObjectList.Create;

  FParamValues := TStringList.Create;
  FParamValues.Duplicates := dupError;
  FParamValues.Sorted := True;
end;

destructor TJITFormula.Destroy;
begin
  ClearOptions;
  FOptions.Free;
  ClearConstValues;
  FConstValues.Free;
  ClearParamValues;
  FParamValues.Free;
  inherited Destroy;
end;

procedure TJITFormula.ClearOptions;
var
  I: Integer;
begin
  for I := 0 to FOptions.Count -1 do
    FOptions.Objects[I].Free;
  FOptions.Clear;
end;

procedure TJITFormula.SetOption(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
var
  Idx: Integer;
  Option: TJITFormulaOption;
begin
  Idx := FOptions.IndexOf(Name);
  if Idx >= 0 then begin
    Option := GetOption(Idx);
    Option.Datatype := Datatype;
    Option.Value := Value;
  end
  else begin
    Option := TJITFormulaOption.Create(Name, Datatype, Value);
    FOptions.AddObject(Name, Option);
  end;
end;

function TJITFormula.GetOptionCount: Integer;
begin
  Result := FOptions.Count;
end;

procedure TJITFormula.RemoveOption(const Name: String);
var
  Idx: Integer;
begin
  Idx := FOptions.IndexOf(Name);
  if Idx >= 0 then begin
    FOptions.Objects[Idx].Free;
    FOptions.Delete(Idx);
  end;
end;

procedure TJITFormula.RemoveOption(const Idx: Integer);
begin
  FOptions.Objects[Idx].Free;
  FOptions.Delete(Idx);
end;

function TJITFormula.GetOption(const Idx: Integer): TJITFormulaOption;
begin
  Result := FOptions.Objects[Idx] as TJITFormulaOption;
end;

function TJITFormula.GetOption(const Name: String): TJITFormulaOption;
var
  Idx: Integer;
begin
  Idx := FOptions.IndexOf(Name);
  if Idx >= 0 then
    Result := FOptions.Objects[Idx] as TJITFormulaOption
  else
    Result := nil;
end;

procedure TJITFormula.ClearConstValues;
begin
  FConstValues.Clear;
end;

function TJITFormula.GetConstValueCount: Integer;
begin
  Result := FConstValues.Count;
end;

procedure TJITFormula.AddConstValue(const Datatype: TJITValueDatatype; const Value: Variant);
begin
  FConstValues.Add( TJITFormulaConstValue.Create( Datatype, Value) );
end;

procedure TJITFormula.RemoveConstValue(const Idx: Integer);
begin
  FConstValues.Delete(Idx);
end;

function TJITFormula.GetConstValue(const Idx: Integer): TJITFormulaConstValue;
begin
  Result := TJITFormulaConstValue(FConstValues[Idx]);
end;

procedure TJITFormula.ClearParamValues;
var
  I: Integer;
begin
  for I := 0 to FParamValues.Count -1 do
    FParamValues.Objects[I].Free;
  FParamValues.Clear;
end;

function TJITFormula.GetParamValueCount: Integer;
begin
  Result := FParamValues.Count;
end;

procedure TJITFormula.SetParamValue(const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
var
  Idx: Integer;
  ParamValue: TJITFormulaParamValue;
begin
  Idx := FParamValues.IndexOf(Name);
  if Idx >= 0 then begin
    ParamValue := GetParamValue(Idx);
    ParamValue.Datatype := Datatype;
    ParamValue.Value := Value;
  end
  else begin
    ParamValue := TJITFormulaParamValue.Create(Name, Datatype, Value);
    FParamValues.AddObject(Name, ParamValue);
  end;
end;

procedure TJITFormula.RemoveParamValue(const Name: String);
var
  Idx: Integer;
begin
  Idx := FParamValues.IndexOf(Name);
  if Idx >= 0 then begin
    FParamValues.Objects[Idx].Free;
    FParamValues.Delete(Idx);
  end;
end;

procedure TJITFormula.RemoveParamValue(const Idx: Integer);
begin
  FParamValues.Objects[Idx].Free;
  FParamValues.Delete(Idx);
end;

function TJITFormula.GetParamValue(const Idx: Integer): TJITFormulaParamValue;
begin
  Result := FParamValues.Objects[Idx] as TJITFormulaParamValue;
end;

function TJITFormula.GetParamValue(const Name: String): TJITFormulaParamValue;
var
  Idx: Integer;
begin
  Idx := FParamValues.IndexOf(Name);
  if Idx >= 0 then
    Result := FParamValues.Objects[Idx] as TJITFormulaParamValue
  else
    Result := nil;
end;
{ ---------------------------- TJITFormulaWriter ----------------------------- }
class procedure TJITFormulaWriter.SaveFormula(const Formula: TJITFormula; const Filename: String);
var
  I: Integer;
  Writer: TStringList;
  ValueStr: String;
  Option: TJITFormulaOption;
  ParamValue: TJITFormulaParamValue;
  ConstValue: TJITFormulaConstValue;
begin
  Writer := TStringList.Create;
  try
    if (Formula.OptionCount > 0) or (Formula.ParamValueCount > 0) then begin
      Writer.Add('[OPTIONS]');

      for I := 0 to Formula.OptionCount - 1 do begin
        Option := Formula.GetOption(I);
        ValueStr := Trim(Option.ValueToString);
        if ValueStr <> '' then
          Writer.Add('.'+Option.Name+' = '+ValueStr)
        else
          Writer.Add('.'+Option.Name);
      end;

      for I := 0 to Formula.ParamValueCount - 1 do begin
        ParamValue := Formula.GetParamValue(I);
        Writer.Add('.'+JITValueDatatypeToStr(ParamValue.Datatype) + ' ' + ParamValue.Name+' = '+ParamValue.ValueToString);
      end;
    end;

    if Formula.ConstValueCount > 0 then begin
      Writer.Add('[CONSTANTS]');
      for I := 0 to Formula.ConstValueCount - 1  do begin
        ConstValue := Formula.GetConstValue(I);
        Writer.Add(JITValueDatatypeToStr(ConstValue.Datatype) + ' = ' + ConstValue.ValueToString );
      end;
    end;

    Writer.Add('[SOURCE]');
    Writer.Add( Copy(Formula.Code, 1, Length(Formula.Code) -2 ));
    Writer.Add('[END]');
    Writer.Add( Copy(Formula.Description, 1, Length(Formula.Description) - 2 ));
    Writer.SaveToFile( Filename );
  finally
    Writer.Free;
  end;
end;

end.

