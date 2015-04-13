unit DoubleSize;

interface

function DoubleImageSize: Boolean;

implementation

uses TypeDefinitions, Mand, HeaderTrafos, DivUtils;

function DoubleImageSize: Boolean;
var w, h, x, y, i: Integer;
    siLight5tmp: array of TsiLight5;
    PL1, PL2, PL3, PL4, PL5, PL6, PL7: TPsiLight5;
    B: Cardinal;
    MCTp: TMCTparameter;
begin
  with Mand3DForm do
  begin
    w := MHeader.Width;
    h := MHeader.Height;
    try
      MCTp := GetMCTparasFromHeader(MHeader, True);
      if not MCTp.bMCTisValid then Exit;
      SetLength(siLight5tmp, w * h);
      FastMove(siLight5[0], siLight5tmp[0], w * h * SizeOf(TsiLight5));
      SetLength(siLight5, w * h * 4);
      for y := 0 to h - 1 do
        for x := 0 to w - 1 do
          siLight5[(y * w * 2 + x) * 2] := siLight5tmp[y * w + x];
      SetLength(siLight5tmp, 0);
      MHeader.Width := w * 2;
      MHeader.Height := h * 2;
      MHeader.sDEstop := MHeader.sDEstop * 2;
      //interpolate, first mids, borders right + bottom seperate

      
      for y := 0 to h - 1 do
      begin
        PL1 := @siLight5[y * w * 4];
        PL2 := @siLight5[y * w * 4 + 2];
        if y = h - 1 then
        begin
          PL3 := PL1;
          PL4 := PL2;
        end else begin
          PL3 := @siLight5[(y + 1) * w * 4];
          PL4 := @siLight5[(y + 1) * w * 4 + 2];
        end;
        PL5 := @siLight5[y * w * 4 + w * 2 + 1];
        PL6 := @siLight5[y * w * 4 + 1];
        PL7 := @siLight5[y * w * 4 + w * 2];
        for x := 1 to w do
        begin
          //todo: seperate background, interior.. median

          PL5.NormalX := (PL1.NormalX + PL2.NormalX + PL3.NormalX + PL4.NormalX) div 4;
          PL5.NormalY := (PL1.NormalY + PL2.NormalY + PL3.NormalY + PL4.NormalY) div 4;
          PL5.NormalZ := (PL1.NormalZ + PL2.NormalZ + PL3.NormalZ + PL4.NormalZ) div 4;
          B := (PByte(@PL1.RoughZposFine)^ + PByte(@PL2.RoughZposFine)^ + PByte(@PL3.RoughZposFine)^ + PByte(@PL4.RoughZposFine)^) div 4;
          PCardinal(@PL5.RoughZposFine)^ := B or ((((PCardinal(@PL1.RoughZposFine)^ shr 8) + (PCardinal(@PL2.RoughZposFine)^ shr 8) +
                 (PCardinal(@PL3.RoughZposFine)^ shr 8) + (PCardinal(@PL4.RoughZposFine)^ shr 8)) shl 6) and $FFFFFF00);
          PL5.Shadow := (PL1.Shadow + PL2.Shadow + PL3.Shadow + PL4.Shadow) div 4;
          PL5.AmbShadow := (PL1.AmbShadow + PL2.AmbShadow + PL3.AmbShadow + PL4.AmbShadow) div 4;
          PL5.SIgradient := (PL1.SIgradient + PL2.SIgradient + PL3.SIgradient + PL4.SIgradient) div 4;
          PL5.OTrap := (PL1.OTrap + PL2.OTrap + PL3.OTrap + PL4.OTrap) div 4;

          PL6.NormalX := (PL1.NormalX + PL2.NormalX) div 2;
          PL6.NormalY := (PL1.NormalY + PL2.NormalY) div 2;
          PL6.NormalZ := (PL1.NormalZ + PL2.NormalZ) div 2;
          B := (PByte(@PL1.RoughZposFine)^ + PByte(@PL2.RoughZposFine)^) div 2;
          PCardinal(@PL6.RoughZposFine)^ := B or ((((PCardinal(@PL1.RoughZposFine)^ shr 8) + (PCardinal(@PL2.RoughZposFine)^ shr 8)) shl 7) and $FFFFFF00);
          PL6.Shadow := (PL1.Shadow + PL2.Shadow) div 2;
          PL6.AmbShadow := (PL1.AmbShadow + PL2.AmbShadow) div 2;
          PL6.SIgradient := (PL1.SIgradient + PL2.SIgradient) div 2;
          PL6.OTrap := (PL1.OTrap + PL2.OTrap) div 2;

          PL7.NormalX := (PL1.NormalX + PL3.NormalX) div 2;
          PL7.NormalY := (PL1.NormalY + PL3.NormalY) div 2;
          PL7.NormalZ := (PL1.NormalZ + PL3.NormalZ) div 2;
          B := (PByte(@PL1.RoughZposFine)^ + PByte(@PL3.RoughZposFine)^) div 2;
          PCardinal(@PL7.RoughZposFine)^ := B or ((((PCardinal(@PL1.RoughZposFine)^ shr 8) + (PCardinal(@PL3.RoughZposFine)^ shr 8)) shl 7) and $FFFFFF00);
          PL7.Shadow := (PL1.Shadow + PL3.Shadow) div 2;
          PL7.AmbShadow := (PL1.AmbShadow + PL3.AmbShadow) div 2;
          PL7.SIgradient := (PL1.SIgradient + PL3.SIgradient) div 2;
          PL7.OTrap := (PL1.OTrap + PL3.OTrap) div 2;

          Inc(PL1, 2);
          Inc(PL3, 2);
          Inc(PL5, 2);
          Inc(PL6, 2);
          Inc(PL7, 2);
          if x < w then
          begin
            Inc(PL2, 2);
            Inc(PL4, 2);
          end;
        end;
      end;
      //start calc threads in high contrast regions


    except
      SetLength(siLight5tmp, 0);
    end;
    Result := Length(siLight5) = w * h * 4;
    if not Result then
    begin
      OutMessage('Out of memory, imagesize to high.');
      Exit;
    end;
  end;
end;

procedure InterpolateMidPoints(Header: TPMandHeader10; var siLight5: array of TSiLight5; Ystart, Yend, Ystep: Integer);
var w, h, x, y, i: Integer;
    siLight5tmp: array of TsiLight5;
    PL1, PL2, PL3, PL4, PL5: TPsiLight5;
    B: Cardinal;
begin
    w := Header.Width;
    h := Header.Height;

    y := Ystart;
    repeat
        PL1 := @siLight5[y * w];
        PL2 := @siLight5[y * w + 2];
        if y >= h - 2 then
        begin
          PL3 := PL1;
          PL4 := PL2;
        end else begin
          PL3 := @siLight5[(y + 2) * w];
          PL4 := @siLight5[(y + 2) * w + 2];
        end;
        PL5 := @siLight5[(y + 1) * w + 1];
        x := 1;
        repeat
          //todo: seperate background, interior.. median



          PL5.NormalX := (PL1.NormalX + PL2.NormalX + PL3.NormalX + PL4.NormalX) div 4;
          PL5.NormalY := (PL1.NormalY + PL2.NormalY + PL3.NormalY + PL4.NormalY) div 4;
          PL5.NormalZ := (PL1.NormalZ + PL2.NormalZ + PL3.NormalZ + PL4.NormalZ) div 4;
          B := (PByte(@PL1.RoughZposFine)^ + PByte(@PL2.RoughZposFine)^ + PByte(@PL3.RoughZposFine)^ + PByte(@PL4.RoughZposFine)^) div 4;
          PCardinal(@PL5.RoughZposFine)^ := B or ((((PCardinal(@PL1.RoughZposFine)^ shr 8) + (PCardinal(@PL2.RoughZposFine)^ shr 8) +
                 (PCardinal(@PL3.RoughZposFine)^ shr 8) + (PCardinal(@PL4.RoughZposFine)^ shr 8)) shl 6) and $FFFFFF00);
          PL5.Shadow := (PL1.Shadow + PL2.Shadow + PL3.Shadow + PL4.Shadow) div 4;
          PL5.AmbShadow := (PL1.AmbShadow + PL2.AmbShadow + PL3.AmbShadow + PL4.AmbShadow) div 4;
          PL5.SIgradient := (PL1.SIgradient + PL2.SIgradient + PL3.SIgradient + PL4.SIgradient) div 4;
          PL5.OTrap := (PL1.OTrap + PL2.OTrap + PL3.OTrap + PL4.OTrap) div 4;

          Inc(PL1, 2);
          Inc(PL3, 2);
          Inc(PL5, 2);
          Inc(x, 2);
          if x < w then
          begin
            Inc(PL2, 2);
            Inc(PL4, 2);
          end;
        until (x > w);
      Inc(y, Ystep);
    until y > Yend;

end;


end.
