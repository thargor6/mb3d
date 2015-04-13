////////////////////////////////////////////////////////////////////////////////
//
// Adler32.pas - Adler32 data integrity check
// ------------------------------------------
// Version:   2003-05-15
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Last changes:
//
unit Adler32;

interface

resourcestring
  rsAdler32Error = 'Adler32 error';

type
  TAdler32 = object
    public
      procedure Init;
      procedure Calc(var Data; Length: Cardinal);
      procedure Update(Data: Byte);
      function CheckValue: Cardinal;
    private
      s1, s2 : Cardinal;
    end;

implementation

uses SysUtils, MemUtils;

procedure TAdler32.Init;
begin
  s1:=1;
  s2:=0;
end;

procedure TAdler32.Calc(var Data; Length: Cardinal);
var
  I : Integer;
begin
  for I:=0 to Length-1 do
  begin
    Inc(s1,TByteArray(Data)[I]);
    if s1>=65521 then Dec(s1,65521);
    Inc(s2,s1);
    if s2>=65521 then Dec(s2,65521);
  end;
end;

procedure TAdler32.Update(Data: Byte);
begin
  Inc(s1,Data);
  if s1>=65521 then Dec(s1,65521);
  Inc(s2,s1);
  if s2>=65521 then Dec(s2,65521);
end;

function TAdler32.CheckValue: Cardinal;
begin
  Result:=GetSwap4(Cardinal(s2) shl 16 or s1);
end;

end.
