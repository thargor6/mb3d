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
    Panel5: TPanel;
    Label1: TLabel;
    FormulanameEdit: TEdit;
    OptionsPnl: TPanel;
    Panel9: TPanel;
    Label2: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    OptionDeleteBtn: TSpeedButton;
    OptionAddBtn: TSpeedButton;
    OptionEditBtn: TSpeedButton;
    Panel12: TPanel;
    OptionsList: TListBox;
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
    Panel6: TPanel;
    Panel8: TPanel;
    CompileBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    Panel21: TPanel;
    LoadFormulaBtn: TSpeedButton;
    InfoMemo: TMemo;
    MainPageControl: TPageControl;
    CodeSheet: TTabSheet;
    CodePnl: TPanel;
    CodeEdit: TRichEdit;
    DescriptionSheet: TTabSheet;
    Panel7: TPanel;
    DescriptionEdit: TRichEdit;
    PreprocessedCodeSheet: TTabSheet;
    Panel22: TPanel;
    PreprocessedCodeEdit: TRichEdit;
    SupportedFunctionsSheet: TTabSheet;
    Panel23: TPanel;
    SupportedFunctionsEdit: TRichEdit;
    OpenDialog: TOpenDialog;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ScriptEditorForm: TScriptEditorForm;

implementation

uses Mand, DOF, DivUtils, ImageProcess, DoubleSize, CalcPart, HeaderTrafos,
 CalcMonteCarlo, CalcSR, Math3D, Tiling, LightAdjust, FileHandling;

{$R *.dfm}



end.


