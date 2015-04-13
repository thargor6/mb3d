unit Undo;

interface

uses TypeDefinitions;

procedure Redo;
procedure StoreUndo;
procedure RestoreUndo;
procedure RedoLight;
procedure StoreUndoLight;
procedure RestoreUndoLight;

var
  UndoHeader: array[0..31] of TMandHeader11;
  UndoAuthors: array[0..31] of AuthorStrings;
  UndoTitels: array[0..31] of String;
  UndoHAddon: array[0..31] of THeaderCustomAddon;
  UndoIndex: Integer = -1;
  UndoCount: Integer = 0;
  RedoCount: Integer = 0;
  UndoLights: array[0..63] of TLightingParas9;
  UndoLightIndex: Integer = -1;
  UndoLightCount: Integer = 0;
  RedoLightCount: Integer = 0;

implementation

uses Mand, Math, Interpolation, SysUtils, LightAdjust, Math3D, FileHandling;

procedure StoreUndo;
begin
    if (UndoCount > 0) and HeaderIdentic(UndoHeader[UndoIndex], Mand3DForm.MHeader) and
      CompareMem(@UndoHeader[UndoIndex].Light, @Mand3DForm.MHeader.Light, SizeOf(TLightingParas9)) and
      CompareMem(@UndoHAddon[UndoIndex], @Mand3DForm.HAddOn, SizeOf(THeaderCustomAddon)) then Exit;
    UndoIndex := (UndoIndex + 1) mod 32;
    UndoCount := Min(32, UndoCount + 1);
    UndoHeader[UndoIndex] := Mand3DForm.MHeader;
    UndoHAddon[UndoIndex] := Mand3DForm.HAddOn;
    UndoAuthors[UndoIndex] := Mand3DForm.Authors;
    UndoTitels[UndoIndex] := Mand3DForm.Caption;
    RedoCount := Max(0, RedoCount - 1);
    Mand3DForm.SpeedButton9.Enabled := (UndoCount > 1) or (RedoCount > 1);
end;

procedure SetM3DUndo;
begin
    Mand3DForm.MHeader := UndoHeader[UndoIndex];
    Mand3DForm.HAddOn := UndoHAddon[UndoIndex];
    Mand3DForm.Authors := UndoAuthors[UndoIndex];
    Mand3DForm.Caption := UndoTitels[UndoIndex];
    if Copy(Mand3DForm.Caption, 1, 13) <> 'Mandelbulb 3D' then
      SetSaveDialogNames(Mand3DForm.Caption);
end;

procedure RestoreUndo;
begin
    if UndoCount > 1 then
    begin
      UndoIndex := (UndoIndex + 31) mod 32;
      SetM3DUndo;
      Dec(UndoCount);
      RedoCount := Min(31, RedoCount + 1);
    end;
end;

procedure Redo;
begin
    if RedoCount > 0 then
    begin
      UndoIndex := (UndoIndex + 1) mod 32;
      SetM3DUndo;
      Inc(UndoCount);
      Dec(RedoCount);
    end;
end;

procedure StoreUndoLight;
begin
    if (UndoLightCount > 0) and CompareMem(@UndoLights[UndoLightIndex],
      @Mand3DForm.MHeader.Light, SizeOf(TLightingParas9)) then Exit;
    UndoLightIndex := (UndoLightIndex + 1) mod 64;
    UndoLightCount := Min(64, UndoLightCount + 1);
    UndoLights[UndoLightIndex] := Mand3DForm.MHeader.Light;
    RedoLightCount := Max(0, RedoLightCount - 1);
    LightAdjustForm.SpeedButton9.Enabled := (UndoLightCount > 1) or (RedoLightCount > 1);
end;

procedure RestoreUndoLight;
begin
    if UndoLightCount > 1 then
    begin
      UndoLightIndex := (UndoLightIndex + 63) mod 64;
      Mand3DForm.MHeader.Light := UndoLights[UndoLightIndex];
      Dec(UndoLightCount);
      RedoLightCount := Min(63, RedoLightCount + 1);
    end;
end;

procedure RedoLight;
begin
    if RedoLightCount > 0 then
    begin
      UndoLightIndex := (UndoLightIndex + 1) mod 64;
      Mand3DForm.MHeader.Light := UndoLights[UndoLightIndex];
      Inc(UndoLightCount);
      Dec(RedoLightCount);
    end;
end;

end.
