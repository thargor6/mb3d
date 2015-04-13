unit BatchForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, ShellApi, Menus;

type
  TBatchForm1 = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Button2: TButton;
    Button3: TButton;
    CheckBox2: TCheckBox;
    Button4: TButton;
    PopupMenu1: TPopupMenu;
    Deleteselectedfilesfromlist1: TMenuItem;
    Clearthewholelist1: TMenuItem;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ListView1Insert(Sender: TObject; Item: TListItem);
    procedure Button1Click(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Button4Click(Sender: TObject);
    procedure Clearthewholelist1Click(Sender: TObject);
    procedure Deleteselectedfilesfromlist1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure WMDROPFILES(var Msg: TMessage); message WM_DROPFILES;
    function CanLoadParas(M3Pfile: String): Boolean;
    function NotDouble(s: String): Boolean;
    procedure AddProofItem(s: String);
  public
    { Public-Deklarationen }
    CurrentListIndex: Integer;
    procedure NextFile;
  end;

var
  BatchForm1: TBatchForm1;
  BatchStatus: Integer = 0;
  BatchFormCreated: LongBool = False;

implementation

uses Mand, TypeDefinitions, FileHandling, CustomFormulas;

{$R *.dfm}

function TBatchForm1.CanLoadParas(M3Pfile: String): Boolean;
var x: Integer;
    HybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
    Header: TMandHeader11;
    HAddOn: THeaderCustomAddon;
begin
    if UpperCase(ExtractFileExt(M3Pfile)) <> '.M3P' then Result := False else
    begin
      Header.PCFAddon := @HAddOn;
      for x := 0 to MAX_FORMULA_COUNT - 1 do Header.PHCustomF[x] := @HybridCustoms[x];
      for x := 0 to MAX_FORMULA_COUNT - 1 do IniCustomF(@HybridCustoms[x]);
      Result := LoadParameter(Header, M3Pfile, False);
    end;
end;

function TBatchForm1.NotDouble(s: String): Boolean;
var x: Integer;
begin
    Result := True;
    for x := 0 to ListView1.Items.Count - 1 do
      if ListView1.Items[x].Caption = s then Result := False;
end;

procedure TBatchForm1.AddProofItem(s: String);
begin
    if NotDouble(s) and CanLoadParas(s) then ListView1.AddItem(s, nil);
end;

procedure TBatchForm1.Button2Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TBatchForm1.Button3Click(Sender: TObject); //open M3P files
var x: Integer;
begin
    Mand3DForm.OpenDialog1.Options := Mand3DForm.OpenDialog1.Options + [ofAllowMultiSelect];
    if Mand3DForm.OpenDialog1.Execute then
    begin
      for x := 0 to Mand3DForm.OpenDialog1.Files.Count - 1 do
        AddProofItem(Mand3DForm.OpenDialog1.Files.Strings[x]);
    end;
end;

procedure TBatchForm1.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var x: Integer;
begin
    if (BatchStatus = 0) and (Key = 46) then //delete
    begin
      x := 0;
      while x < ListView1.Items.Count do
        if ListView1.Items[x].Selected then ListView1.Items[x].Delete else Inc(x);
    end;
end;

procedure TBatchForm1.WMDROPFILES(var Msg: TMessage);
var i, count, size: integer;
    FileName: PChar;
begin
    inherited;
    count := DragQueryFile(Msg.WParam, $FFFFFFFF, FileName, 255);
    for i := 0 to count - 1 do
    begin
      size     := DragQueryFile(Msg.WParam, i, nil, 0) + 1;
      FileName := StrAlloc(size);
      DragQueryFile(Msg.WParam, i, FileName, size);
      AddProofItem(StrPas(FileName));
      StrDispose(FileName);
    end;
    DragFinish(Msg.WParam);
end;

procedure TBatchForm1.FormCreate(Sender: TObject);
begin
    DragAcceptFiles(Self.Handle, True);
    BatchFormCreated := True;
end;

procedure TBatchForm1.ListView1Insert(Sender: TObject; Item: TListItem);
begin
    Item.Checked := True;
end;

procedure TBatchForm1.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    if BatchStatus = 0 then
    begin
      if Item.SubItems.Count < 1 then Item.SubItems.Add('');
      if Item.Checked then Item.SubItems[0] := 'Selected'
                      else Item.SubItems[0] := 'Not selected';
    end;
end;

procedure TBatchForm1.NextFile;
begin
    if BatchStatus < 0 then CurrentListIndex := ListView1.Items.Count;
    if (CurrentListIndex < ListView1.Items.Count) and (CurrentListIndex >= 0) then
    begin
      ListView1.Items[CurrentListIndex].Checked := False;
      ListView1.Items[CurrentListIndex].SubItems[0] := 'M3I done';
    end;
    repeat
      Inc(CurrentListIndex)
    until (CurrentListIndex >= ListView1.Items.Count) or (ListView1.Items[CurrentListIndex].Checked and
           LoadParameter(Mand3DForm.MHeader, ListView1.Items[CurrentListIndex].Caption, True));
    if CurrentListIndex < ListView1.Items.Count then
    begin
      Mand3DForm.MHeader.bCalc3D := 1;
      Mand3DForm.CalcMand(True);
    end
    else
    begin
      BatchStatus := 0;
      Mand3DForm.EnableButtons;
      Button1.Enabled := True;
      Button1.Caption := 'Start batch rendering';
      ListView1.PopupMenu := PopupMenu1;
    end;
end;

procedure TBatchForm1.Button1Click(Sender: TObject);  //start batch
begin
    if Button1.Caption = 'Stop batch rendering' then
    begin
      MCalcStop := True;
      Button1.Caption := 'Stopping batch...';
      Button1.Enabled := False;
      BatchStatus := -1;
    end else begin
      //proof free disc space:  must be calc all needed space of files and add for each disc the amount of space needed
   //   DiscFreeMB(disc: String; var FreeMB: Integer): LongBool;

      Button1.Caption := 'Stop batch rendering';
      BatchStatus := 1;
      CurrentListIndex := -1;
      ListView1.PopupMenu := nil;
      NextFile;
    end;
end;

procedure TBatchForm1.Button4Click(Sender: TObject);
begin
    ShellExecute(Application.Handle, 'open', nil , nil, PCHar(extractfiledir(IniDirs[1])), SW_ShowNormal)
end;

procedure TBatchForm1.Clearthewholelist1Click(Sender: TObject);
begin
    if BatchStatus = 0 then ListView1.Clear;
end;

procedure TBatchForm1.Deleteselectedfilesfromlist1Click(Sender: TObject);
var x: Integer;
begin
    if BatchStatus = 0 then  //delete
    begin
      x := 0;
      while x < ListView1.Items.Count do
        if ListView1.Items[x].Selected then ListView1.Items[x].Delete else Inc(x);
    end;
end;

end.
