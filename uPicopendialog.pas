unit uPicopendialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, buttons, extctrls, stdctrls, commdlg;


type
  tPicOpenDialog = class(TOpenDialog)
  private
    { Private-Deklarationen }
    fpanel:      tPanel;
    fAssociated: tPicOpenDialog;
    procedure fButtonClick(sender: tobject);
  protected
    { Protected-Deklarationen }
    procedure notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoClose; override;
    procedure DoShow;  override;
    procedure SetString(Index: Integer; Val: String);
    function  GetString(Index: Integer): String;
    procedure SetfAssociated(Value : tPicOpenDialog);
  public
    { Public-Deklarationen }
    pImage : tImage;
    fLabel : tLabel;
    fpCheck : tCheckbox;
    constructor Create(Aowner: tComponent); override;
    destructor Destroy; override;
 //   function Execute: Boolean; override;
  published
    { Published-Deklarationen }
    property ButtonHint : string index 2 read GetString
             write setstring ;
    property LabelCaption : string index 3 read GetString
             write SetString ;
    property Associated : tPicOpenDialog read fAssociated write SetfAssociated;
  end;

procedure Register;

implementation

//uses filectrl, shellapi, commctrl;

{$r myfdlg.res}

procedure Register;
begin
    RegisterComponents('Merkes'' Dialogs', [TpicOpenDialog]);
end;

constructor TPicOpenDialog.Create(Aowner: tComponent);
begin
  inherited Create(Aowner);
  fPanel      := TPanel.Create(Self);
  fAssociated := nil;
  Template    := 'MYDLGO';
  with fPanel do
  begin
    Name           := 'ClientPanel';
    Caption        := '';
    BevelOuter     := bvLowered;
    BorderWidth    := 0;
    TabOrder       := 1;
    DoubleBuffered := True;
  {  fpCheck        := TCheckbox.Create(Self);
    with fpCheck do
    begin
      Name           := 'showhidepreview';
      Enabled        := True;
      Checked        := True;
      Caption        := 'Preview';
      Hint           := '';
      ParentShowHint := False;
      ShowHint       := True;
      OnClick        := fButtonClick;
      Parent         := fPanel;
    end; }
    fLabel := TLabel.Create(Self);
    with fLabel do
    begin
      Name           := 'Size';
      caption        := '';
      transparent    := True;
      ParentShowHint := False;
      ShowHint       := False;
      Parent         := fPanel;
      Alignment      := taCenter;
    end;
    pImage := TImage.Create(self);
    with pImage do
    begin
      Parent  := fPanel;
      Stretch := True;
    end;
  end;
end;

destructor TPicOpenDialog.Destroy;
begin
  pImage.Free;
  fpCheck.Free;
  fLabel.Free;
  fPanel.Free;
  inherited Destroy;
end;

{function tpicopendialog.Execute: Boolean;
begin
//  if NewStyleControls and not (ofOldStyleDialog in Options) then
  //  Template := 'MYDLGO' else Template := nil;
  Result := inherited execute;
end;       }

procedure TPicOpenDialog.DoClose;
begin
  inherited DoClose;
  Application.HideHint;   { Hide any hint windows left behind }
end;

procedure TPicOpenDialog.DoShow;
var
  PreviewRect, rect: TRect;
  hParent: THandle;
  s: String;
begin
  hParent := GetParent(Handle);    // hparent ist das übergeordnete fenster?
  GetWindowRect(hParent, rect);    // relative to screen
  SetWindowPos(hParent, 0, 0, 0, rect.Right - rect.Left + 287,
               rect.Bottom - rect.Top - 38, SWP_NOMOVE);

  { Set preview area to entire dialog }
  GetClientRect(Handle, PreviewRect);
  { Move preview area to right of static area }
  PreviewRect.left    := GetStaticRect.Right;
  PreviewRect.top     := 33;
  FPanel.BoundsRect   := PreviewRect;
  FPanel.ParentWindow := Handle;
  FPanel.Width        := 286;
  FPanel.Height       := 224;
//  fpCheck.SetBounds(204, 1, 75, 25);
  fLabel.SetBounds(80, 5, 200, fLabel.Height);
  s              := fLabel.Caption;
  Flabel.Caption := '';
  Flabel.Caption := s;       // why that?
  inherited DoShow;
end;

procedure tPicOpenDialog.fButtonClick(Sender: tObject);  //preview an/aus
begin
    if not fpCheck.Checked then begin
      pImage.Visible := False;
      fLabel.Caption := '';
    end; // else sendmessage(handle,WM_Command,LBN_SELCHANGE,0); //OnSelectionChange senden
end;

procedure tPicOpenDialog.SetString(Index: Integer; Val: String);
begin
    case Index of
      2:  fpCheck.Hint   := Val;
      3:  fLabel.Caption := Val;
    end;
end;

function tPicOpenDialog.GetString(Index: Integer): String;
begin
    case Index of
      2:  Result := fpCheck.Hint;
      3:  Result := fLabel.Caption;
    end;
end;

procedure tPicOpenDialog.SetfAssociated(Value: tPicOpenDialog);
begin
     if Value <> Self then if Value <> fAssociated then fAssociated := Value;
end;

procedure tPicOpenDialog.Notification(aComponent: TComponent; Operation: TOperation);
begin
     if Operation = opRemove then if aComponent = fAssociated then fAssociated := nil;
     inherited;
end;

end.

