unit JITFormulaEditGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  JITFormulas, Vcl.Buttons;

type
  TEditMode = (emNew, emEdit, emError);

  TJITFormulaEditorForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    CancelAndExitBtn: TButton;
    SaveAndExitBtn: TButton;
    PageControl1: TPageControl;
    CodeSheet: TTabSheet;
    DescriptionSheet: TTabSheet;
    CodePnl: TPanel;
    CodeEdit: TRichEdit;
    Panel7: TPanel;
    DescriptionEdit: TRichEdit;
    Panel3: TPanel;
    Panel5: TPanel;
    FormulanameEdit: TEdit;
    Label1: TLabel;
    OptionsPnl: TPanel;
    Panel9: TPanel;
    Label2: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    OptionsList: TListBox;
    OptionDeleteBtn: TSpeedButton;
    OptionAddBtn: TSpeedButton;
    OptionEditBtn: TSpeedButton;
    ConstantsPnl: TPanel;
    Panel13: TPanel;
    Label3: TLabel;
    Panel14: TPanel;
    Panel15: TPanel;
    ConstantDeleteBtn: TSpeedButton;
    ConstantsAddBtn: TSpeedButton;
    ConstantEditBtn: TSpeedButton;
    Panel16: TPanel;
    ConstantsList: TListBox;
    ParamsPnl: TPanel;
    Panel17: TPanel;
    Label4: TLabel;
    Panel18: TPanel;
    Panel19: TPanel;
    ParamDeleteBtn: TSpeedButton;
    ParamAddBtn: TSpeedButton;
    ParamEditBtn: TSpeedButton;
    Panel20: TPanel;
    ParamsList: TListBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveAndExitBtnClick(Sender: TObject);
    procedure CancelAndExitBtnClick(Sender: TObject);
    procedure ParamsListClick(Sender: TObject);
    procedure ConstantsListClick(Sender: TObject);
    procedure OptionsListClick(Sender: TObject);
    procedure ParamDeleteBtnClick(Sender: TObject);
    procedure ConstantDeleteBtnClick(Sender: TObject);
    procedure OptionDeleteBtnClick(Sender: TObject);
    procedure ConstantsAddBtnClick(Sender: TObject);
    procedure ConstantEditBtnClick(Sender: TObject);
    procedure OptionAddBtnClick(Sender: TObject);
    procedure ParamAddBtnClick(Sender: TObject);
    procedure OptionEditBtnClick(Sender: TObject);
    procedure ParamEditBtnClick(Sender: TObject);
  private
    { Private declarations }
    FEditMode: TEditMode;
    FEditFormulaname: String;
    FJITFormula: TJITFormula;
    procedure Init;
    procedure PopulateFields;
    procedure ShowError(const Msg: String);
    procedure ParseFormula(const Filename: String);
    procedure NewFormula;
    procedure SaveFormula;
    procedure EnableControls;
    procedure PopulateParamsList;
    procedure PopulateConstantsList;
    procedure PopulateOptionsList;
  public
    { Public declarations }
    property EditMode: TEditMode read FEditMode write FEditMode;
    property Formulaname: String write FEditFormulaname;
  end;

var
  JITFormulaEditorForm: TJITFormulaEditorForm;

implementation

{$R *.dfm}
uses
  FileHandling, ConstantValueEditGUI, ParamValueEditGUI;

procedure TJITFormulaEditorForm.CancelAndExitBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TJITFormulaEditorForm.FormCreate(Sender: TObject);
begin
  FJITFormula := nil;
end;

procedure TJITFormulaEditorForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FJITFormula) then
    FJITFormula.Free;
end;

procedure TJITFormulaEditorForm.FormShow(Sender: TObject);
begin
  try
   Init;
  except
    on E:Exception do begin
      FEditMode := emError;
      ShowError(E.Message);
    end;
  end;
  PopulateFields;
  EnableControls;
end;

procedure TJITFormulaEditorForm.Init;
var
  FormulaDir: String;
begin
  if Assigned(FJITFormula) then
    FreeAndNil(FJITFormula);
  FJITFormula := TJITFormula.Create;

  if FEditMode = emEdit then begin
    FormulaDir := IncludeTrailingPathDelimiter(IniDirs[3]);
    ParseFormula(FormulaDir+FEditFormulaname+'.m3f');
  end
  else begin
    NewFormula;
  end;
end;

procedure TJITFormulaEditorForm.PopulateFields;
begin
  CodeEdit.Text := FJITFormula.Code;
  DescriptionEdit.Text := FJITFormula.Description;
  FormulanameEdit.Text := FJITFormula.Formulaname;
  PopulateParamsList;
  if ParamsList.Items.Count > 0 then
    ParamsList.ItemIndex := 0;
  PopulateConstantsList;
  if ConstantsList.Items.Count > 0 then
    ConstantsList.ItemIndex := 0;
  PopulateOptionsList;
  if OptionsList.Items.Count > 0 then
    OptionsList.ItemIndex := 0;
end;

procedure TJITFormulaEditorForm.PopulateParamsList;
var
  I: Integer;
  Param: TJITFormulaParamValue;
begin
  ParamsList.Items.Clear;
  for I := 0 to FJITFormula.ParamValueCount - 1 do begin
    Param := FJITFormula.GetParamValue(I);
    ParamsList.Items.Add(Param.Name+' = '+Param.ValueToString);
  end;
end;

procedure TJITFormulaEditorForm.PopulateConstantsList;
var
  I: Integer;
  CParam: TJITFormulaConstValue;
begin
  ConstantsList.Items.Clear;
  for I := 0 to FJITFormula.ConstValueCount - 1 do begin
    CParam := FJITFormula.GetConstValue(I);
    ConstantsList.Items.Add(CParam.ValueToString);
  end;
end;

procedure TJITFormulaEditorForm.PopulateOptionsList;
var
  I: Integer;
  Option: TJITFormulaOption;
begin
  OptionsList.Items.Clear;
  for I := 0 to FJITFormula.OptionCount - 1 do begin
    Option := FJITFormula.GetOption(I);
    OptionsList.Items.Add(Option.Name+' = '+Option.ValueToString);
  end;
end;

procedure TJITFormulaEditorForm.SaveAndExitBtnClick(Sender: TObject);
begin
  SaveFormula;
  ModalResult := mrOK;
end;

procedure TJITFormulaEditorForm.NewFormula;
begin
  with FJITFormula do begin
    Formulaname := 'JITMyNewFormula';
    SetOption('Version', dtINT64, 2);
    SetOption('DEscale', dtDouble, 1.0);
    SetOption('SIpower' , dtDouble, 2.0);
  end;
end;

procedure TJITFormulaEditorForm.OptionAddBtnClick(Sender: TObject);
begin
  ParamValueEditFrm.Clear(mdNew);
  ParamValueEditFrm.WindowTitle := 'Add option value';
  if ParamValueEditFrm.ShowModal = mrOK then begin
    if FJITFormula.GetOption(ParamValueEditFrm.Paramname) <> nil then
      raise Exception.Create('Option <'+ParamValueEditFrm.Paramname+'> already exists');
    FJITFormula.SetOption( ParamValueEditFrm.Paramname, StrToJITValueDatatype(ParamValueEditFrm.TypeStr), ParamValueEditFrm.Value);
    PopulateOptionsList;
    OptionsList.ItemIndex := OptionsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.OptionDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveOption(OptionsList.ItemIndex);
  PopulateOptionsList;
  if OptionsList.Items.Count > 0 then
    OptionsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.OptionEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  OptionValue: TJITFormulaOption;
begin
  ParamValueEditFrm.Clear(mdEdit);
  Idx := OptionsList.ItemIndex;
  if (Idx >= 0) then begin
    OptionValue := FJITFormula.GetOption(Idx);
    ParamValueEditFrm.Paramname := OptionValue.Name;
    ParamValueEditFrm.TypeStr := JITValueDatatypeToStr( OptionValue.Datatype );
    ParamValueEditFrm.Value := OptionValue.Value;
    ParamValueEditFrm.WindowTitle := 'Edit option value';
    if (ParamValueEditFrm.ShowModal = mrOK) then begin
      OptionValue.Datatype := StrToJITValueDatatype(ParamValueEditFrm.TypeStr);
      OptionValue.Value := ParamValueEditFrm.Value;
      PopulateOptionsList;
      OptionsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.OptionsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.ParamAddBtnClick(Sender: TObject);
begin
  ParamValueEditFrm.Clear(mdNew);
  ParamValueEditFrm.WindowTitle := 'Add named param';
  if ParamValueEditFrm.ShowModal = mrOK then begin
    if FJITFormula.GetParamValue(ParamValueEditFrm.Paramname) <> nil then
      raise Exception.Create('Param <'+ParamValueEditFrm.Paramname+'> already exists');
    FJITFormula.SetParamValue( ParamValueEditFrm.Paramname, StrToJITValueDatatype(ParamValueEditFrm.TypeStr), ParamValueEditFrm.Value);
    PopulateParamsList;
    ParamsList.ItemIndex := ParamsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.ParamDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveParamValue(ParamsList.ItemIndex);
  PopulateParamsList;
  if ParamsList.Items.Count > 0 then
    ParamsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.ParamEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  ParamValue: TJITFormulaParamValue;
begin
  ParamValueEditFrm.Clear(mdEdit);
  Idx := ParamsList.ItemIndex;
  if (Idx >= 0) then begin
    ParamValue := FJITFormula.GetParamValue(Idx);
    ParamValueEditFrm.Paramname := ParamValue.Name;
    ParamValueEditFrm.TypeStr := JITValueDatatypeToStr( ParamValue.Datatype );
    ParamValueEditFrm.Value := ParamValue.Value;
    ParamValueEditFrm.WindowTitle := 'Edit named param';
    if (ParamValueEditFrm.ShowModal = mrOK) then begin
      ParamValue.Datatype := StrToJITValueDatatype(ParamValueEditFrm.TypeStr);
      ParamValue.Value := ParamValueEditFrm.Value;
      PopulateParamsList;
      ParamsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.ParamsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.ConstantDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveConstValue(ConstantsList.ItemIndex);
  PopulateConstantsList;
  if ConstantsList.Items.Count > 0 then
    ConstantsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.ConstantEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  ConstValue: TJITFormulaConstValue;
begin
  ConstantValueEditFrm.Clear;
  Idx := ConstantsList.ItemIndex;
  if (Idx >= 0) then begin
    ConstValue := FJITFormula.GetConstValue(Idx);
    ConstantValueEditFrm.TypeStr := JITValueDatatypeToStr( ConstValue.Datatype );
    ConstantValueEditFrm.Value := ConstValue.Value;
    ConstantValueEditFrm.WindowTitle := 'Edit constant value';
    if (ConstantValueEditFrm.ShowModal = mrOK) then begin
      ConstValue.Datatype := StrToJITValueDatatype(ConstantValueEditFrm.TypeStr);
      ConstValue.Value := ConstantValueEditFrm.Value;
      PopulateConstantsList;
      ConstantsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.ConstantsAddBtnClick(Sender: TObject);
begin
  ConstantValueEditFrm.Clear;
  ConstantValueEditFrm.WindowTitle := 'Add constant value';
  if ConstantValueEditFrm.ShowModal = mrOK then begin
    FJITFormula.AddConstValue(StrToJITValueDatatype(ConstantValueEditFrm.TypeStr), ConstantValueEditFrm.Value);
    PopulateConstantsList;
    ConstantsList.ItemIndex := ConstantsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.ConstantsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.EnableControls;
begin
  ParamEditBtn.Enabled := ParamsList.ItemIndex >= 0;
  ParamDeleteBtn.Enabled := ParamEditBtn.Enabled;
  ConstantEditBtn.Enabled := ConstantsList.ItemIndex >= 0;
  ConstantDeleteBtn.Enabled := ConstantEditBtn.Enabled;
  OptionEditBtn.Enabled := OptionsList.ItemIndex >= 0;
  OptionDeleteBtn.Enabled := OptionEditBtn.Enabled;
end;

procedure TJITFormulaEditorForm.ShowError(const Msg: String);
begin
  // TODO
end;

procedure TJITFormulaEditorForm.ParseFormula(const Filename: String);
begin
  // TODO
end;

procedure TJITFormulaEditorForm.SaveFormula;
begin
  // TODO
end;

end.


