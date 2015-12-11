unit MapSequencesGUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ExtDlgs, Vcl.Buttons, Vcl.ExtCtrls, Vcl.ComCtrls,
  MapSequences;

type
  TMapSequencesFrm = class(TForm)
    Panel1: TPanel;
    MapSequencesList: TListBox;
    Panel3: TPanel;
    Label1: TLabel;
    SpeedButton11: TSpeedButton;
    OpenPictureDialog: TOpenPictureDialog;
    SpeedButton9: TSpeedButton;
    DestChannelEdit: TEdit;
    DestChannelUpDown: TUpDown;
    Image3: TImage;
    Panel2: TPanel;
    Bevel1: TBevel;
    NewBtn: TSpeedButton;
    DeleteBtn: TSpeedButton;
    Panel4: TPanel;
    CancelAndExitBtn: TButton;
    SaveAndExitBtn: TButton;
    Panel5: TPanel;
    ImageFilenameEdit: TEdit;
    Label2: TLabel;
    FirstImageEdit: TEdit;
    LastImageEdit: TEdit;
    LoopCheckBox: TCheckBox;
    Label3: TLabel;
    IncrementEdit: TEdit;
    Label4: TLabel;
    IncrementUpDown: TUpDown;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MapSequencesListClick(Sender: TObject);
    procedure CancelAndExitBtnClick(Sender: TObject);
    procedure SaveAndExitBtnClick(Sender: TObject);
    procedure DestChannelUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure DestChannelEditExit(Sender: TObject);
    procedure FirstImageEditExit(Sender: TObject);
    procedure LastImageEditExit(Sender: TObject);
    procedure LoopCheckBoxExit(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure IncrementEditExit(Sender: TObject);
    procedure IncrementUpDownClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private-Deklarationen }
    FRefreshing: Boolean;
    FMapSequenceList: TMapSequenceList;
    procedure RefreshMapSequencesList;
    function GetCurrSequence: TMapSequence;
    procedure RefreshDetailView;
    procedure EnableControls;
  public
    { Public-Deklarationen }
  end;

var
  MapSequencesFrm: TMapSequencesFrm;

implementation

uses
  Math, FileHandling;

{$R *.dfm}

procedure TMapSequencesFrm.FirstImageEditExit(Sender: TObject);
var
  Sequence: TMapSequence;
begin
  Sequence := GetCurrSequence;
  if Sequence <> nil then
    Sequence.FirstImage := StrToInt(FirstImageEdit.Text);
end;

procedure TMapSequencesFrm.FormCreate(Sender: TObject);
begin
  FMapSequenceList := TMapSequenceList.Create;
end;

procedure TMapSequencesFrm.FormDestroy(Sender: TObject);
begin
  FMapSequenceList.Free;
end;

procedure TMapSequencesFrm.FormShow(Sender: TObject);
begin
  OpenPictureDialog.InitialDir := IniDirs[2];
  FMapSequenceList.Assign(TMapSequenceListProvider.GetInstance);
  RefreshMapSequencesList;
  if FMapSequenceList.Count > 0 then begin
    MapSequencesList.ItemIndex := 0;
    MapSequencesListClick(Sender);
  end;
end;

procedure TMapSequencesFrm.MapSequencesListClick(Sender: TObject);
begin
  RefreshDetailView;
end;

procedure TMapSequencesFrm.NewBtnClick(Sender: TObject);
var
  Sequence: TMapSequence;

  function GuessDestChannel: Integer;
  var
    I: Integer;
    Sequence: TMapSequence;
  begin
    Result := 0;
    for I := 0 to FMapSequenceList.Count - 1 do begin
      Sequence := FMapSequenceList.Items[I];
      if Sequence.DestChannel > Result then
        Result := Sequence.DestChannel;
    end;
    Result := Result + 1;
  end;

  function GuessFirstImage(const Filename: String): Integer;
  const
    MaxTries = 1000;
  begin
    Result := 1;
    while not FileExists(TMapSequence.FormatFrameFilename(Filename, Result)) and (Result < MaxTries) do
      Inc(Result);
    if not FileExists(TMapSequence.FormatFrameFilename(Filename, Result)) then
      Result := 1;
  end;

  function GuessLastImage(const Filename: String): Integer;
  begin
    Result := 1;
    if not FileExists(TMapSequence.FormatFrameFilename(Filename, Result)) then
      Exit;
    while FileExists(TMapSequence.FormatFrameFilename(Filename, Result)) do
      Inc(Result);
    Result := Result - 1;
  end;

begin
  if OpenPictureDialog.Execute(Self.Handle) then begin
    Sequence := TMapSequence.Create;
    try
      Sequence.ImageFilename := OpenPictureDialog.FileName;
      Sequence.FirstImage := GuessFirstImage(Sequence.ImageFilename);
      Sequence.LastImage := GuessLastImage(Sequence.ImageFilename);
      Sequence.DestChannel := GuessDestChannel;
      Sequence.Increment := 1;
      Sequence.Loop := True;
      FMapSequenceList.AddSequence(Sequence);
      RefreshMapSequencesList;
      MapSequencesList.ItemIndex := FMapSequenceList.Count - 1;
      MapSequencesListClick(Sender);
    except
      Sequence.Free;
      raise;
    end;
  end;
end;

procedure TMapSequencesFrm.RefreshMapSequencesList;
var
  I: Integer;
  OldRefreshing: Boolean;

  function GetCaption(const Sequence: TMapSequence): String;
  var
    I: Integer;
    Path: String;
  begin
    Path := ExtractFilePath(Sequence.ImageFilename);;
    if Length(Path)>1 then begin
      for I := Length(Path)-1 downto 1 do begin
        if (Path[I]='\') or (Path[I]='/') then begin
          Path := Copy(Path, I, Length(Path));
          break;
        end;
      end;
    end;
    if Length(Path)>16 then begin
      Path := '..'+Copy(Path, Length(Path)-16, Length(Path));
    end;
    Result := Path + ExtractFileName(Sequence.ImageFilename);
  end;

begin
  OldRefreshing := FRefreshing;
  FRefreshing := True;
  try
    MapSequencesList.Items.Clear;
    for I := 0 to FMapSequenceList.Count-1 do
      MapSequencesList.Items.Add(GetCaption(FMapSequenceList.Items[I]));
  finally
    FRefreshing := OldRefreshing;
  end;
  RefreshDetailView;
end;

procedure TMapSequencesFrm.SaveAndExitBtnClick(Sender: TObject);
begin
  TMapSequenceListPersister.Save(FMapSequenceList);
  TMapSequenceListProvider.GetInstance.Assign(FMapSequenceList);
  Visible := False;
end;

procedure TMapSequencesFrm.IncrementUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  IncrementEditExit(Sender);
end;

procedure TMapSequencesFrm.DeleteBtnClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := MapSequencesList.ItemIndex;
  if Idx >= 0 then begin
    FMapSequenceList.DeleteSequence(Idx);
    RefreshMapSequencesList;
    if FMapSequenceList.Count > 0 then begin
      MapSequencesList.ItemIndex := 0;
      MapSequencesListClick(Sender);
    end;
  end;
end;

procedure TMapSequencesFrm.DestChannelEditExit(Sender: TObject);
var
  Sequence: TMapSequence;
begin
  Sequence := GetCurrSequence;
  if Sequence <> nil then
    Sequence.DestChannel := StrToInt(DestChannelEdit.Text);
end;

procedure TMapSequencesFrm.DestChannelUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  DestChannelEditExit(Sender);
end;

procedure TMapSequencesFrm.EnableControls;
var
  Editing: Boolean;
begin
  Editing := GetCurrSequence <> nil;
  NewBtn.Enabled := True;
  DeleteBtn.Enabled := Editing;
  ImageFilenameEdit.Enabled := Editing;
  FirstImageEdit.Enabled := Editing;
  LastImageEdit.Enabled := Editing;
  LoopCheckBox.Enabled := Editing;
  DestChannelEdit.Enabled := Editing;
  DestChannelUpDown.Enabled := Editing;
  IncrementEdit.Enabled := Editing;
  IncrementUpDown.Enabled := Editing;
end;

procedure TMapSequencesFrm.RefreshDetailView;
var
  Sequence: TMapSequence;
begin
  if FRefreshing then
    exit;
  EnableControls;
  Sequence := GetCurrSequence;
  DestChannelUpDown.Position := 0;
  IncrementUpDown.Position := 1;
  if Sequence = nil then begin
    ImageFilenameEdit.Text := '';
    FirstImageEdit.Text := '';
    LastImageEdit.Text := '';
    LoopCheckBox.Checked := False;
    DestChannelEdit.Text := '';
    IncrementEdit.Text := '';
  end
  else begin
    ImageFilenameEdit.Text := Sequence.ImageFilename;
    FirstImageEdit.Text := IntToStr(Sequence.FirstImage);
    LastImageEdit.Text := IntToStr(Sequence.LastImage);
    LoopCheckBox.Checked := Sequence.Loop;
    DestChannelEdit.Text := IntToStr(Sequence.DestChannel);
    IncrementEdit.Text := IntToStr(Sequence.Increment);
  end;
end;

function TMapSequencesFrm.GetCurrSequence: TMapSequence;
var
  Idx: Integer;
begin
  Idx := MapSequencesList.ItemIndex;
  if Idx>=0 then
    Result := FMapSequenceList.Items[Idx]
  else
    Result := nil;
end;

procedure TMapSequencesFrm.IncrementEditExit(Sender: TObject);
var
  Sequence: TMapSequence;
begin
  Sequence := GetCurrSequence;
  if Sequence <> nil then
    Sequence.Increment := StrToInt(IncrementEdit.Text);
end;

procedure TMapSequencesFrm.LastImageEditExit(Sender: TObject);
var
  Sequence: TMapSequence;
begin
  Sequence := GetCurrSequence;
  if Sequence <> nil then
    Sequence.LastImage := StrToInt(LastImageEdit.Text);
end;

procedure TMapSequencesFrm.LoopCheckBoxExit(Sender: TObject);
var
  Sequence: TMapSequence;
begin
  Sequence := GetCurrSequence;
  if Sequence <> nil then
    Sequence.Loop := LoopCheckBox.Checked;
end;

procedure TMapSequencesFrm.CancelAndExitBtnClick(Sender: TObject);
begin
  Visible := False;
end;

end.


