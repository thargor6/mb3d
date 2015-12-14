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
    MainPageControl: TPageControl;
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
    ConstantAddBtn: TSpeedButton;
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
    Panel8: TPanel;
    CompileBtn: TSpeedButton;
    Panel21: TPanel;
    SaveBtn: TSpeedButton;
    InfoMemo: TMemo;
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
    procedure ConstantAddBtnClick(Sender: TObject);
    procedure ConstantEditBtnClick(Sender: TObject);
    procedure OptionAddBtnClick(Sender: TObject);
    procedure ParamAddBtnClick(Sender: TObject);
    procedure OptionEditBtnClick(Sender: TObject);
    procedure ParamEditBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SaveBtnClick(Sender: TObject);
    procedure CompileBtnClick(Sender: TObject);
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
    procedure EnableControls;
    procedure PopulateParamsList;
    procedure PopulateConstantsList;
    procedure PopulateOptionsList;
    procedure Validate;
    function SaveCode: Boolean;
    function Compile: Boolean;
    procedure ShowInfoMsg(const Msg: String);
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
  CustomFormulas, FileHandling, ConstantValueEditGUI, ParamValueEditGUI,
  DivUtils, TypeDefinitions, FormulaCompiler;

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
  MainPageControl.ActivePage := CodeSheet;
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

function TJITFormulaEditorForm.SaveCode: Boolean;
var
  FormulaDir: String;
  FormulaFilename: String;
begin
  Result := False;
  Validate;
  FJITFormula.Formulaname := FormulanameEdit.Text;
  FJITFormula.Code := CodeEdit.Text;
  FJITFormula.Description := DescriptionEdit.Text;
  FormulaDir := IncludeTrailingPathDelimiter(IniDirs[3]);
  FormulaFilename := FormulaDir + FJITFormula.Formulaname + '.m3f';
  if (not FileExists(FormulaFilename)) or (MessageDlg('The file <'+FJITFormula.Formulaname + '.m3f'+'> already exists. Do you want to overwrite it?',mtConfirmation, [mbYes, mbNo], 0)=mrYes) then begin
    TJITFormulaWriter.SaveFormula(FJITFormula, FormulaFilename );
    Result := True;
    ShowInfoMsg('Saving succeeded');
  end;
end;

procedure TJITFormulaEditorForm.SaveAndExitBtnClick(Sender: TObject);
begin
  if Compile and SaveCode then
    ModalResult := mrOK;
end;

procedure TJITFormulaEditorForm.SaveBtnClick(Sender: TObject);
begin
  SaveCode;
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

procedure TJITFormulaEditorForm.ConstantAddBtnClick(Sender: TObject);
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
  ParamAddBtn.Enabled := ParamsList.Items.Count < 16;
  ParamEditBtn.Enabled := ParamsList.ItemIndex >= 0;
  ParamDeleteBtn.Enabled := ParamEditBtn.Enabled;
  ConstantAddBtn.Enabled := ConstantsList.Items.Count < 16;
  ConstantEditBtn.Enabled := ConstantsList.ItemIndex >= 0;
  ConstantDeleteBtn.Enabled := ConstantEditBtn.Enabled;
  OptionAddBtn.Enabled := True;
  OptionEditBtn.Enabled := OptionsList.ItemIndex >= 0;
  OptionDeleteBtn.Enabled := OptionEditBtn.Enabled;
end;

procedure TJITFormulaEditorForm.ShowError(const Msg: String);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

procedure TJITFormulaEditorForm.ParseFormula(const Filename: String);
var
  dOptionVtmp: array[0..15] of Double;
  CustomFname: array[0..31] of Byte;
  Formulaname: String;
  CustomFormula: TCustomFormula;
begin
  Formulaname := ExtractFilename(Filename);
  Formulaname := Copy(Formulaname, 1, Length(Formulaname) - Length('.m3f'));
  PutStringInCustomF(CustomFname, Formulaname);
  if not LoadCustomFormula(Filename, CustomFormula, CustomFname, dOptionVtmp, False, 0, FJITFormula) then
    raise Exception.Create('Could not load formula <'+Filename+'>');
end;

procedure TJITFormulaEditorForm.Validate;
begin
  if Pos('JIT', FormulanameEdit.Text) <> 1 then
    raise Exception.Create('The formula name should start with "JIT" in order to distinguish those formulas from the ASM-based formulas');
end;

procedure TJITFormulaEditorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 120 then // F9
    CompileBtnClick(Sender)
  else if Key = 116 then // F5
    SaveBtnClick(Sender);
end;

function TJITFormulaEditorForm.Compile: Boolean;
var
  CompiledFormula: TCompiledFormula;
  pCodePointer: ThybridIteration2;
  Iteration: TIteration3D;
  CodeLines: TStringList;
  X, Y, Z, W: Double;
  Vars: Pointer;
begin
  Result := False;
  try
    CodeLines := TStringList.Create;
    try
      CodeLines.Text := CodeEdit.Text;
      CompiledFormula := TFormulaCompilerRegistry.GetCompilerInstance(langDELPHI).CompileFormula(CodeLines);
    finally
      CodeLines.Free;
    end;
    try
      if CompiledFormula.IsValid then begin
        ThybridIteration2(pCodePointer) := CompiledFormula.CodePointer;
        X := 0.0;
        Y := 0.0;
        Z := 0.0;
        W := 0.0;
        GetMem(Vars, 128 * SizeOf(Double));
        try
          Iteration.PVar := Pointer( Integer(Vars) - 64 * SizeOf(Double) );
          pCodePointer(X, Y, Z, W, @Iteration);
        finally
          FreeMem(Vars);
        end;
        Result := True;
        ShowInfoMsg('Compiling succeeded');
      end
      else
        ShowError(CompiledFormula.ErrorMessage.Text);
    finally
      CompiledFormula.Free;
    end;
  except
    on E: Exception do
      ShowError(E.Message);
  end;
end;

procedure TJITFormulaEditorForm.CompileBtnClick(Sender: TObject);
begin
  Compile;
end;

procedure TJITFormulaEditorForm.ShowInfoMsg(const Msg: String);
begin
  InfoMemo.Lines.Append(Msg);
end;

end.


