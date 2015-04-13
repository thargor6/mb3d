unit ListBoxEx;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TListBoxEx = class (TListBox)
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
  RegisterComponents('Additional', [TListBoxEx]);
end;

procedure TListBoxEx.CMMouseEnter(var msg: TMessage);
begin
  DoMouseEnter;
end;

procedure TListBoxEx.CMMouseLeave(var msg: TMessage);
begin
  DoMouseLeave;
end;

procedure TListBoxEx.DoMouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TListBoxEx.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

end.
