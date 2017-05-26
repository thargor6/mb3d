{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit VectorMath;

interface

uses
  SysUtils, Classes, Contnrs;

type
  TD3Vector = packed record
    X, Y, Z: Double;
  end;
  TPD3Vector = ^TD3Vector;

  TDVectorMath = class
  public
    class procedure Clear(const V: TPD3Vector);
    class procedure Normalize(const V: TPD3Vector);
    class function Length(const V: TPD3Vector): Double;
    class procedure Flip(const V: TPD3Vector);
    class procedure NormalizeAndScalarMul(const V: TPD3Vector; const Factor: Double);
    class procedure Add(const A, B, Dest: TPD3Vector);
    class procedure Subtract(const A, B, Dest: TPD3Vector);
    class procedure AddTo(const Dest, Other: TPD3Vector);
    class procedure ScalarMul(const A: Double; const B: TPD3Vector; const Product: TPD3Vector);
    class procedure Assign(const Dest, Src: TPD3Vector);
    class function DotProduct(const A, B: TPD3Vector): Double;
    class procedure CrossProduct(const A, B, Product: TPD3Vector);
    class procedure NonParallel(const Dest, V: TPD3Vector);
    class function IsNull(const V: TPD3Vector): Boolean;
    class procedure SetValue(const V: TPD3Vector; const X, Y, Z: Double);
  end;

  TS3Vector = packed record
    X, Y, Z: Single;
  end;
  TPS3Vector = ^TS3Vector;

  TS4Vector = packed record
    X, Y, Z, W: Single;
  end;
  TPS4Vector = ^TS4Vector;

  TSVectorMath = class
  public
    class procedure Subtract(const A, B, Dest: TPS3Vector);
    class procedure Normalize(const V: TPS3Vector);
    class function Length(const V: TPS3Vector): Double;
    class procedure AddTo(const Dest, Other: TPS3Vector);
    class procedure CrossProduct(const A, B, Product: TPS3Vector);
    class function DotProduct(const A, B: TPS3Vector): Double;
    class procedure ScalarMul(const A: Double; const B: TPS3Vector; const Product: TPS3Vector);
    class procedure SetValue(const V: TPS3Vector; const X, Y, Z: Single);
    class procedure Clear(const V: TPS3Vector);
  end;

  TD3Matrix = packed record
    M: Array [0..2, 0..2] of Double;
  end;
  TPD3Matrix = ^TD3Matrix;

  TDMatrixMath = class
  public
    class procedure Identity(const M: TPD3Matrix);
    class procedure Multiply(const A, B, Product: TPD3Matrix);overload;
    class procedure ScalarMul(const A: Double; const B, Product: TPD3Matrix);
    class procedure Add(const A, B, Sum: TPD3Matrix);overload;

    class procedure VMultiply(const A: TPD3Vector; const B: TPD3Matrix; const Product: TPD3Vector);overload;
  end;

implementation

{ ----------------------------- TDVectorMath --------------------------------- }
const
  EPS = 1e-100;

class procedure TDVectorMath.Clear(const V: TPD3Vector);
begin
  with V^ do begin
    X := 0.0;
    Y := 0.0;
    Z := 0.0;
  end;
end;

class function TDVectorMath.Length(const V: TPD3Vector): Double;
begin
  with V^ do begin
    Result := Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z));
  end;
end;

class procedure TDVectorMath.Normalize(const V: TPD3Vector);
var
  L: Double;
begin
  with V^ do begin
    L := 1.0 / Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z) + EPS);
    X := X * L;
    Y := Y * L;
    Z := Z * L;
  end;
end;

class function TDVectorMath.IsNull(const V: TPD3Vector): Boolean;
begin
  with V^ do begin
    Result := (Abs(X) <= EPS) and (Abs(Y) <= EPS) and (Abs(Z) <= EPS);
  end;
end;

class procedure TDVectorMath.SetValue(const V: TPD3Vector; const X, Y, Z: Double);
begin
  V^.X := X;
  V^.Y := Y;
  V^.Z := Z;
end;

class procedure TDVectorMath.Flip(const V: TPD3Vector);
begin
  with V^ do begin
    X := 0.0 - X;
    Y := 0.0 - Y;
    Z := 0.0 - Z;
  end;
end;

class procedure TDVectorMath.NormalizeAndScalarMul(const V: TPD3Vector; const Factor: Double);
var
  S: Double;
begin
  with V^ do begin
    S := Factor / Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z) + 1e-100);
    X := X * S;
    X := Y * S;
    Z := Z * S;
  end;
end;

class procedure TDVectorMath.ScalarMul(const A: Double; const B: TPD3Vector; const Product: TPD3Vector);
begin
  with Product^ do begin
    X := A * B^.X;
    Y := A * B^.Y;
    Z := A * B^.Z;;
  end;
end;

class procedure TDVectorMath.Assign(const Dest, Src: TPD3Vector);
begin
  with Dest^ do begin
    X := Src^.X;
    Y := Src^.Y;
    Z := Src^.Z;
  end;
end;

class procedure TDVectorMath.NonParallel(const Dest, V: TPD3Vector);
var
  C: TD3Vector;
begin
  if IsNull(V) then begin
    Dest^.X := 0.0;
    Dest^.Y := 0.0;
    Dest^.Z := 1.0;
    exit;
  end;
  while True do begin
    Dest^.X := 0.5 - Random;
    Dest^.Y := 0.5 - Random;
    Dest^.Z := 0.5 - Random;
    CrossProduct(Dest, V, @C);
    if not IsNull(@C) then
      break;
  end;
end;

class procedure TDVectorMath.Add(const A, B, Dest: TPD3Vector);
begin
  with Dest^ do begin
    X := A^.X + B^.X;
    Y := A^.Y + B^.Y;
    Z := A^.Z + B^.Z;
  end;
end;

class procedure TDVectorMath.Subtract(const A, B, Dest: TPD3Vector);
begin
  with Dest^ do begin
    X := A^.X - B^.X;
    Y := A^.Y - B^.Y;
    Z := A^.Z - B^.Z;
  end;
end;

class procedure TDVectorMath.AddTo(const Dest, Other: TPD3Vector);
begin
  with Dest^ do begin
    X := X + Other^.X;
    Y := Y + Other^.Y;
    Z := Z + Other^.Z;
  end;
end;

class function TDVectorMath.DotProduct(const A, B: TPD3Vector): Double;
begin
  Result := A^.X * B^.X + A^.Y * B^.Y + A^.Z * B^.Z;
end;

class procedure TDVectorMath.CrossProduct(const A, B, Product: TPD3Vector);
begin
  with Product^ do begin
    X := A^.Y * B^.Z - A^.Z * B^.Y;
    Y := A^.Z * B^.X - A^.X * B^.Z;
    Z := A^.X * B^.Y - A^.Y * B^.X;
  end;
end;
{ ----------------------------- TSVectorMath --------------------------------- }
class procedure TSVectorMath.Clear(const V: TPS3Vector);
begin
  with V^ do begin
    X := 0.0;
    Y := 0.0;
    Z := 0.0;
  end;
end;

class procedure TSVectorMath.Normalize(const V: TPS3Vector);
var
  L: Double;
begin
  with V^ do begin
    L := 1.0 / Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z) + EPS);
    X := X * L;
    Y := Y * L;
    Z := Z * L;
  end;
end;

class function TSVectorMath.Length(const V: TPS3Vector): Double;
begin
  with V^ do begin
    Result := Sqrt(Sqr(X) + Sqr(Y) + Sqr(Z));
  end;
end;

class procedure TSVectorMath.SetValue(const V: TPS3Vector; const X, Y, Z: Single);
begin
  V^.X := X;
  V^.Y := Y;
  V^.Z := Z;
end;

class procedure TSVectorMath.ScalarMul(const A: Double; const B: TPS3Vector; const Product: TPS3Vector);
begin
  with Product^ do begin
    X := A * B^.X;
    Y := A * B^.Y;
    Z := A * B^.Z;;
  end;
end;

class procedure TSVectorMath.Subtract(const A, B, Dest: TPS3Vector);
begin
  with Dest^ do begin
    X := A^.X - B^.X;
    Y := A^.Y - B^.Y;
    Z := A^.Z - B^.Z;
  end;
end;

class function TSVectorMath.DotProduct(const A, B: TPS3Vector): Double;
begin
  Result := A^.X * B^.X + A^.Y * B^.Y + A^.Z * B^.Z;
end;

class procedure TSVectorMath.CrossProduct(const A, B, Product: TPS3Vector);
begin
  with Product^ do begin
    X := A^.Y * B^.Z - A^.Z * B^.Y;
    Y := A^.Z * B^.X - A^.X * B^.Z;
    Z := A^.X * B^.Y - A^.Y * B^.X;
  end;
end;

class procedure TSVectorMath.AddTo(const Dest, Other: TPS3Vector);
begin
  with Dest^ do begin
    X := X + Other^.X;
    Y := Y + Other^.Y;
    Z := Z + Other^.Z;
  end;
end;
{ ----------------------------- TDMatrixMath --------------------------------- }
class procedure TDMatrixMath.ScalarMul(const A: Double; const B, Product: TPD3Matrix);
var
  I, J: Integer;
begin
  with Product^ do begin
    for I := 0 to 2 do begin
      for J:=0 to 2 do begin
        M[I, J] := A * B^.M[I, J];
      end;
    end;
  end;
end;

class procedure TDMatrixMath.Identity(const M: TPD3Matrix);
begin
  with M^ do begin
    M[0, 0] := 1.0;
    M[0, 1] := 0.0;
    M[0, 2] := 0.0;
    M[1, 0] := 0.0;
    M[1, 1] := 1.0;
    M[1, 2] := 0.0;
    M[2, 0] := 0.0;
    M[2, 1] := 0.0;
    M[2, 2] := 1.0;
  end;
end;

class procedure TDMatrixMath.Add(const A, B, Sum: TPD3Matrix);
var
  I, J: Integer;
begin
  with Sum^ do begin
    for I := 0 to 2 do begin
      for J := 0 to 2 do begin
        M[I, J] := A^.M[I, J] + B^.M[I, J];
      end;
    end;
  end;
end;

class procedure TDMatrixMath.Multiply(const A, B, Product: TPD3Matrix);
var
  I, J, S: Integer;
begin
  with Product^ do begin
    for I := 0 to 2 do begin
      for J := 0 to 2 do begin
        M[I, J] := 0.0;
        for S := 0 to 2 do begin
          M[I, J] := M[I, J] + A^.M[I, S] * B^.M[S, J];
        end;
      end;
    end;
  end;
end;

class procedure TDMatrixMath.VMultiply(const A: TPD3Vector; const B: TPD3Matrix; const Product: TPD3Vector);
begin
  with Product^ do begin
    X := A^.X * B^.M[0, 0] + A^.Y * B^.M[0, 1] + A^.Z * B^.M[0, 2];
    Y := A^.X * B^.M[1, 0] + A^.Y * B^.M[1, 1] + A^.Z * B^.M[1, 2];
    Z := A^.X * B^.M[2, 0] + A^.Y * B^.M[2, 1] + A^.Z * B^.M[2, 2];
  end;
end;

end.
