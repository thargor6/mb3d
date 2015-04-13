unit SpeedButtonEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons;

type
  TSpeedButtonEx = class (TSpeedButton)
  private
    { Private declarations }
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    procedure CMMouseEnter(var msg: TMessage);
      message CM_MOUSEENTER;
    procedure CMMouseLeave(var msg: TMessage);
      message CM_MOUSELEAVE;
  protected
    { Protected declarations }
    procedure DoMouseEnter; dynamic;
    procedure DoMouseLeave; dynamic;
  public
    { Public declarations }
  published
    { Published declarations }
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Additional', [TSpeedButtonEx]);
end;

procedure TSpeedButtonEx.CMMouseEnter(var msg: TMessage);
begin
  DoMouseEnter;
end;

procedure TSpeedButtonEx.CMMouseLeave(var msg: TMessage);
begin
  DoMouseLeave;
end;

procedure TSpeedButtonEx.DoMouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TSpeedButtonEx.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

end.
