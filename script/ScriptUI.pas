unit ScriptUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TypeDefinitions, ComCtrls, Vcl.ImgList,
  Vcl.Buttons;

type
  TScriptEditorForm = class(TForm)
    Panel1: TPanel;
    CancelAndExitBtn: TButton;
    SaveAndExitBtn: TButton;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    RunBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    Panel21: TPanel;
    LoadFormulaBtn: TSpeedButton;
    InfoMemo: TMemo;
    MainPageControl: TPageControl;
    CodeSheet: TTabSheet;
    CodePnl: TPanel;
    CodeEdit: TRichEdit;
    SupportedFunctionsSheet: TTabSheet;
    Panel23: TPanel;
    SupportedFunctionsEdit: TRichEdit;
    OpenDialog: TOpenDialog;
    CompileBtn: TSpeedButton;
    procedure CompileBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure Compile( const DoRun: Boolean );
    procedure ShowInfoMsg(const Msg: String);
    procedure ShowError(const Msg: String);
  public
    { Public-Deklarationen }
  end;

var
  ScriptEditorForm: TScriptEditorForm;

implementation

uses Mand, Math3D, FileHandling, ScriptCompiler, CompilerUtil, DateUtils;

{$R *.dfm}

procedure TScriptEditorForm.Compile( const DoRun: Boolean );
var
  CompiledFormula: TCompiledArtifact;
  T0, T1: Longint;
begin
  try
    CompiledFormula := TScriptCompilerRegistry.GetCompilerInstance(langDELPHI).CompileScript( CodeEdit.Text );
    try
      if CompiledFormula.IsValid then begin
        if DoRun then begin
{$ifdef USE_PAX_COMPILER}
          try
            T0 := DateUtils.MilliSecondsBetween(Now, 0);
            TPaxCompiledScript( CompiledFormula ).PaxProgram.Run;
            T1 := DateUtils.MilliSecondsBetween(Now, 0);
            ShowInfoMsg('Script executed in ' + FloatToStr((T1-T0)/1000.0)+' s');
          except
            on E: Exception do begin
              ShowError( E.Message );
            end;
          end;
{$endif}
        end
        else
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

procedure TScriptEditorForm.ShowInfoMsg(const Msg: String);
begin
  InfoMemo.Lines.Append(Msg);
end;

procedure TScriptEditorForm.CompileBtnClick(Sender: TObject);
begin
  Compile( False );
end;

procedure TScriptEditorForm.RunBtnClick(Sender: TObject);
begin
  Compile( True );
end;

procedure TScriptEditorForm.ShowError(const Msg: String);
begin
  MessageDlg(Msg, mtInformation, [mbOK], 0);
end;

end.


