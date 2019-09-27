(*
  FormulaJIT for MB3D
  Copyright (C) 2016-2019 Andreas Maschke

  This is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser
  General Public License as published by the Free Software Foundation; either version 2.1 of the
  License, or (at your option) any later version.

  This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public License along with this software;
  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  02110-1301 USA, or see the FSF site: http://www.fsf.org.
*)
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
    LoadFormulaBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    PreprocessedCodeSheet: TTabSheet;
    Panel22: TPanel;
    PreprocessedCodeEdit: TRichEdit;
    SupportedFunctionsSheet: TTabSheet;
    Panel23: TPanel;
    SupportedFunctionsEdit: TRichEdit;
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
    procedure LoadFormulaBtnClick(Sender: TObject);
    procedure ParamsListDblClick(Sender: TObject);
    procedure ConstantsListDblClick(Sender: TObject);
    procedure OptionsListDblClick(Sender: TObject);
    procedure PreprocessedCodeSheetShow(Sender: TObject);
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
    procedure PopulateList(List: TListBox; const ValueType: TJITFormulaValueType);
    procedure Validate;
    function SaveCode: Boolean;
    function Compile: Boolean;
    procedure ShowInfoMsg(const Msg: String);
  protected
    procedure WMEnterSizeMove(var Message: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMExitSizeMove(var Message: TMessage); message WM_EXITSIZEMOVE;
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
  CustomFormulas, FileHandling, ParamValueEditGUI, DivUtils, TypeDefinitions,
  FormulaCompiler, CompilerUtil;

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
  {$ifndef JIT_FORMULA_PREPROCESSING}
  PreprocessedCodeSheet.TabVisible := False;
  {$endif}
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

procedure TJITFormulaEditorForm.LoadFormulaBtnClick(Sender: TObject);
begin
  try
    OpenDialog.InitialDir := IncludeTrailingPathDelimiter(IniDirs[3]);
  except
    // Hide error
  end;
  if OpenDialog.Execute then begin
    FEditMode := emEdit;
    FEditFormulaname := ExtractFilename(OpenDialog.FileName);
    FEditFormulaname := Copy(FEditFormulaname, 1, Length(FEditFormulaname) - Length('.m3f'));
    FormShow(Sender);
  end;
end;

procedure TJITFormulaEditorForm.PopulateFields;
begin
  CodeEdit.Text := FJITFormula.Code;
  DescriptionEdit.Text := FJITFormula.Description;
  FormulanameEdit.Text := FJITFormula.Formulaname;
  PopulateList(ParamsList, vtParam);
  if ParamsList.Items.Count > 0 then
    ParamsList.ItemIndex := 0;
  PopulateList(ConstantsList, vtConst);
  if ConstantsList.Items.Count > 0 then
    ConstantsList.ItemIndex := 0;
  PopulateList(OptionsList, vtOption);
  if OptionsList.Items.Count > 0 then
    OptionsList.ItemIndex := 0;
end;

procedure TJITFormulaEditorForm.PopulateList(List: TListBox; const ValueType: TJITFormulaValueType);
var
  I: Integer;
  Pair: TNameValuePair;
begin
  List.Items.Clear;
  for I := 0 to FJITFormula.GetValueCount(ValueType) - 1 do begin
    Pair := FJITFormula.GetValue(ValueType, I);
    List.Items.Add(Pair.Name+' = '+Pair.ValueToString);
  end;
end;

procedure TJITFormulaEditorForm.PreprocessedCodeSheetShow(Sender: TObject);
begin
  {$ifdef JIT_FORMULA_PREPROCESSING}
  try
    PreprocessedCodeEdit.Text := TFormulaCompilerRegistry.GetCompilerInstance(langDELPHI).PreprocessCode(CodeEdit.Text, FJITFormula);
  except
    on E: Exception do begin
      PreprocessedCodeEdit.Text := 'Error:'#13#10+E.Message;
    end;
  end;
  {$endif}
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
    SetValue(vtOption, 'Version', dtINT64, 9);
    SetValue(vtOption, 'DEscale', dtDouble, 1.0);
    SetValue(vtOption, 'SIpower' , dtDouble, 2.0);
    Code := 'procedure MyFormula(var x, y, z, w: Double; PIteration3D: TPIteration3D);' + #13#10 +
            'begin'+#13#10 +
            #13#10 +
            'end;'+#13#10;
  end;
end;

procedure TJITFormulaEditorForm.OptionAddBtnClick(Sender: TObject);
begin
  ParamValueEditFrm.Clear(mdNew);
  ParamValueEditFrm.WindowTitle := 'Add option value';
  if ParamValueEditFrm.ShowModal = mrOK then begin
    if FJITFormula.GetValue(vtOption, ParamValueEditFrm.Paramname) <> nil then
      raise Exception.Create('Option <'+ParamValueEditFrm.Paramname+'> already exists');
    FJITFormula.SetValue(vtOption, ParamValueEditFrm.Paramname, StrToJITValueDatatype(ParamValueEditFrm.TypeStr), ParamValueEditFrm.Value);
    PopulateList(OptionsList, vtOption);
    OptionsList.ItemIndex := OptionsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.OptionDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveValue(vtOption, OptionsList.ItemIndex);
  PopulateList(OptionsList, vtOption);
  if OptionsList.Items.Count > 0 then
    OptionsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.OptionEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  Pair: TNameValuePair;
begin
  ParamValueEditFrm.Clear(mdEdit);
  Idx := OptionsList.ItemIndex;
  if (Idx >= 0) then begin
    Pair := FJITFormula.GetValue(vtOption, Idx);
    ParamValueEditFrm.Paramname := Pair.Name;
    ParamValueEditFrm.TypeStr := JITValueDatatypeToStr( Pair.Datatype );
    ParamValueEditFrm.Value := Pair.Value;
    ParamValueEditFrm.WindowTitle := 'Edit option value';
    if (ParamValueEditFrm.ShowModal = mrOK) then begin
      Pair.Datatype := StrToJITValueDatatype(ParamValueEditFrm.TypeStr);
      Pair.Value := ParamValueEditFrm.Value;
      PopulateList(OptionsList, vtOption);
      OptionsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.OptionsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.OptionsListDblClick(Sender: TObject);
begin
  if OptionEditBtn.Enabled then
    OptionEditBtnClick(Sender);
end;

procedure TJITFormulaEditorForm.ParamAddBtnClick(Sender: TObject);
begin
  ParamValueEditFrm.Clear(mdNew);
  ParamValueEditFrm.WindowTitle := 'Add named param';
  if ParamValueEditFrm.ShowModal = mrOK then begin
    if FJITFormula.GetValue(vtParam, ParamValueEditFrm.Paramname) <> nil then
      raise Exception.Create('Param <'+ParamValueEditFrm.Paramname+'> already exists');
    FJITFormula.SetValue(vtParam, ParamValueEditFrm.Paramname, StrToJITValueDatatype(ParamValueEditFrm.TypeStr), ParamValueEditFrm.Value);
    PopulateList(ParamsList, vtParam);
    ParamsList.ItemIndex := ParamsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.ParamDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveValue(vtParam, ParamsList.ItemIndex);
  PopulateList(ParamsList, vtParam);
  if ParamsList.Items.Count > 0 then
    ParamsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.ParamEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  Pair: TNameValuePair;
begin
  ParamValueEditFrm.Clear(mdEdit);
  Idx := ParamsList.ItemIndex;
  if (Idx >= 0) then begin
    Pair := FJITFormula.GetValue(vtParam, Idx);
    ParamValueEditFrm.Paramname := Pair.Name;
    ParamValueEditFrm.TypeStr := JITValueDatatypeToStr( Pair.Datatype );
    ParamValueEditFrm.Value := Pair.Value;
    ParamValueEditFrm.WindowTitle := 'Edit named param';
    if (ParamValueEditFrm.ShowModal = mrOK) then begin
      Pair.Datatype := StrToJITValueDatatype(ParamValueEditFrm.TypeStr);
      Pair.Value := ParamValueEditFrm.Value;
      PopulateList(ParamsList, vtParam);
      ParamsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.ParamsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.ParamsListDblClick(Sender: TObject);
begin
  if ParamEditBtn.Enabled then
    ParamEditBtnClick(Sender);
end;

procedure TJITFormulaEditorForm.ConstantDeleteBtnClick(Sender: TObject);
begin
  FJITFormula.RemoveValue(vtConst, ConstantsList.ItemIndex);
  PopulateList(ConstantsList, vtConst);
  if ConstantsList.Items.Count > 0 then
    ConstantsList.ItemIndex := 0;
  EnableControls;
end;

procedure TJITFormulaEditorForm.ConstantEditBtnClick(Sender: TObject);
var
  Idx: Integer;
  Pair: TNameValuePair;
begin
  ParamValueEditFrm.Clear(mdEdit);
  Idx := ConstantsList.ItemIndex;
  if (Idx >= 0) then begin
    Pair := FJITFormula.GetValue(vtConst, Idx);
    ParamValueEditFrm.Paramname := Pair.Name;
    ParamValueEditFrm.TypeStr := JITValueDatatypeToStr( Pair.Datatype );
    ParamValueEditFrm.Value := Pair.Value;
    ParamValueEditFrm.WindowTitle := 'Edit named constant value';
    if (ParamValueEditFrm.ShowModal = mrOK) then begin
      Pair.Datatype := StrToJITValueDatatype(ParamValueEditFrm.TypeStr);
      Pair.Value := ParamValueEditFrm.Value;
      PopulateList(ConstantsList, vtConst);
      ConstantsList.ItemIndex := Idx;
      EnableControls;
    end;
  end;
end;

procedure TJITFormulaEditorForm.ConstantAddBtnClick(Sender: TObject);
begin
  ParamValueEditFrm.Clear(mdNew);
  ParamValueEditFrm.WindowTitle := 'Add named constant value';
  if ParamValueEditFrm.ShowModal = mrOK then begin
    if FJITFormula.GetValue(vtConst, ParamValueEditFrm.Paramname) <> nil then
      raise Exception.Create('Constant <'+ParamValueEditFrm.Paramname+'> already exists');
    FJITFormula.SetValue(vtConst, ParamValueEditFrm.Paramname, StrToJITValueDatatype(ParamValueEditFrm.TypeStr), ParamValueEditFrm.Value);
    PopulateList(ConstantsList, vtConst);
    ConstantsList.ItemIndex := ConstantsList.Items.Count - 1;
    EnableControls;
  end;
end;

procedure TJITFormulaEditorForm.ConstantsListClick(Sender: TObject);
begin
  EnableControls;
end;

procedure TJITFormulaEditorForm.ConstantsListDblClick(Sender: TObject);
begin
  if ConstantEditBtn.Enabled then
    ConstantEditBtnClick(Sender);
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
  if not LoadCustomFormula(Filename, CustomFormula, CustomFname, dOptionVtmp, False, 0, FJITFormula, True) then
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
const
  MaxVars = 32;
  MaxConsts = 32;
var
  CompiledFormula: TCompiledArtifact;
  pCodePointer: ThybridIteration2;
  IterationExt: TPIteration3Dext;
  X, Y, Z, W: Double;
  Vars: Pointer;

  procedure FillIterationExt(const VarPointer: Pointer);
  begin
    // Assign different values to each properties for easier testing if all values are
    // transfered correctly and all sizes are set correct
    IterationExt^.J4 := 0.1;
    IterationExt^.Rold := 0.2;
    IterationExt^.RStopD := 0.3;
    IterationExt^.x := 0.4;
    IterationExt^.y := 0.5;
    IterationExt^.z := 0.6;
    IterationExt^.w := 0.7;
    IterationExt^.C1 := 08;
    IterationExt^.C2 := 0.9;
    IterationExt^.C3 := 1.0;
    IterationExt^.J1 := 1.1;
    IterationExt^.J2 := 1.2;
    IterationExt^.J3 := 1.3;
    IterationExt^.PVar := Pointer( Integer(Vars) - MaxVars * SizeOf(Double) );
    IterationExt^.SmoothItD := 1.4;
    IterationExt^.Rout := 1.5;
    IterationExt^.ItResultI := 1600;
    IterationExt^.maxIt := 1700;
    IterationExt^.RStop := 1.8;
    IterationExt^.nHybrid[0] := 1900;
    IterationExt^.nHybrid[1] := 2000;
    IterationExt^.nHybrid[2] := 2100;
    IterationExt^.nHybrid[3] := 2200;
    IterationExt^.nHybrid[4] := 2300;
    IterationExt^.nHybrid[5] := 2400;
    IterationExt^.fHPVar[0] := Pointer(2500);
    IterationExt^.fHPVar[1] := Pointer(2600);
    IterationExt^.fHPVar[2] := Pointer(2700);
    IterationExt^.fHPVar[3] := Pointer(2800);
    IterationExt^.fHPVar[4] := Pointer(2900);
    IterationExt^.fHPVar[5] := Pointer(3000);
    IterationExt^.fHybrid[0] := Pointer(3100);
    IterationExt^.fHybrid[1] := Pointer(3200);
    IterationExt^.fHybrid[2] := Pointer(3300);
    IterationExt^.fHybrid[3] := Pointer(3400);
    IterationExt^.fHybrid[4] := Pointer(3500);
    IterationExt^.fHybrid[5] := Pointer(3600);
    IterationExt^.CalcSIT := True;
    IterationExt^.bFree := 1;
    IterationExt^.EndTo := 3700;
    IterationExt^.DoJulia := True;
    IterationExt^.LNRStop := 3.8;
    IterationExt^.DEoption := 3900;
    IterationExt^.fHln[0] := 4.0;
    IterationExt^.fHln[1] := 4.1;
    IterationExt^.fHln[2] := 4.2;
    IterationExt^.fHln[3] := 4.3;
    IterationExt^.fHln[4] := 4.4;
    IterationExt^.fHln[5] := 4.5;
    IterationExt^.iRepeatFrom := 4600;
    IterationExt^.iStartFrom := 4700;
    IterationExt^.OTrap := 4.8;
    IterationExt^.VaryScale := 4.9;
    IterationExt^.bFirstIt := 5000;
    IterationExt^.bTmp := 5100;
    IterationExt^.Dfree1 := 5.2;
    IterationExt^.Dfree2 := 5.3;
    IterationExt^.Deriv1 := 5.4;
    IterationExt^.Deriv2 := 5.5;
    IterationExt^.Deriv3 := 5.6;
    IterationExt^.SMatrix4[0][0] := 5.7;
    IterationExt^.SMatrix4[0][1] := 5.8;
    IterationExt^.SMatrix4[0][2] := 5.9;
    IterationExt^.SMatrix4[1][0] := 6.0;
    IterationExt^.SMatrix4[1][1] := 6.1;
    IterationExt^.SMatrix4[1][2] := 6.2;
    IterationExt^.SMatrix4[2][0] := 6.3;
    IterationExt^.SMatrix4[2][1] := 6.4;
    IterationExt^.SMatrix4[2][2] := 6.5;
    IterationExt^.Ju1 := 6.6;
    IterationExt^.Ju2 := 6.7;
    IterationExt^.Ju3 := 6.8;
    IterationExt^.Ju4 := 6.9;
    IterationExt^.PMapFunc := Pointer(7000);
    IterationExt^.PMapFunc2 := Pointer(7100);
    IterationExt^.pInitialization[0] := Pointer(7200);
    IterationExt^.pInitialization[1] := Pointer(7300);
    IterationExt^.pInitialization[2] := Pointer(7400);
    IterationExt^.pInitialization[3] := Pointer(7500);
    IterationExt^.pInitialization[4] := Pointer(7600);
    IterationExt^.pInitialization[5] := Pointer(7700);
    IterationExt^.bIsInsideRender := True;
    IterationExt^.OTrapMode := 7800;
    IterationExt^.OTrapDE := 7.9;
  end;

begin
  Result := False;
  try
    FJITFormula.Code := CodeEdit.Text;
    CompiledFormula := TFormulaCompilerRegistry.GetCompilerInstance(langDELPHI).CompileFormula( FJITFormula );
    try
      if CompiledFormula.IsValid then begin
        ThybridIteration2(pCodePointer) := CompiledFormula.CodePointer;
        X := 0.0;
        Y := 0.0;
        Z := 0.0;
        W := 0.0;
        GetMem(IterationExt, SizeOf(TIteration3Dext));
        try
          GetMem(Vars, (MaxVars + MaxConsts) * SizeOf(Double));
          try
            FillIterationExt(Vars);
            pCodePointer(X, Y, Z, W, TPIteration3D(Integer(IterationExt) + 56));
          finally
            FreeMem(Vars);
          end;
        finally
          FreeMem(IterationExt);
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

procedure TJITFormulaEditorForm.WMEnterSizeMove(var Message: TMessage);
begin
  Self.DisableAlign;
end;

procedure TJITFormulaEditorForm.WMExitSizeMove(var Message: TMessage);
begin
  Self.EnableAlign;
end;

end.


