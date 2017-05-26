{ ---------------------------------------------------------------------------- }
{ FormulaJIT for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit JITFormulas;

interface

uses
  SysUtils, Classes;

type

  TJITValueDatatype = (dtInteger,  dtInt64, dtSingle, dtDouble, dtString);

  TNameValuePair = class;

  TJITFormulaValueType = (vtOption, vtParam, vtConst);

  TJITFormula = class
  private
    FFormulaname: String;
    FCode: String;
    FDescription: String;
    FValues: TList;
    FCanSave: Boolean;
    function GetValueList(const ValueType: TJITFormulaValueType): TStringList;
  public
    constructor Create;
    destructor Destroy;override;
    procedure SetValue(const ValueType: TJITFormulaValueType; const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
    procedure RemoveValue(const ValueType: TJITFormulaValueType; const Name: String);overload;
    procedure RemoveValue(const ValueType: TJITFormulaValueType; const Idx: Integer);overload;
    function GetValue(const ValueType: TJITFormulaValueType; const Idx: Integer): TNameValuePair;overload;
    function GetValue(const ValueType: TJITFormulaValueType; const Name: String): TNameValuePair;overload;
    function GetValueCount(const ValueType: TJITFormulaValueType): Integer;
    procedure ClearValues(const ValueType: TJITFormulaValueType);
    function NextValueName(const ValueType: TJITFormulaValueType): String;
    property Formulaname: String read FFormulaname write FFormulaname;
    property Code: String read FCode write FCode;
    property Description: String read FDescription write FDescription;
    property CanSave: Boolean read FCanSave write FCanSave;
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

  TJITFormulaWriter = class
    class procedure SaveFormula(const Formula: TJITFormula; const Filename: String);
  end;

function StrToJITValueDatatype(const TypeStr: String): TJITValueDatatype;
function JITValueDatatypeToStr(const Datatype: TJITValueDatatype): String;
function JITValueDatatypeSize(const Datatype: TJITValueDatatype): Integer;

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

function JITValueDatatypeSize(const Datatype: TJITValueDatatype): Integer;
begin
  case Datatype of
    dtInt64: Result := SizeOf(Int64);
    dtInteger: Result := SizeOf(Integer);
    dtDouble: Result := Sizeof(Double);
    dtSingle: Result := Sizeof(Single);
  else
    raise Exception.Create('JITValueDatatypeSize: Unknown datatype <'+IntToStr(Ord(Datatype))+'>');
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
{ ------------------------------- TJITFormula -------------------------------- }
constructor TJITFormula.Create;
var
  Options, Params, Constants: TStringList;
begin
  inherited Create;
  FCanSave := True;
  FValues := TObjectList.Create;

  Options := TStringList.Create;
  Options.Duplicates := dupError;
  Options.Sorted := True;
  FValues.Add(Options);

  Params := TStringList.Create;
  Params.Duplicates := dupError;
  Params.Sorted := True;
  FValues.Add(Params);

  Constants := TStringList.Create;
  Constants.Duplicates := dupError;
  Constants.Sorted := True;
  FValues.Add(Constants);
end;

function TJITFormula.NextValueName(const ValueType: TJITFormulaValueType): String;
var
  Prefix: String;
  Counter: Integer;
  ValueList: TStringList;
begin
  case ValueType of
    vtOption: Prefix := 'Option';
    vtParam: Prefix := 'Param';
    vtConst: Prefix := 'Const';
  end;
  ValueList := GetValueList(ValueType);
  Counter := 0;
  while(True) do begin
    Result := Prefix + IntToStr(Counter);
    if ValueList.IndexOf(Result) < 0 then
      break;
    Inc(Counter);
  end;
end;

function TJITFormula.GetValueList(const ValueType: TJITFormulaValueType): TStringList;
begin
  Result := TStringList(FValues.Items[Ord(ValueType)]);
end;

destructor TJITFormula.Destroy;
var
  I: TJITFormulaValueType;
begin
  for I := Low(TJITFormulaValueType) to High(TJITFormulaValueType) do
    ClearValues(I);
  FValues.Free;
  inherited Destroy;
end;

procedure TJITFormula.SetValue(const ValueType: TJITFormulaValueType; const Name: String; const Datatype: TJITValueDatatype; const Value: Variant);
var
  Idx: Integer;
  Pair: TNameValuePair;
  ValueList: TStringList;
begin
  ValueList := GetValueList(ValueType);
  Idx := ValueList.IndexOf(Name);
  if Idx >= 0 then begin
    Pair := GetValue(ValueType, Idx);
    Pair.Datatype := Datatype;
    Pair.Value := Value;
  end
  else begin
    Pair := TNameValuePair.Create(Name, Datatype, Value);
    ValueList.AddObject(Name, Pair);
  end;
end;

function TJITFormula.GetValueCount(const ValueType: TJITFormulaValueType): Integer;
begin
  Result := GetValueList(ValueType).Count;
end;

procedure TJITFormula.RemoveValue(const ValueType: TJITFormulaValueType; const Name: String);
var
  Idx: Integer;
  ValueList: TStringList;
begin
  ValueList := GetValueList(ValueType);
  Idx := ValueList.IndexOf(Name);
  if Idx >= 0 then begin
    ValueList.Objects[Idx].Free;
    ValueList.Delete(Idx);
  end;
end;

procedure TJITFormula.RemoveValue(const ValueType: TJITFormulaValueType; const Idx: Integer);
var
  ValueList: TStringList;
begin
  ValueList := GetValueList(ValueType);
  ValueList.Objects[Idx].Free;
  ValueList.Delete(Idx);
end;

function TJITFormula.GetValue(const ValueType: TJITFormulaValueType; const Idx: Integer): TNameValuePair;
begin
  Result := GetValueList(ValueType).Objects[Idx] as TNameValuePair;
end;

function TJITFormula.GetValue(const ValueType: TJITFormulaValueType; const Name: String): TNameValuePair;
var
  Idx: Integer;
  ValueList: TStringList;
begin
  ValueList := GetValueList(ValueType);
  Idx := ValueList.IndexOf(Name);
  if Idx >= 0 then
    Result := ValueList.Objects[Idx] as TNameValuePair
  else
    Result := nil;
end;

procedure TJITFormula.ClearValues(const ValueType: TJITFormulaValueType);
var
  I: Integer;
  ValueList: TStringList;
begin
  ValueList := GetValueList(ValueType);
  for I := 0 to ValueList.Count -1 do
    ValueList.Objects[I].Free;
  ValueList.Clear;
end;
{ ---------------------------- TJITFormulaWriter ----------------------------- }
class procedure TJITFormulaWriter.SaveFormula(const Formula: TJITFormula; const Filename: String);
var
  I: Integer;
  Writer: TStringList;
  ValueStr: String;
  Pair: TNameValuePair;
begin
  Writer := TStringList.Create;
  try
    if (Formula.GetValueCount(vtOption) > 0) or (Formula.GetValueCount(vtParam) > 0) then begin
      Writer.Add('[OPTIONS]');

      for I := 0 to Formula.GetValueCount(vtOption) - 1 do begin
        Pair := Formula.GetValue(vtOption, I);
        ValueStr := Trim(Pair.ValueToString);
        if ValueStr <> '' then
          Writer.Add('.'+Pair.Name+' = '+ValueStr)
        else
          Writer.Add('.'+Pair.Name);
      end;

      for I := 0 to Formula.GetValueCount(vtParam) - 1 do begin
        Pair := Formula.GetValue(vtParam, I);
        Writer.Add('.'+JITValueDatatypeToStr(Pair.Datatype) + ' ' + Pair.Name+' = '+Pair.ValueToString);
      end;
    end;

    if Formula.GetValueCount(vtConst) > 0 then begin
      Writer.Add('[CONSTANTS]');
      for I := 0 to Formula.GetValueCount(vtConst) - 1  do begin
        Pair := Formula.GetValue(vtConst, I);
        Writer.Add('.'+JITValueDatatypeToStr(Pair.Datatype) + ' ' + Pair.Name+' = '+Pair.ValueToString);
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

