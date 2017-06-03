unit Mand;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, CalcThread, Buttons, LightAdjust,
  AmbShadowCalcThreadN, PaintThread, FileHandling, Math3D, SHFolder,
  TypeDefinitions, Menus, Vcl.ExtDlgs, M3Iregister;

type
  TqualPreset = packed record
    SmoothNormals: Integer;
    DEstop: Double;
    RayMultiplier: Single;
    BinSearch: Integer;
    ImageWidth: Integer;
    ImageScale: Integer;
    RayLimiter: Single;
  end;
  TMand3DForm = class(TForm)
    Panel1: TPanel;
    Timer1: TTimer;
    Panel2: TPanel;
    Timer3: TTimer;
    Timer4: TTimer;
    SaveDialog2: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Shape1: TShape;
    SaveDialog3: TSaveDialog;
    SpeedButton4: TSpeedButton;
    Label20: TLabel;
    ProgressBar1: TProgressBar;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Label16: TLabel;
    Label18: TLabel;
    Label22: TLabel;
    TabSheet4: TTabSheet;
    Label15: TLabel;
    Label13: TLabel;
    Panel4: TPanel;
    Image2: TImage;
    Label3: TLabel;
    Label17: TLabel;
    TabSheet5: TTabSheet;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    ComboBox2: TComboBox;
    TabSheet8: TTabSheet;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Timer8: TTimer;
    Edit25: TEdit;
    Button3: TSpeedButton;
    Button8: TSpeedButton;
    Button4: TSpeedButton;
    Button9: TSpeedButton;
    Button5: TSpeedButton;
    Panel5: TPanel;
    Label19: TLabel;
    SBsaveJPEG: TSpeedButton;
    Edit26: TEdit;
    SaveDialog4: TSaveDialog;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton10: TSpeedButton;
    TabSheet9: TTabSheet;
    CheckBox7: TCheckBox;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Button13: TButton;
    Label51: TLabel;
    Label52: TLabel;
    SpeedButton12: TSpeedButton;
    CheckBox9: TCheckBox;
    Edit4: TEdit;
    SpeedButton15: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Label1: TLabel;
    PositionPnl: TPanel;
    RotationPnl: TPanel;
    Memo1: TMemo;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    Label4: TLabel;
    Label6: TLabel;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox1: TCheckBox;
    Edit6: TEdit;
    TabSheet1: TTabSheet;
    Label21: TLabel;
    Edit14: TEdit;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SaveDialog6: TSaveDialog;
    CheckBox3: TCheckBox;
    SpeedButton24: TSpeedButton;
    CheckBox8: TCheckBox;
    TabSheet3: TTabSheet;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Edit2: TEdit;
    Label14: TLabel;
    Edit7: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Edit8: TEdit;
    TabSheet6: TTabSheet;
    Label28: TLabel;
    Edit15: TEdit;
    Label35: TLabel;
    Edit18: TEdit;
    Label27: TLabel;
    Edit13: TEdit;
    Label36: TLabel;
    Button12: TButton;
    Button16: TButton;
    Button17: TButton;
    PopupMenu1: TPopupMenu;
    N111: TMenuItem;
    N12aa1: TMenuItem;
    N13aa1: TMenuItem;
    N141: TMenuItem;
    N151: TMenuItem;
    N161: TMenuItem;
    N171: TMenuItem;
    N181: TMenuItem;
    N191: TMenuItem;
    N1101: TMenuItem;
    CheckBox10: TCheckBox;
    PageControl2: TPageControl;
    TabSheet7: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    GroupBox2: TGroupBox;
    CheckBox11: TCheckBox;
    Label12: TLabel;
    SpeedButton27: TSpeedButton;
    CheckBox12: TCheckBox;
    SpeedButton28: TSpeedButton;
    SaveDialog1: TSaveDialog;
    SpeedButton29: TSpeedButton;
    Button19: TButton;
    Button20: TButton;
    Label34: TLabel;
    Label40: TLabel;
    PopupMenu2: TPopupMenu;
    Stickthiswindowtotherightside1: TMenuItem;
    Stickthiswindowtotheleftside1: TMenuItem;
    Donotmakethiswindowsticky1: TMenuItem;
    Label41: TLabel;
    CheckBox13: TCheckBox;
    Label42: TLabel;
    PopupMenu3: TPopupMenu;
    StartrenderingandsaveafterwardstheM3Ifile1: TMenuItem;
    CheckBox14: TCheckBox;
    TabSheet13: TTabSheet;
    IniDirsBtn: TSpeedButton;
    CheckBox15: TCheckBox;
    Edit16: TEdit;
    Label47: TLabel;
    Label48: TLabel;
    Timer2: TTimer;
    SpeedButton35: TSpeedButton;
    RadioGroup2: TRadioGroup;
    Button1: TButton;
    Button6: TButton;
    Edit19: TEdit;
    SpinEdit2: TUpDown;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Edit20: TEdit;
    SpinEdit5: TUpDown;
    Edit21: TEdit;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    CheckBox2: TCheckBox;
    CheckBox16: TCheckBox;
    Label49: TLabel;
    Label50: TLabel;
    Panel6: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Button2: TButton;
    Button10: TButton;
    Button15: TButton;
    Button11: TButton;
    Button18: TButton;
    Label60: TLabel;
    Edit33: TEdit;
    Label59: TLabel;
    Edit34: TEdit;
    ButtonAuthor: TButton;
    ButtonInsertAuthor: TButton;
    Timer5: TTimer;
    Label58: TLabel;
    Edit35: TEdit;
    Shape2: TShape;
    PopupMenu4: TPopupMenu;
    ShapeDisc1: TMenuItem;
    ShapeBox1: TMenuItem;
    Timer6: TTimer;
    ButtonVolLight: TButton;
    UpDown5: TUpDown;
    Label61: TLabel;
    MeshExportBtn: TSpeedButton;
    MutaGenBtn: TSpeedButton;
    MapSequencesBtn: TSpeedButton;
    VisualThemesBtn: TSpeedButton;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    SpeedButton32: TSpeedButton;
    Edit17: TEdit;
    SpeedButton33: TSpeedButton;
    Edit1: TEdit;
    SpeedButton34: TSpeedButton;
    Edit3: TEdit;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    Edit5: TEdit;
    Label5: TLabel;
    Button7: TButton;
    ButtonR0: TButton;
    Edit27: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    PositionBtn: TSpeedButton;
    RotationBtn: TSpeedButton;
    Panel7: TPanel;
    Label46: TLabel;
    FrameEdit: TEdit;
    FrameUpDown: TUpDown;
    ScriptBtn: TSpeedButton;
    HeightMapGenBtn: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer8Timer(Sender: TObject);
    procedure SBsaveJPEGClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IniDirsBtnClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton21MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit11Change(Sender: TObject);
    procedure SpeedButton18MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton25Click(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton26Click(Sender: TObject);
    procedure SaveDialog6TypeChange(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Stickthiswindowtotherightside1Click(Sender: TObject);
    procedure Button2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StartrenderingandsaveafterwardstheM3Ifile1Click(
      Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox14Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton35Click(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N11Click(Sender: TObject);
    procedure SpinEdit2ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Integer; Direction: TUpDownDirection);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure SpinButton2DownClick(Sender: TObject);
    procedure SpinButton2UpClick(Sender: TObject);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure Button7Click(Sender: TObject);
    procedure ButtonR0Click(Sender: TObject);
    procedure Edit33Change(Sender: TObject);
    procedure Edit34Change(Sender: TObject);
    procedure ButtonAuthorClick(Sender: TObject);
    procedure ButtonInsertAuthorClick(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure Shape2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Shape2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShapeBox1Click(Sender: TObject);
    procedure ShapeDisc1Click(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
    procedure ButtonVolLightClick(Sender: TObject);
    procedure UpDown5Click(Sender: TObject; Button: TUDBtnType);
    procedure MutaGenBtnClick(Sender: TObject);
    procedure VisualThemesBtnClick(Sender: TObject);
    procedure MapSequencesBtnClick(Sender: TObject);
    procedure PositionBtnClick(Sender: TObject);
    procedure RotationBtnClick(Sender: TObject);
    procedure FrameUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FrameEditExit(Sender: TObject);
    procedure MeshExportBtnClick(Sender: TObject);
    procedure ScriptBtnClick(Sender: TObject);
    procedure HeightMapGenBtnClick(Sender: TObject);
 //   procedure OpenPictureDialog1SelectionChange(Sender: TObject);
//    procedure PageControl1DrawTab(Control: TCustomTabControl; TabIndex: Integer;
  //    const Rect: TRect; Active: Boolean);
  private
    { Private-Deklarationen }
    isRepainting: LongBool;
    MStartPos: TPoint;
    MXYStartPos: TPoint;
    MOrigStartPos: TPoint;
    SliceCalc: Integer;
    MZtranslate, MmaxShapeWid: Integer;
    notAllButtonsUp: LongBool;
    RepaintYact: Integer;
    CloseTries: Integer;
    StartupLoadM3I: LongBool;
    bUserChange: LongBool;
    bImageText: LongBool;
    TFSB9E, TFSB9Echecked: LongBool;
    StickIt: Integer;
    FNoSetFocus: Boolean;
  //  lastCP: TPoint;
    procedure RepaintMand3D(bStartTimer: LongBool);
    procedure CalcStatistic;
    procedure DisableBchange;
    procedure EnableBchange;
    procedure WMDROPFILES(var Msg: TMessage); message WM_DROPFILES;
    procedure SetPreset(ip: Integer);
    procedure FillInPreset(ip: Integer);
    procedure DoSaveAniImage;
    procedure DoSaveTileImage;
    procedure Rotate4Dvec(var vec: TVec4D);
    procedure ScaleDEstop(s: Single);
    procedure ScaleRclip(s: Single);
    function  OverImage(p: TPoint): LongBool;
    procedure SendMove;
    procedure WaitForPaintStop(maxSeconds: Integer);
    procedure SaveImageO(OutputType: Integer; FileNam: String);
    procedure UpdateScaledImageFull;
    procedure SetEulerEditsFromHeader;
    procedure FirstShowUpdate;
    procedure SetM3Dini;
    procedure LoadStartupParas;
    procedure ModColOnImage(X, Y: Integer);
    procedure SetShape2Size(NewSize: Integer);
    procedure TriggerRepaintDraw(R: TRect);
    procedure SetEdit16Text;
    procedure SaveCurrParamAsM3P( const Filename: String );
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    MHeader: TMandHeader10;
    MCalcThreadStats: TCalcThreadStats;
    siLight5: array of TsiLight5;
    mSLoffset: Integer;
 //   bLightFormStick: Integer;
    bAniFormStick: Integer;
  //  bFGUIFormStick: Integer;
   // bPostProcessFormStick: Integer;
    SaveAniImage: LongBool;
    SaveTileImage: LongBool;
   // calc3D: LongBool;
 //   bAllowUpDownChange: LongBool;
 //   CalcStereoImage: LongBool;
    HeaderLightVals: TLightVals;
    HybridCustoms: array[0..5] of TCustomFormula;
    HAddOn: THeaderCustomAddon;
    iActiveThreads: Integer;  //for triggering the timer
    iActivePaintThreads: Integer;
    iGetPosFromImage: Integer;
    UserAspect: TPoint;
    PaintVGrads: TMatrix3;
    CalcStart: Cardinal;
    CalcYact: Integer;
    mCalcRect: TRect;
    SSAORiteration: Integer;
    SaveM3IfileAuto: LongBool;
    InternAspect: Double;
    SaveAutoM3Ifilename: String;
    OPD: TOpenPictureDialogM3D;
    Authors: AuthorStrings;
    bOutMessageLoud: LongBool;
    bHideMessages: LongBool;
    DrawColSIndex: Single;
    DrawInOutside: Integer;
    DrawRect: TRect;
    procedure OutMessage(s: String);
    procedure SetImageCursor;
    procedure AllPresetsUp;
    procedure EnableButtons;
    procedure DisableButtons;
    procedure IniMHeader;
    procedure MakeHeader;
    procedure CalcMand(bMakeHeader: LongBool);
    procedure CalcHardShadow;
    procedure SetEditsFromHeader;
    procedure WndProc(var Message: TMessage); override;
    procedure getI1BMPSLs;
    procedure MButtonsUp;
    procedure RepaintMand3DnoThread;
    procedure UpdateAspectCaption;
    function SizeOK(Verbose: LongBool): LongBool;
    procedure ClearScreen;
    procedure ParasChanged;
    procedure CalcAmbShadow;
    procedure SaveM3I(FileName: String; bSaveImgBuf: LongBool);
    procedure ProofPosLight;
    function GetCalcRect: TRect;
    procedure TextParsLoadSuccess;
    procedure UpdateAndScaleImageFull(NewScale: Integer);
    procedure RefreshNavigator(const Enabled: Boolean);
    function IsCalculating: Boolean;
    procedure PropagateCurrFrameNumber;
    property NoSetFocus: Boolean read FNoSetFocus write FNoSetFocus;

  end;
procedure TriggerRepaint;
function AniFileAlreadyExists(var s: String): LongBool;
procedure SaveFormulaBytes;

var
  Mand3DForm: TMand3DForm;
  M3dVersion: Single = 1.95;
  Testing: LongBool = False;
  TBoostChanged: LongBool = False;
  MCalcStop: LongBool = False;
  ImageScale: Integer = 1;
  fullSizeImage: array of Cardinal;    //intern FullSizeImage = colors, array of Cardinal
  mFSIstart, mFSIoffset: Integer;
  I1BMPstartSL, I1BMPoffset: Integer;
  FormsSticky: array[0..2] of Integer = (1, 1, 1);
  AppFolder: String = '';
  AppDataDir: String = '';
  M3DBackGroundPic: TLightMap;
  M3DSmallBGpic: TLightMap;
  bSRVolLightMapCalculated: LongBool = False;
  AccPreset: array[0..3] of TqualPreset =
  ((SmoothNormals: 0; DEstop: 1.0; RayMultiplier: 0.5; BinSearch: 6; ImageWidth: 480; ImageScale: 1; RayLimiter: 1),
   (SmoothNormals: 1; DEstop: 1.0; RayMultiplier: 0.4; BinSearch: 8; ImageWidth: 640; ImageScale: 1; RayLimiter: 0.75),
   (SmoothNormals: 2; DEstop: 1.2; RayMultiplier: 0.3; BinSearch: 10; ImageWidth: 1600; ImageScale: 2; RayLimiter: 0.5),
   (SmoothNormals: 3; DEstop: 1.2; RayMultiplier: 0.25; BinSearch: 12; ImageWidth: 3072; ImageScale: 3; RayLimiter: 0.3));

implementation

uses Math, DivUtils, ImageProcess, ClipBrd, ShellAPI, FileCtrl, formulas,
     CalcThread2D, CustomFormulas, Animation, AniPreviewWindow, Maps,
     HeaderTrafos, Calc, IniDirsForm, FormulaGUI, Navigator, PostProcessForm,
     DOF, CalcHardShadow, AmbHiQ, BatchForm, Undo, CommDlg, VoxelExport,
     calcBlocky, CalcSR, Tiling, MonteCarloForm, TextBox, pngimage, ColorPick,
     uMapCalcWindow, FormulaCompiler, MutaGenGUI, VisualThemesGUI, Vcl.Themes,
     MapSequencesGUI, MapSequences, BulbTracerUI, ScriptUI, HeightMapGenUI;

{$R *.dfm}

function TMand3DForm.GetCalcRect: TRect;
var //TileRect: TRect;
    Crop: Integer;
begin
    if MHeader.TilingOptions <> 0 then
      GetTilingInfosFromHeader(@MHeader, Result, Crop)
 //     Result := TileRect;
  //    Result := TilingForm.brCalcRect
    else
      Result := Rect(0, 0, MHeader.Width - 1, MHeader.Height - 1);
end;

procedure TMand3DForm.UpdateAndScaleImageFull(NewScale: Integer);
begin
    NewScale := Min(10, Max(1, NewScale));
    if NewScale <> ImageScale then
    begin
      ImageScale := NewScale;
      bUserChange := False;
      SetImageSize;
      bUserChange := True;
    end;
    UpdateScaledImage(0, (MHeader.Height - 1) div ImageScale);
end;

procedure TMand3DForm.UpdateScaledImageFull;
begin
    UpdateScaledImage(0, (MHeader.Height - 1) div ImageScale);
end;

procedure TMand3DForm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var i: Integer;
begin
    if bUserChange then
    begin
      i := 0;
      if Button = btNext then i := Min(10, UpDown1.Position + 1) else
      if Button = btPrev then i := Max(1, UpDown1.Position - 1);
      if i <> 0 then
      begin
        ImageScale := 11 - i;
        MHeader.bImageScale := ImageScale;
        bUserChange := False;
        SetImageSize;
        bUserChange := True;
        UpdateScaledImageFull;
      end;
    end;
end;

procedure TMand3DForm.UpDown2Click(Sender: TObject; Button: TUDBtnType);
var b: LongBool;
begin
    DisableTiling(@MHeader);
    b := bUserChange;
    bUserChange := False;
    if Button = btPrev then
    begin
      MHeader.Width := MHeader.Width div 2;
      MHeader.Height := MHeader.Height div 2;
      ScaleDEstop(0.5);
      ScaleRclip(0.5);
    end
    else if Button = btNext then
    begin
      MHeader.Width := MHeader.Width * 2;
      MHeader.Height := MHeader.Height * 2;
      ScaleDEstop(2);
      ScaleRclip(2);
    end;
    Edit11.Text := IntToStr(MHeader.Width);
    Edit12.Text := IntToStr(MHeader.Height);
    bUserChange := b;
end;

procedure TMand3DForm.UpDown4Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btPrev then
    begin
      if Label23.Caption <> '0' then Label23.Caption := IntToStr(StrToInt(Label23.Caption) - 1);
    end
    else if Button = btNext then
    begin
      if Label23.Caption <> '3' then Label23.Caption := IntToStr(StrToInt(Label23.Caption) + 1);
    end;
    IniVal[13] := Label23.Caption;
end;

procedure TMand3DForm.UpDown5Click(Sender: TObject; Button: TUDBtnType);
var i: Integer;
begin
    i := UpDown5.Position;
    if (Button = btNext) and (i < 9) then Inc(i) else
    if (Button = btPrev) and (i > -2) then Dec(i);
    if i > 0 then Label61.Caption := '+' + IntToStr(i)
             else Label61.Caption := IntToStr(i);
end;

procedure TMand3DForm.FrameEditExit(Sender: TObject);
begin
  PropagateCurrFrameNumber;
  LightAdjustForm.SpinEdit1Change(Sender);
end;

procedure TMand3DForm.FrameUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  Frame: Integer;
begin
  if FrameEdit.Text<>'' then begin
    Frame := StrToInt( FrameEdit.Text );
    if (Button = btNext) then
      FrameEdit.Text := IntToStr( Frame + 1 )
    else
      FrameEdit.Text := IntToStr( Max(1, Frame - 1) );
  end;
  PropagateCurrFrameNumber;
  LightAdjustForm.SpinEdit1Change(Sender);
end;

procedure TMand3DForm.VisualThemesBtnClick(Sender: TObject);
begin
  VisualThemesFrm.Visible := True;
end;

procedure TMand3DForm.ScaleDEstop(s: Single);
var d: Double;
begin
    if CheckBox11.Checked then
    begin
      if StrToFloatKtry(Edit25.Text, d) then
        Edit25.Text := FloatToStrSingle(d * s)
      else
        Edit25.Text := FloatToStrSingle(MHeader.sDEstop * s);
    end;
end;

procedure TMand3DForm.ScaleRclip(s: Single);
var d: Double;
begin
    if PPFormCreated and CheckBox11.Checked then
    begin                         
      if StrToFloatKtry(PostProForm.Edit2.Text, d) then
        PostProForm.Edit2.Text := FloatToStrSingle(d * s)
      else
        PostProForm.Edit2.Text := FloatToStrSingle(MHeader.sDOFclipR * s);
    end;
end;

procedure TMand3DForm.ScriptBtnClick(Sender: TObject);
begin
  ScriptEditorForm.Visible := True;
  BringToFront2(ScriptEditorForm.Handle);
end;

procedure TMand3DForm.ParasChanged;
begin
    Image1.Picture.Bitmap.Canvas.TextOut(8, 16, 'Press ''Calculate 3D'' to render');
    bImageText := True;
end;

procedure TMand3DForm.PositionBtnClick(Sender: TObject);
begin
  PositionPnl.Top := PositionBtn.Top+PositionBtn.Height;
  PositionPnl.Visible := not PositionPnl.Visible;
end;

procedure TriggerRepaint;
begin
    if (not AFormCreated) or (AnimationForm.AniOption <= 0) then
    begin
      Inc(RepaintCounter);
      Mand3DForm.Timer3.Enabled := True;
      LightAdjustForm.ComboBox3.Font.Color := clGrayText;
    end;
end;

procedure TMand3DForm.TriggerRepaintDraw(R: TRect);
begin
    if AFormCreated and (AnimationForm.AniOption > 0) then Exit;
    DrawRect.Top := Min(DrawRect.Top, R.Top);
    DrawRect.Left := Min(DrawRect.Left, R.Left);
    DrawRect.Right := Max(DrawRect.Right, R.Right);
    DrawRect.Bottom := Max(DrawRect.Bottom, R.Bottom);
    Timer6.Enabled := True;
 //   PaintRect(DrawRect);
end;

procedure TMand3DForm.ClearScreen;
begin
    Image1.Picture.Bitmap.Canvas.FillRect(Image1.Picture.Bitmap.Canvas.ClipRect);
    ParasChanged;
end;

procedure TMand3DForm.OutMessage(s: String);
begin
  if not bHideMessages then begin
    if bOutMessageLoud then ShowMessage(s) else
    begin
      while Memo1.Lines.Count > 15 do Memo1.Lines.Delete(0);
      Memo1.Lines.Add(s);
    end;
  end;
end;

procedure TMand3DForm.WmThreadReady(var Msg: TMessage);
var sr, er: Integer;
begin
    if Msg.LParam = 222 then  //PaintRows thread finished
    begin
      sr := Msg.WParam and $FFFF;
      er := Msg.WParam shr 16;
      UpdateScaledImage(sr div ImageScale, er div ImageScale);   //tiling?
      if (DrawRect.Top = sr) and (DrawRect.Bottom = er) then
        DrawRect := Rect(MHeader.Width, MHeader.Height, 0, 0);
    end
    else if Msg.LParam = 3 then
    begin
      Dec(iActivePaintThreads);
      if iActivePaintThreads = 0 then Timer8.Interval := 5;
    end   
    else if Msg.LParam = 0 then
    begin
      Dec(iActiveThreads);
      if iActiveThreads = 0 then Timer4.Interval := 5;
    end
    else if Msg.LParam = 66 then OutMessage('Not enough memory, DoF aborted.')
    else if Msg.LParam = 67 then ProgressBar1.Position := Msg.WParam;
end;

procedure TMand3DForm.FillInPreset(ip: Integer);
begin
    AccPreset[ip].SmoothNormals := SpinEdit2.Position;
    AccPreset[ip].DEstop        := StrToFloatK(Edit25.Text);
    AccPreset[ip].RayMultiplier := StrToFloatK(Edit6.Text);
    AccPreset[ip].BinSearch     := SpinEdit5.Position;
    AccPreset[ip].ImageScale    := ImageScale;
    AccPreset[ip].ImageWidth    := StrToIntTrim(Edit11.Text);
    AccPreset[ip].RayLimiter    := StrToFloatK(Edit8.Text);
end;

procedure TMand3DForm.SetPreset(ip: Integer);
var w: Integer;
begin
    DisableBchange;
    SpinEdit2.Position := AccPreset[ip].SmoothNormals;
    Edit25.Text     := FloatToStrSingle(AccPreset[ip].DEstop);
    Edit6.Text      := FloatToStrSingle(AccPreset[ip].RayMultiplier);
    Edit8.Text      := FloatToStrSingle(AccPreset[ip].RayLimiter);
    SpinEdit5.Position := AccPreset[ip].BinSearch;
    ImageScale      := Max(1, Min(5, AccPreset[ip].ImageScale));
    w               := StrToIntTrim(Edit11.Text);
    bUserChange     := False;
    Edit11.Text     := IntToStr(AccPreset[ip].ImageWidth);
    Edit12.Text     := IntToStr((StrToIntTrim(Edit12.Text) * AccPreset[ip].ImageWidth) div w);
    bUserChange     := True;
    SpeedButton35.Caption := '1:' + IntToStr(ImageScale);
    SetImageSize;
    UpdateScaledImageFull;
    EnableBchange;
end;

procedure TMand3DForm.WMDROPFILES(var Msg: TMessage);
var size, i: Integer;
    Dateiname: PChar;
    s, st: String;
    tf: TextFile;
    stream: TFileStream;
    sa: AnsiString;
    success: LongBool;
begin
    inherited;
    try
      Dateiname := '';
      DragQueryFile(Msg.WParam, $FFFFFFFF, Dateiname, 255);
      size      := DragQueryFile(Msg.WParam, 0, nil, 0) + 1;
      Dateiname := StrAlloc(size);
      DragQueryFile(Msg.WParam, 0, Dateiname, size);
      s := UpperCase(ExtractFileExt(StrPas(Dateiname)));
      if s = '.M3I' then
      begin
        LoadFullM3I(MHeader, StrPas(Dateiname));
        AllPresetsUp;
       // TriggerRepaint;
      end
      else if s = '.M3P' then
      begin
        LoadParameter(MHeader, StrPas(Dateiname), True);
        AllPresetsUp;
        OutMessage('Parameters loaded, press "Calculate 3D" to render.');
        ClearScreen;
      end
      else if s = '.M3A' then
      begin
        AniStartLoad := True;
        if AnimationForm.LoadAni(StrPas(Dateiname)) then
          AnimationForm.Visible := True;
      end
      else if s = '.BIG' then
      begin
        if TilingForm.LoadBig(StrPas(Dateiname)) then
          TilingForm.Visible := True;
      end
      else if s = '.PNG' then
      begin
        success := False;
        try
          stream := TFileStream.Create(StrPas(Dateiname), fmOpenRead);
        //  i := stream.Size - 1500;
          if stream.Size > 2500 then
          begin
            SetLength(sa, 2502);
          //  sa := StringOfChar(' ', 1502);
            stream.Seek(-2500, soEnd);
            stream.Read(sa[1], 2500);
            i := Pos('tEXtComment', sa);
            if i > 0 then
            begin
              Inc(i, 12);
              if Copy(sa, i, 12) = 'Mandelbulb3D' then
              begin
                sa := Copy(sa, i, 2500);
                if GetHeaderFromText(sa, MHeader, st) then
                begin
                  TextParsLoadSuccess;
                  success := True;
                  Caption := st;
                end;
              end;
            end;
          end;
        finally
          stream.Free;
          if not success then OutMessage('No text params found.');
        end;
      end
      else if s = '.TXT' then
      begin
        AssignFile(tf, StrPas(Dateiname));
        try
          Reset(tf);
          Readln(tf, s);
          i := 40;
          while (i > 0) and not EOF(tf) do
          begin
            Readln(tf, st);
            s := s + st;
            Dec(i);
          end;
          if GetHeaderFromText(s, MHeader, st) then
          begin
            TextParsLoadSuccess;
            Caption := st;
          end
          else OutMessage('No text params found.');
        finally
          CloseFile(tf);
        end;
      end;
    finally
      StrDispose(Dateiname);
      DragFinish(Msg.WParam);
    end;
end;

procedure TMand3DForm.AllPresetsUp;
begin
    SpeedButton3.Down  := False;
    SpeedButton13.Down := False;
    SpeedButton5.Down  := False;
    SpeedButton6.Down  := False;
end;

procedure TMand3DForm.WndProc(var Message: TMessage);
var xLDif, yDif: Integer;
begin
    if Message.Msg = WM_Move then  //if Message.MSg = WM_EndSession or...  Query..
    begin
      if AFormCreated then
      begin
        if bAniFormStick = 1 then
         AnimationForm.SetBounds(Left, Top + Height, AnimationForm.Width,
                                    AnimationForm.Height)
        else if AnimationForm.Visible then
        begin
          yDif  := Abs(AnimationForm.Top - Top - Height);
          if yDif < 17 then
          begin
            xLDif := Abs(AnimationForm.Left - Left);
            if xLDif < 17 then bAniFormStick := 1;
          end;
        end;
      end;
      if PPFormCreated then
      begin
        if FormsSticky[2] = 1 then
          PostProForm.SetBounds(Left + Width, Top, PostProForm.Width, PostProForm.Height)
        else if FormsSticky[2] = 2 then
          PostProForm.SetBounds(Left - PostProForm.Width, Top,
                                   PostProForm.Width, PostProForm.Height);
      end;
      if LAFormCreated then
      begin
        if FormsSticky[1] = 1 then
          LightAdjustForm.SetBounds(Left + Width, Top, LightAdjustForm.Width,
                                    LightAdjustForm.Height)
        else if FormsSticky[1] = 2 then
          LightAdjustForm.SetBounds(Left - LightAdjustForm.Width, Top,
                                   LightAdjustForm.Width, LightAdjustForm.Height);
      end;
      if FGUIFormCreated then
      begin
        if FormsSticky[0] = 1 then
          FormulaGUIForm.SetBounds(Left + Width, Top, FormulaGUIForm.Width,
                                   FormulaGUIForm.Height)
        else if FormsSticky[0] = 2 then
          FormulaGUIForm.SetBounds(Left - FormulaGUIForm.Width, Top,
                                   FormulaGUIForm.Width, FormulaGUIForm.Height);
      end;
    end;
    inherited WndProc(Message);
end;

procedure TMand3DForm.CalcAmbShadow;
var pw: PWord;
    x: Integer;
begin
    if not SizeOK(True) then Exit;
    DisableButtons;
    ProgressBar1.Max := MHeader.Height;
    ProgressBar1.Visible := True;
    MCalcThreadStats.pLBcalcStop := @MCalcStop;
    MCalcThreadStats.pMessageHwnd := Self.Handle;
    MCalcThreadStats.iProcessingType := 4;  //AP=8
    if (MHeader.bCalcAmbShadowAutomatic and 12) in [4, 8] then
    begin
      if (MHeader.bCalcAmbShadowAutomatic and 12) = 8 then
      begin
        pw := @siLight5[0];
        Inc(pw, 6); //ambshadow = +12 bytes
        if SSAORiteration = 0 then //set ambshadow to 0, will be accumulated during iterations
        begin
          for x := 1 to Length(siLight5) do
          begin
            pw^ := 0;
            Inc(pw, 9);
          end;
        end;
        Inc(SSAORiteration);
      end;
      if ((MHeader.bCalcAmbShadowAutomatic and 12) = 8) and (MHeader.SSAORcount > 1) then
        Label6.Caption := 'ambient shadow calculation ' + IntToStr(SSAORiteration) + ' of ' + IntToStr(MHeader.SSAORcount)
      else
        Label6.Caption := 'ambient shadow calculation';
      CalcAmbShadowTHiQ(@MHeader, @siLight5[0], @MCalcThreadStats, @ATlevelHiQ);
      iActiveThreads := 0;
      Timer4.Interval := 500;
      Timer4.Enabled := True;
    end
    else
    begin
      if CalcAmbShadowT(@MHeader, @siLight5[0], mSLoffset, @MCalcThreadStats, @ATrousWL, GetCalcRect) then
      begin
        iActiveThreads := MCalcThreadStats.iTotalThreadCount;
        if AnimationForm.AniOption > 0 then Timer4.Interval := 200 else
        Timer4.Interval := 500;
        CalcYact        := -1;
        Timer4.Enabled  := True;
        Label6.Caption  := 'ambient shadow calculation';
      end
      else
      begin
        EnableButtons;
        OutMessage('Error in ambient shadow calculation. Stopped.');
      end;
    end;
end;

procedure TMand3DForm.CalcHardShadow;
begin
    if not SizeOK(True) then Exit;
    MHeader.bCalc3D := 1;
    DisableButtons;
    ProgressBar1.Max := MHeader.Height;
    ProgressBar1.Visible := True;
    MCalcThreadStats.pLBcalcStop := @MCalcStop;
    MCalcThreadStats.pMessageHwnd := Self.Handle;
    MCalcThreadStats.iProcessingType := 3; //AP=4
    AssignLightVal(@HScalcHeaderLightVals, @HeaderLightVals);
    if CalcHardShadowT(@MHeader, @MCalcThreadStats, @siLight5[0], mSLoffset, @HScalcHeaderLightVals, True, GetCalcRect) then
    begin
      iActiveThreads  := MCalcThreadStats.iTotalThreadCount;
      Timer4.Interval := 500;
      CalcYact        := -1;
      Timer4.Enabled  := True;
      Label6.Caption  := 'hard shadow calculation';
    end
    else
    begin
      EnableButtons;
      OutMessage('Error in hard shadow calculation. Stopped.');
    end;
end;

procedure TMand3DForm.EnableButtons;
var P: TPoint;
begin
    Label6.Caption := '';
    Button2.Caption := 'Calculate 3D';
    Button2.Hint := 'Sart the main rendering of the image.';
    SpeedButton32.Enabled := True;
    SpeedButton33.Enabled := True;
    SpeedButton34.Enabled := True;
    Button1.Enabled := True;
    Button6.Enabled := True;
    Button5.Enabled := True;
    Button9.Enabled := True;
    Button11.Enabled := True;
    Button12.Enabled := True;
    SpeedButton8.Enabled := True;
    SpeedButton9.Enabled := (UndoCount > 1) or (RedoCount > 1);
    SpeedButton11.Enabled := True;
    SpeedButton16.Enabled := True;
    SpeedButton17.Enabled := True;
    SpeedButton18.Enabled := True;
    SpeedButton22.Enabled := True;
    SpeedButton23.Enabled := True;
    SpeedButton1.Enabled := True;
    SpeedButton2.Enabled := True;
    SpeedButton4.Enabled := True;
    IniDirsBtn.Enabled := True;
    MapSequencesBtn.Enabled := True;
    VisualThemesBtn.Enabled := True;
    if PPFormCreated then
    begin
      PostProForm.Button1.Enabled := True;
      PostProForm.Button2.Enabled := True;
      PostProForm.Button3.Enabled := True;
      PostProForm.Button4.Enabled := True;
      PostProForm.Button5.Enabled := True;
      PostProForm.Button6.Enabled := True;
      PostProForm.Button7.Enabled := True;
      PostProForm.Button8.Enabled := True;
      PostProForm.Button9.Enabled := True;
      PostProForm.Button10.Enabled := True;
      PostProForm.Button12.Enabled := True;
      PostProForm.Button14.Enabled := True;
      PostProForm.Button15.Enabled := True;
      PostProForm.Button16.Enabled := True;
      PostProForm.Button18.Enabled := True;
      PostProForm.CheckBox21.Enabled := True;
      PostProForm.CheckBox25.Enabled := True;
    end;
    if BatchFormCreated then
    begin
      BatchForm1.Button1.Enabled := True;
    end;
    if bTilingFormCreated then
    begin
      TilingForm.Button2.Enabled := TFSB9E;
      TilingForm.Button3.Enabled := True;
      TilingForm.SpeedButton1.Enabled := True;
      TilingForm.SpeedButton2.Enabled := True;
      TilingForm.SpeedButton9.Enabled := TFSB9E;
      TilingForm.SpeedButton11.Enabled := True;
      TilingForm.Panel2.Enabled := TFSB9E;
      TFSB9Echecked := False;
    end;
    if bVoxelFormCreated then
    begin
      FVoxelExport.Button3.Enabled := True;
      FVoxelExport.SpeedButton11.Enabled := True;
      FVoxelExport.Button4.Enabled := True;
      FVoxelExport.Button5.Enabled := FVoxelExport.Benabled;  //prev
      FVoxelExport.SpeedButton9.Enabled := FVoxelExport.Benabled;  //save
      FVoxelExport.Button2.Enabled := FVoxelExport.Benabled;  //Start..
      FVoxelExport.Panel3.Enabled := True;
      FVoxelExport.Button5.Caption := 'Calculate preview';
    end;
    if bBulbTracerFormCreated then begin
      BulbTracerFrm.EnableControls(True);
    end;



    if MCFormCreated then MCForm.Button4.Enabled := MCForm.Button8.Enabled;
    ColorForm.CheckBox3.Enabled := True;
    SetImageCursor;
    GetCursorPos(P);
    SetCursorPos(P.X, P.Y - 1);   //To update the cursor, if over image
    SetCursorPos(P.X, P.Y);
    DragAcceptFiles(Self.Handle, True);
    if AnimationForm.AniOption >= 0 then AnimationForm.EnableButtons;
    if FNaviFormCreated then FNavigator.SpeedButton14.Enabled := True;
    if (AnimationForm.AniOption <> 3) and (BatchStatus <> 1) then
      SetThreadExecutionState(ES_CONTINUOUS);
end;

procedure TMand3DForm.DisableButtons;
begin
    SetThreadExecutionState(ES_CONTINUOUS or ES_SYSTEM_REQUIRED or ES_AWAYMODE_REQUIRED);
    SpeedButton32.Enabled := False;
    SpeedButton33.Enabled := False;
    SpeedButton34.Enabled := False;
    Button1.Enabled := False;
    Button6.Enabled := False;
    Button5.Enabled := False;
    Button9.Enabled := False;
    Button11.Enabled := False;
    Button12.Enabled := False;
    Button2.Caption := 'Stop';
    Button2.Hint := 'Stop the current calculation.';
    SpeedButton8.Enabled := False;
    SpeedButton9.Enabled := False;
    SpeedButton11.Enabled := False;
    SpeedButton16.Enabled := False;
    SpeedButton17.Enabled := False;
    SpeedButton18.Enabled := False;
    SpeedButton22.Enabled := False;
    SpeedButton23.Enabled := False;
    SpeedButton1.Enabled := False;
    SpeedButton2.Enabled := False;
    SpeedButton4.Enabled := False;
    IniDirsBtn.Enabled := False;
    MapSequencesBtn.Enabled := False;
    VisualThemesBtn.Enabled := False;
    MCalcStop := False;
    if PPFormCreated then
    begin
      PostProForm.Button1.Enabled := False;
      PostProForm.Button2.Enabled := False;
      PostProForm.Button3.Enabled := False;
      PostProForm.Button4.Enabled := False;
      PostProForm.Button5.Enabled := False;
      PostProForm.Button6.Enabled := False;
      PostProForm.Button7.Enabled := False;
      PostProForm.Button8.Enabled := False;
      PostProForm.Button9.Enabled := False;
      PostProForm.Button10.Enabled := False;
      PostProForm.Button12.Enabled := False;
      PostProForm.Button14.Enabled := False;
      PostProForm.Button15.Enabled := False;
      PostProForm.Button16.Enabled := False;
      PostProForm.Button18.Enabled := False;
      PostProForm.CheckBox21.Enabled := PostProForm.CheckBox21.Checked;
      PostProForm.CheckBox25.Enabled := PostProForm.CheckBox25.Checked;
    end;
    if BatchFormCreated then
    begin
      if BatchStatus = 0 then BatchForm1.Button1.Enabled := False;
    end;
    if bTilingFormCreated then
    begin
      TilingForm.Button2.Enabled := False;
      TilingForm.Button3.Enabled := False;
      TilingForm.SpeedButton1.Enabled := False;
      TilingForm.SpeedButton2.Enabled := False;
      if not TFSB9Echecked then
        TFSB9E := TilingForm.SpeedButton9.Enabled;
      TFSB9Echecked := True;  
      TilingForm.SpeedButton9.Enabled := False;
      TilingForm.SpeedButton11.Enabled := False;
      TilingForm.Panel2.Enabled := False;
    end;
    if bVoxelFormCreated then
    begin
      FVoxelExport.Button3.Enabled := False;
      FVoxelExport.SpeedButton11.Enabled := False;
      FVoxelExport.Button4.Enabled := False;
      FVoxelExport.Button5.Enabled := False;  //prev
      FVoxelExport.SpeedButton9.Enabled := False;  //save
      FVoxelExport.Button2.Enabled := False;  //Start..
      FVoxelExport.Panel3.Enabled := False;
    end;
    if bBulbTracerFormCreated then begin
      BulbTracerFrm.EnableControls(False);
    end;
    if MCFormCreated then MCForm.Button4.Enabled := False;
    Image1.Cursor := crHourGlass;
    DragAcceptFiles(Self.Handle, False);
    AnimationForm.DisableButtons;
    ProgressBar1.Position := 0;
    if FNaviFormCreated then FNavigator.SpeedButton14.Enabled := False;
    if ColorForm.CheckBox3.Checked then ColorForm.CheckBox3.Checked := False;
    ColorForm.CheckBox3.Enabled := False;
end;

procedure TMand3DForm.SetEulerEditsFromHeader;
var// Q: TQuaternion;
    v3: TVec3D;
begin
  //  MatrixToQuat(MHeader.hVGrads, Q);  // MatrixToAngles(v3);
 //   v3 := GetEulerFromQuat(Q);
    if not MatrixToAngles(v3, @MHeader.hVGrads) then
    begin
      Edit27.Text := '?';
      Edit32.Text := '?';
    end
    else
    begin
      Edit27.Text := FloatToStr(v3[0] / Pid180);
      Edit32.Text := FloatToStr(v3[2] / Pid180);
    end;
    Edit31.Text := FloatToStr(v3[1] / Pid180);
end;

procedure TMand3DForm.SetEdit16Text;
begin
    if (MHeader.bVolLightNr and 7) = 0 then
    begin
      Edit16.Text := IntToStr(MHeader.bDFogIt);
      ButtonVolLight.Caption := 'Dyn. fog on It.:';
      Edit16.Width := Edit35.Width;
      UpDown5.Visible := False;
      Label61.Visible := False;
    end else begin
      Edit16.Text := IntToStr(Max(1, MHeader.bVolLightNr and 7));
      ButtonVolLight.Caption := 'Volume light nr:';
      Edit16.Width := UpDown5.Left - Edit16.Left - 2;
      UpDown5.Visible := True;
      UpDown5.Position := (MHeader.bVolLightNr shr 4) - 2;
      if UpDown5.Position > 0 then Label61.Caption := '+' + IntToStr(UpDown5.Position)
                              else Label61.Caption := IntToStr(UpDown5.Position);
      Label61.Visible := True;
    end;
end;

procedure TMand3DForm.SetEditsFromHeader;
var TileRect: TRect;
    Crop: Integer;
begin
    bUserChange := False;
    with MHeader do
    try
      if (Width > 0) and (Height > 0) then InternAspect := Width / Height;
      if not NoSetFocus then
        Button2.SetFocus;
      if MHeader.TilingOptions <> 0 then
      begin
        GetTilingInfosFromHeader(@MHeader, TileRect, Crop);
        Edit11.Text := IntToStr(TileRect.Right - TileRect.Left + 1 - 2 * Crop);
        Edit12.Text := IntToStr(TileRect.Bottom - TileRect.Top + 1 - 2 * Crop);
      end else begin
        Edit11.Text := IntToStr(Width);
        Edit12.Text := IntToStr(Height);
      end;
      Edit1.Text  := FloatToStr(dZstart);
      Edit3.Text  := FloatToStr(dZend);
      Edit6.Text  := FloatToStrSingle(mZstepDiv);
      Edit9.Text  := FloatToStr(dXmid);
      Edit10.Text := FloatToStr(dYmid);
      Edit5.Text  := FloatToStr(dZoom);
      Edit14.Text := FloatToStr(dFOVy);
      Edit17.Text := FloatToStr(dZmid);
      Edit2.Text  := FloatToStrSingle(sColorMul);
      Edit8.Text  := FloatToStrSingle(sRaystepLimiter);
      Edit15.Text := FloatToStrSingle(StereoScreenWidth);
      Edit18.Text := FloatToStrSingle(StereoScreenDistance);
      Edit13.Text := FloatToStrSingle(StereoMinDistance);
      Edit25.Text := FloatToStrSingle(sDEstop);
      if Edit33.Text <> Authors[0] then
      begin
        Edit33.Enabled := (Authors[0] = IniVal[33]) or (Length(Authors[0]) < 2);
        Edit33.Text := Authors[0];
      end;
      Edit34.Text := Authors[1];

      SpinEdit2.Position := (iOptions shr 6) and 15;
      SpinEdit5.Position := bStepsafterDEStop;
      CheckBox1.Checked := (bNormalsOnDE and 1) <> 0;
      CheckBox3.Checked := (iOptions and 1) <> 0;
      CheckBox8.Checked := (iOptions and 2) <> 0;
      CheckBox2.Checked := (iOptions and 4) <> 0;
      Label31.Caption := IntToStr(iAvrgDEsteps div 10) + '.' + IntToStr(iAvrgDEsteps mod 10);
      Label32.Caption := IntToStr(iAvrgIts div 10) + '.' + IntToStr(iAvrgIts mod 10);
      if iMaxIts > 0 then Label40.Caption := IntToStr(iMaxIts)
                     else Label40.Caption := '?';
      Label52.Caption := IntToTimeStr(iCalcTime);
      Label8.Caption  := IntToTimeStr(iCalcHStime);
      Label48.Caption := IntToTimeStr(iAmbCalcTime);
      Label50.Caption := IntToTimeStr(iReflectsCalcTime);
      Edit22.Text := FloatToStr(dCutZ);
      Edit23.Text := FloatToStr(dCutX);
      Edit24.Text := FloatToStr(dCutY);
      bImageScale := Max(1, Min(10, bImageScale));
      ImageScale := bImageScale;
      SpeedButton35.Caption := '1:' + IntToStr(ImageScale);
      CheckBox4.Checked := (bCutOption and 1) > 0;
      CheckBox5.Checked := (bCutOption and 2) > 0;
      CheckBox6.Checked := (bCutOption and 4) > 0;
      CheckBox9.Checked := (bVaryDEstopOnFOV > 0);
      CheckBox7.Checked := bIsJulia > 0;
      RadioGroup2.ItemIndex := bPlanarOptic;
      RadioGroup1.ItemIndex := byColor2Option;
      Edit28.Text := FloatToStr(dJx);
      Edit29.Text := FloatToStr(dJy);
      Edit30.Text := FloatToStr(dJz);
      Edit7.Text := FloatToStr(dJw);
      SetEdit16Text;
      Edit35.Text := IntToStr(bColorOnIt - 1);
      PageControl1Change(Self);

      SetEulerEditsFromHeader;

      FormulaGUIForm.UpdateFromHeader(@MHeader);

      if PPFormCreated then
      begin
        PostProForm.CheckBox1.Checked := (bCalcDOFtype and 1) <> 0;
        PostProForm.RadioGroup2.ItemIndex := (bCalcDOFtype shr 3) and 1;
        PostProForm.RadioGroup1.ItemIndex := (bCalcDOFtype shr 1) and 3;
        PostProForm.Edit1.Text := FloatToStrSingle(sDOFZsharp);
        PostProForm.Edit2.Text := FloatToStrSingle(sDOFclipR);
        PostProForm.Edit3.Text := FloatToStrSingle(sDOFaperture);
        PostProForm.Edit10.Text := FloatToStrSingle(sDOFZsharp2);
        PostProForm.Edit5.Text := FloatToStrSingle(HSmaxLengthMultiplier);
        PostProForm.CheckBox9.Checked := (bCalculateHardShadow and 1) <> 0;
        PostProForm.CheckBox10.Checked := (bCalculateHardShadow and 2) <> 0;
        PostProForm.CheckBox2.Checked := (bCalculateHardShadow and 4) <> 0;
        PostProForm.CheckBox3.Checked := (bCalculateHardShadow and 8) <> 0;
        PostProForm.CheckBox4.Checked := (bCalculateHardShadow and 16) <> 0;
        PostProForm.CheckBox5.Checked := (bCalculateHardShadow and 32) <> 0;
        PostProForm.CheckBox6.Checked := (bCalculateHardShadow and 64) <> 0;
        PostProForm.CheckBox7.Checked := (bCalculateHardShadow and 128) <> 0;
        PostProForm.CheckBox29.Checked := (bCalc1HSsoft and 1) <> 0;
        PostProForm.CheckBox11.Checked := (bCalcAmbShadowAutomatic and 1) <> 0;
        PostProForm.CheckBox12.Checked := (bCalcAmbShadowAutomatic and 2) <> 0;    //Thr0
        PostProForm.CheckBox22.Checked := (bCalcAmbShadowAutomatic and 128) <> 0;  //fsr
        PostProForm.TabControl1.TabIndex := (bCalcAmbShadowAutomatic shr 2) and 3;
        PostProForm.UpDown1.Position := (bCalcAmbShadowAutomatic shr 4) and 3; //and 7
        PostProForm.RadioGroup5.ItemIndex := AODEdithering;
        PostProForm.Edit34.Text := FloatToStrSingle(Abs(sAmbShadowThreshold));
        PostProForm.CheckBox23.Checked := (byCalcNsOnZBufAuto and 1) <> 0;
        PostProForm.CheckBox24.Checked := (bCalcSRautomatic and 1) <> 0;
        PostProForm.Edit6.Text := FloatToStrSingle(Min0MaxCS(SRamount, 100));
        PostProForm.UpDown2.Position := Min(8, Max(1, SRreflectioncount));
        PostProForm.UpDown3.Position := Min(9, Max(1, SSAORcount));
        PostProForm.Edit8.Text := FloatToStrSingle(MinMaxCS(s1d255, sDEAOmaxL, 100));
        PostProForm.RadioGroup3Click(Self); //to make AO components visible or not
        PostProForm.Edit9.Text := D2ByteToStr(bSSAO24BorderMirrorSize);
        PostProForm.Edit13.Text := FloatToStrSingle(MinMaxCS(s1em30, sTransmissionAbsorption, 1e10));
        PostProForm.Edit14.Text := FloatToStrSingle(MinMaxCS(0.1, sTRIndex, 10));
        PostProForm.Edit17.Text := FloatToStrSingle(Min0MaxCS(sTRscattering, s1e30));
        PostProForm.CheckBox27.Checked := (bCalcSRautomatic and 2) <> 0;
        PostProForm.CheckBox28.Checked := (bCalcSRautomatic and 4) <> 0;
        PostProForm.Edit7.Text := ShortFloatToStr(MCSoftShadowRadius);
      end;
    finally
      bUserChange := True;  
    end;
end;

procedure TMand3DForm.MakeHeader;
var d: Double;
begin
    with MHeader do
    begin
      MandId := actMandId;
      if TilingOptions = 0 then
      begin
        Width  := StrToIntTrim(Edit11.Text);
        Height := StrToIntTrim(Edit12.Text);
      end;
      Iterations        := StrToIntTrim(FormulaGUIForm.MaxIterEdit.Text);
      MinimumIterations := StrToIntTrim(FormulaGUIForm.MinIterEdit.Text);
      iMaxItsF2         := StrToIntTrim(FormulaGUIForm.MaxIterHybridPart2Edit.Text);
      bNormalsOnDE      := Byte(CheckBox1.Checked);
      bPlanarOptic      := RadioGroup2.ItemIndex;
      bStepsafterDEStop := SpinEdit5.Position;
      if PPFormCreated then
      begin
        PostProForm.PutDOFparsToHeader(@MHeader);
        PostProForm.PutAmbientParsToHeader(@MHeader);
        PostProForm.PutReflectionParsToHeader(@MHeader);
        HSmaxLengthMultiplier := StrToFloatK(PostProForm.Edit5.Text);
        bCalculateHardShadow := PostProForm.HSoptions and 255;
        bCalc1HSsoft := PostProForm.HSoptions shr 8;
        byCalcNsOnZBufAuto := Byte(PostProForm.CheckBox23.Checked) and 1;
        bSSAO24BorderMirrorSize := StrToD2Byte(PostProForm.Edit9.Text);
     //   MCSoftShadowRadius := StrToShortFloat(PostProForm.Edit7.Text);
        if not StrToFloatKtry(PostProForm.Edit7.Text, d) then d := 1;
        MCSoftShadowRadius := SingleToShortFloat(MinMaxCS(s001, d, 20));
      end
      else
      begin
        bCalculateHardShadow := 0;
        bCalc1HSsoft := 0;
        bCalcAmbShadowAutomatic := 1;
        sAmbShadowThreshold := 2;
        byCalcNsOnZBufAuto := 0;
        bSSAO24BorderMirrorSize := 0;
      end;
      iOptions := (SpinEdit2.Position shl 6) or (Ord(CheckBox3.Checked) and 1)
                  or ((Ord(CheckBox8.Checked) and 1) shl 1) or  //bit1=FirstStepRandom, bit2=Shortdist check DEs
                  ((Ord(CheckBox2.Checked) and 1) shl 2);       //bit3=StepSubDEstop,   bit7..10=smoothNs(0..8)
      mZstepDiv := Max(0.001, Min(1, StrToFloatK(Edit6.Text)));
      dZstart   := StrToFloatK(Edit1.Text);
      dZend     := StrToFloatK(Edit3.Text);
      dXmid     := StrToFloatK(Edit9.Text);
      dYmid     := StrToFloatK(Edit10.Text);
      dZmid     := StrToFloatK(Edit17.Text);
      dZoom     := StrToFloatK(Edit5.Text);
      RStop     := StrToFloatK(FormulaGUIForm.RBailoutEdit.Text);
      dXWrot    := StrToFloatK(FormulaGUIForm.XWEdit.Text) * Pid180;
      dYWrot    := StrToFloatK(FormulaGUIForm.YWEdit.Text) * Pid180;
      dZWrot    := StrToFloatK(FormulaGUIForm.ZWEdit.Text) * Pid180;
      dFOVy     := StrToFloatK(Edit14.Text);
      dCutZ     := StrToFloatK(Edit22.Text);
      dCutX     := StrToFloatK(Edit23.Text);
      dCutY     := StrToFloatK(Edit24.Text);
      bCutOption := Byte(CheckBox4.Checked) or (Byte(CheckBox5.Checked) shl 1)
                     or (Byte(CheckBox6.Checked) shl 2);   //todo side of cuts
      sDEstop   := Max(0.001, StrToFloatK(Edit25.Text));
      bImageScale := ImageScale;
      bIsJulia  := Byte(CheckBox7.Checked);
      dJx       := StrToFloatK(Edit28.Text);
      dJy       := StrToFloatK(Edit29.Text);
      dJz       := StrToFloatK(Edit30.Text);
      dJw       := StrToFloatK(Edit7.Text);
      sColorMul := StrToFloatK(Edit2.Text);
      sRaystepLimiter := StrToFloatK(Edit8.Text);
      StereoScreenWidth := StrToFloatK(Edit15.Text);
      StereoScreenDistance := StrToFloatK(Edit18.Text);
      StereoMinDistance := StrToFloatK(Edit13.Text);
      bVaryDEstopOnFOV := Byte(CheckBox9.Checked);
      byColor2Option := RadioGroup1.ItemIndex;
      bColorOnIt := Max(0, Min(255, StrToIntTrim(Edit35.Text) + 1));
      if ButtonVolLight.Caption = 'Dyn. fog on It.:' then
      begin
        bVolLightNr := 2 shl 4;
        bDFogIt := StrToIntTrim(Edit16.Text);
      end
      else bVolLightNr := Min(6, Max(1, StrToIntTrim(Edit16.Text))) or ((UpDown5.Position + 2) shl 4);

      PCFAddon := @HAddon;
      LightAdjustForm.PutLightFInHeader(MHeader);
      HAddon.bOptions1 := (HAddon.bOptions1 and $FC) or FormulaGUIForm.TabControl2.TabIndex;
      HAddon.bOptions2 := (Ord(FormulaGUIForm.CheckBox2.Checked) and 1) or
                          (FormulaGUIForm.ComboBox1.ItemIndex shl 1);
      HAddOn.bOptions3 := FormulaGUIForm.DECombineCmb.ItemIndex;
      if HAddOn.bOptions3 < 5 then
        sDEcombS := Min0MaxCS(StrToFloatK(FormulaGUIForm.Edit23.Text), 100)
      else
      begin
        DEmixColorOption := Max(0, Min(2, StrToIntTrim(FormulaGUIForm.Edit23.Text)));
        sFmixPow := sNotZero(MinMaxCS(-100, StrToFloatK(FormulaGUIForm.Edit25.Text), 100));
      end;
    end;
end;

procedure TMand3DForm.MapSequencesBtnClick(Sender: TObject);
begin
  MapSequencesFrm.Visible := True;
end;

function TMand3DForm.SizeOK(Verbose: LongBool): LongBool;
var sp: TPoint;
begin
    sp := GetTileSize(@MHeader);
    Result := Length(siLight5) = sp.X * sp.Y;
    if Verbose and not Result then OutMessage('Error with image size.');
end;

function AniFileAlreadyExists(var s: String): LongBool;
var sa: String;
begin
    s := IntToStr(AnimationForm.AniFileIndex);
    if AnimationForm.AniStereoMode then
    begin
      if AnimationForm.AniRightImage then sa := AnimationForm.AniProjectName + 'Right'
                                     else sa := AnimationForm.AniProjectName + 'Left';
    end
    else sa := AnimationForm.AniProjectName;
    s := AnimationForm.AniOutputFolder + sa + StringOfChar('0', 6 - Length(s)) + s;
    case AnimationForm.AniOutputFormat of
      0:  s := ChangeFileExt(s, '.bmp');
      1:  s := ChangeFileExt(s, '.png');
      2:  s := ChangeFileExt(s, '.jpg');
      3:  s := ChangeFileExt(s, '.m3p');
    end;
    Result := FileExists(s);
end;

procedure TMand3DForm.CalcMand(bMakeHeader: LongBool);
var stmp: String;
    TileSize: TPoint;
    b: LongBool;
begin
    if AnimationForm.AniOption = 3 then
    begin
      AniFileAlreadyExists(stmp);
      if (AnimationForm.CheckBox4.Checked and AnimationForm.CheckBox5.Checked and AnimationForm.AniRightImage) or
         ((not AnimationForm.CheckBox6.Checked) and FileIsBigger1(stmp)) or
         (not AnimationForm.OccupyDFile(stmp)) then
      begin
        AnimationForm.NextSubFrame;
        Exit;
      end;
      Caption := ExtractFileName(stmp);
      b := bUserChange;
      bUserChange := False;
      Edit11.Text := IntToStr(MHeader.Width);
      Edit12.Text := IntToStr(MHeader.Height);
      bUserChange := b;


    if ( AnimationForm.AniOption = 3 ) and ( AnimationForm.AniOutputFormat = 3) then  begin
      try
        AnimationForm.CloseOutPutStream;
      except
        // hide this error
      end;
      SaveCurrParamAsM3P( stmp );
      AnimationForm.NextSubFrame;
      Exit;
    end;


    end;
    SaveM3IfileAuto := False;
    SSAORiteration := 0;
    CalcStart := GetTickCount;
    Shape1.Visible := False;
    Inc(RepaintCounter);
    MHeader.bHScalculated := 0;
    if bMakeHeader then
    begin
      MakeHeader;
      MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, MHeader.bStereoMode);
      MHeader.bSliceCalc := 0;    //for StoreUndo so that no identic headers are stored
      if (AnimationForm.AniOption <= 0) and (MHeader.TilingOptions = 0) then StoreUndo;
      MHeader.bSliceCalc := SliceCalc;
      CalcPosLightsRelPos(@MHeader, @HeaderLightVals);
    end
    else if AnimationForm.AniOption = 0 then
      CalcPosLightsRelPos(@MHeader, @HeaderLightVals);
    if (MHeader.Width < 1) or (MHeader.Height < 1) then Exit;
    try
      TileSize := GetTileSize(@MHeader);
      SetLength(siLight5, TileSize.X * TileSize.Y);
      mSLoffset := TileSize.X * SizeOf(TsiLight5);
      SetImageSize;
    except
      SetLength(siLight5, 0);
      mSLoffset := 0;
    end;
    if Length(siLight5) = 0 then
    begin
      Button2.Caption := 'Calculate 3D';
      ShowMessage('Out of memory, decrease the imagesize.');
      Exit;
    end;
    DisableButtons;
    if (MHeader.bCalc3D <> 0) and ((MHeader.bVolLightNr and 7) > 0) and
      ((MHeader.Light.Lights[Min(5, (MHeader.bVolLightNr and 7) - 1)].Loption and 3) = 0) then
    begin
      MapCalcWindow.pMap := @VolumeLightMap;
      MapCalcWindow.pHeader := @MHeader;
      MapCalcWindow.PLightVals := @HeaderLightVals;
      MapCalcWindow.Visible := True;
      while MapCalcWindow.Visible do delay(200);
      if MCalcStop then
      begin
        EnableButtons;
        Exit;
      end;
      bSRVolLightMapCalculated := True;
    end;
    MHeader.iCalcHStime := 0;
    MHeader.iAmbCalcTime := 0;
    Label8.Caption := '-';
    Label48.Caption := '-';
    Label50.Caption := '-';
    MCalcThreadStats.pLBcalcStop := @MCalcStop;
    MCalcThreadStats.pMessageHwnd := Self.Handle;
    MCalcThreadStats.iProcessingType := 1;
    MCalcThreadStats.iAllProcessingOptions := AllAutoProcessings(@MHeader);

    if CalcMandT(@MHeader, @HeaderLightVals, @MCalcThreadStats,
                 @siLight5[0], mSLoffset, mFSIstart, mFSIoffset, GetCalcRect) then
    begin
      iActiveThreads := MCalcThreadStats.iTotalThreadCount;
      CalcYact := -1;  //for upgrading the image
      ProgressBar1.Max := MHeader.Height;
      ProgressBar1.Visible := MHeader.bCalc3D > 0;
      if ProgressBar1.Visible then Timer4.Interval := 200 + (TileSize.X + TileSize.Y) shr 3
                              else Timer4.Interval := 100 + (TileSize.X + TileSize.Y) shr 4;
      if Timer4.Interval > 800 then Timer4.Interval := 1000;
      Timer4.Enabled := True;
      if ProgressBar1.Visible then Label6.Caption := 'main rendering';
    end
    else
    begin
      EnableButtons;
      MCalcThreadStats.iProcessingType := 0;
    end;
end;

procedure TMand3DForm.Button1Click(Sender: TObject);
begin
    SliceCalc := (Sender as TSpeedButton).Tag;
    Timer1.Enabled := True;
end;

function GetSpecialFolderPath(folder : Integer) : String;
const SHGFP_TYPE_CURRENT = 0;
var path: array [0..MAX_PATH] of Char;
begin
    if SUCCEEDED(SHGetFolderPath(0, folder, 0, SHGFP_TYPE_CURRENT, @path[0])) then
      Result := path
    else
      Result := '';
end;

procedure IniHAddon(HA: PTHeaderCustomAddon);
var i: Integer;
begin
    with HA^ do
    begin
      bHCAversion := 1;
      bOptions1 := 0;
      bOptions2 := 0;
      bOptions3 := 0;
      iFCount := 0;
      bHybOpt1 := 0;
      bHybOpt2 := $151;
      for i := 0 to 5 do
      with Formulas[i] do
      begin
        iItCount := 0;
        iFnr := -1;
        CustomFname[0] := 0;
        dOptionValue[0] := 8;
      end;
      Formulas[0].iItCount := 1;
      Formulas[0].iFnr := 0;
    end;
end;

procedure TMand3DForm.IniMHeader;
var i: Integer;
begin
    MHeader.PCFAddon := @HAddOn;
    for i := 0 to 5 do MHeader.PHCustomF[i] := @HybridCustoms[i];
end;

procedure TMand3DForm.FormCreate(Sender: TObject);
var i: Integer;
begin
    LoadIni;
    if IniVal[35] <> '' then TStyleManager.TrySetStyle(IniVal[35]);

    OPD := TOpenPictureDialogM3D.Create(Self);
    OPD.Filter := 'M3D Image + Parameter (*.m3i)|*.m3i';
    OPD.DefaultExt := 'm3i';
    Randomize;
    FormatSettings.DecimalSeparator  := '.';
    notAllButtonsUp   := True;
    ScrollBox1.DoubleBuffered := True;
    bUserChange       := True;
    StartupLoadM3I    := False;
    SaveAniImage      := False;
    SaveTileImage     := False;
    isRepainting      := False;
    TFSB9Echecked     := False;
    bOutMessageLoud   := False;
    CloseTries        := 0;
    iGetPosFromImage  := 0;
    MHeader.Width     := 0;
    MHeader.Height    := 0;
    MHeader.bSliceCalc := 2;
    MHeader.bCalc3D := 0;
    MHeader.MCSoftShadowRadius := SingleToShortFloat(1);
    MHeader.MCDepth := 3;
    MHeader.MCcontrast := 128;
    MHeader.MCoptions := 2;
    MHeader.bMCSaturation := 32;
    FreeLightMap(@M3DBackGroundPic);
    MCalcThreadStats.iProcessingType := 0;
    MCalcThreadStats.iTotalThreadCount := 0;
    iActivePaintThreads := 0;
    UserAspect := Point(0, 0);
    IniMHeader;
    for i := 0 to 5 do IniCustomF(@HybridCustoms[i]);
    for i := 0 to 5 do IniCustomF(@calcHybridCustoms[i]);
    IniHAddon(@HAddOn);
    GetHAddOnFromInternFormula(@MHeader, 0, 0);
    UpDown3.Position := Min(64, Max(1, NumberOfCPUs));
    MHeader.Light.FineColAdj1 := 0;
    MHeader.Light.FineColAdj2 := 120;
    MHeader.Light.BGbmp[0] := 0;
    MHeader.TilingOptions := 0;
    DragAcceptFiles(Self.Handle, True);

    PageControl2.ActivePageIndex := 0;
  //  if Testing then Showmessage('M3D load ini now...');
  //  LoadIni;
//    SetM3Dini;
 //   CategoryPanelGroup1.ScaleBy(96, Screen.PixelsPerInch);
end;

procedure TMand3DForm.Button2Click(Sender: TObject);   //main Calc3D button
begin
    PropagateCurrFrameNumber;
    TilingForm.SaveThisTile := False;
    if Button2.Caption = 'Stop' then
    begin
      if (MCalcThreadStats.iProcessingType > 0) and Timer4.Enabled and
         ((GetTickCount - CalcStart) > 900000) then
      begin
        if MessageDlg('Do you really want to stop the calculations?', mtWarning,
                      [mbYes, mbNo], 0) = mrNo then Exit;
      end;
      Timer1.Enabled := False;
      MCalcStop := True;
      AnimationForm.bCalcStop := True;
      if (AnimationForm.AniOption > 0) then
      begin
        AnimationForm.ActualKFsubframe := 1;
        AnimationForm.ActualKeyFrame   := AnimationForm.HeaderCount;
        AnimationForm.NextSubFrame;
        Caption := 'Mandelbulb 3D';
      end;
      if BatchStatus > 0 then BatchStatus := -1;
      if not Timer4.Enabled then
      begin
        EnableButtons;
        if PPFormCreated then
        begin
          PostProForm.CheckBox21.Checked := False;
          PostProForm.CheckBox25.Checked := False;
        end;
      //  if SizeOK(False) then UpdateScaledImage(0, MHeader.Height div ImageScale);
      end;
    end else begin
      Timer1.Enabled := False;
      if bImageText then
      begin
        Image1.Canvas.Font.Color := clBtnFace;
        Image1.Picture.Bitmap.Canvas.TextOut(8, 16, 'Press ''Calculate 3D'' to render');
        Image1.Canvas.Font.Color := clWindowText;
        bImageText := False;
      end;
      ColorForm.CheckBox3.Checked := False;
      ProofPosLight;
      if MHeader.bStereoMode <> 0 then Caption := 'Mandelbulb 3D';
      MHeader.bStereoMode := 0;
      MHeader.bCalc3D := 1;
      StoreHistoryPars(MHeader);
      CalcMand(True);
    end;
end;

{function TMand3DForm.MakeTitelFromCaption: String;
begin
 //   if Copy(Caption, 1, 13) = 'Mandelbulb 3D' then
end; }

procedure TMand3DForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Timer1.Enabled := False;
    MCalcStop      := True;
    StoreHistoryPars(MHeader);
    CopyHeaderAsTextToClipBoard(@MHeader, Caption);
    IniVal[15] := IntToStr(Byte(CheckBox11.Checked) and 1);
    if CheckBox15.Checked then IniVal[29] := IntToStr(ComboBox2.ItemIndex) else IniVal[29] := '-1';
    if CheckBox12.Checked then IniVal[21] := 'Auto' else IniVal[21] := IntToStr(UpDown3.Position);
    if ColorForm.CheckBox3.Checked then ColorForm.CheckBox3.Checked := False;
end;

procedure TMand3DForm.Timer1Timer(Sender: TObject);  //start new 2D calculation
begin
    if StartupLoadM3I then
    begin
      Timer1.Enabled := False;
      StartupLoadM3I := False;
      LoadFullM3I(MHeader, ParamStr(1));
    end else begin
      if MCalcThreadStats.iProcessingType > 0 then
        MCalcStop := True
      else
      begin
        Timer1.Enabled  := False;
        MHeader.bCalc3D := 0;
        bImageText      := False;
        Button2.Caption := 'Stop';
        CalcMand(True);
      end;
    end;
end;

procedure TMand3DForm.SBsaveJPEGClick(Sender: TObject);
//var s: String;
begin
    if SaveDialog4.Execute then
    begin
  //    s := ExtractFileDir(SaveDialog4.FileName);
      SaveImageO(1, SaveDialog4.FileName);
      SetSaveDialogNames(SaveDialog4.FileName);
 //     if s <> '' then SaveDialog4.InitialDir := s;
    end;
end;

procedure TMand3DForm.getI1BMPSLs;
begin
    I1BMPstartSL := Integer(Image1.Picture.Bitmap.ScanLine[0]);
    I1BMPoffset  := Integer(Image1.Picture.Bitmap.ScanLine[1]) - I1BMPstartSL;
end;

procedure TMand3DForm.HeightMapGenBtnClick(Sender: TObject);
begin
  HeightMapGenFrm.Visible := True;
  BringToFront2(HeightMapGenFrm.Handle);
end;

procedure TMand3DForm.RepaintMand3D(bStartTimer: LongBool);
var x, y, ThreadCount, Crop: Integer;
    ppThread: array of TPaintThread;
    PaintParameter: TPaintParameter;
    d: Double;
    TileSize: TPoint;
    TilingRect: TRect;
begin
    if SizeOK(False) then
    begin
      Inc(RepaintCounter);
      WaitForPaintStop(5);
      isRepainting := True;
      RepaintYact  := 0;
      if (AnimationForm.AniOption <= 0) then
      begin
        LightAdjustForm.PutLightFInHeader(MHeader);
        MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, MHeader.bStereoMode);
      end;
      SetImageSize;
      ThreadCount := Max(1, Min(GetTileSize(@MHeader).Y, Min(16, UpDown3.Position)));
      SetLength(ppThread, ThreadCount);
      CalcStepWidth(@MHeader);
      with PaintParameter do
      begin
        PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
        ppWidth  := MHeader.Width;
        ppHeight := MHeader.Height;
        ppYinc   := ThreadCount;
        PLVals   := @HeaderLightVals;
        pVgrads  := @PaintVGrads;
        sFOVy    := MHeader.dFOVy * Pid180;
        ppXOff   := CalcXoff(@MHeader);
        ppPlanarOptic := MHeader.bPlanarOptic and 3;
        if ppPlanarOptic = 2 then sFOVy := Pi;
        d := Min(1.5, Max(0.01, sFOVy * 0.5));
        ppPlOpticZ := Cos(d) * d / Sin(d);
        CalcPPZvals(MHeader, Zcorr, ZcMul, ZZstmitDif);
        StepWidth := MHeader.dStepWidth;
        ppLocalCounter := RepaintCounter;
        pPsiLight := @siLight5[0];
        if MHeader.TilingOptions <> 0 then
        begin
          TileSize := GetTileSize(@MHeader);
          ppPaintWidth := TileSize.X;  //TilingForm.brTileW;
          ppPaintHeight := TileSize.Y; //TilingForm.brTileH;
          GetTilingInfosFromHeader(@MHeader, TilingRect, Crop);
          ppXplus := TilingRect.Left;
          ppYplus := TilingRect.Top;
        end else begin
          ppPaintWidth := ppWidth;
          ppPaintHeight := ppHeight;
          ppXplus := 0;
          ppYplus := 0;
        end;
        ppPLoffset := ppPaintWidth * SizeOf(TsiLight5);
        ppMessageHwnd := Self.Handle;
      end;
      for x := 0 to ThreadCount - 1 do
      begin
        RepYact[x] := 0;
        PaintParameter.ppYstart   := x;
        PaintParameter.ppThreadID := x;
        try
          ppThread[x]                 := TPaintThread.Create(True);
          ppThread[x].FreeOnTerminate := True;
          ppThread[x].PaintParameter  := PaintParameter;
          ppThread[x].Priority        := cTPrio[Min(3, ComboBox2.ItemIndex + 1)];
          Inc(RepaintCounts[x]);// := 1;
        except
          ThreadCount := x;
          for y := 0 to ThreadCount - 1 do
            ppThread[y].PaintParameter.ppYinc := ThreadCount;
          Break;
        end;
      end;
      RepYThreads := ThreadCount;
      iActivePaintThreads := ThreadCount;
      for x := 0 to ThreadCount - 1 do ppThread[x].Start;
      Timer8.Interval := 100;
      if bStartTimer then Timer8.Enabled := True;
//   mCalcThreadStats.cCalcTime := GetTickCount; //test
    end;
end;
 //     if RepaintCounts[y] > 0 then Inc(c);
   //   if RepYact[y] < ymin then ymin := RepYact[y];

procedure TMand3DForm.Timer3Timer(Sender: TObject);
begin
    if not isRepainting then
    begin
      Timer3.Enabled := False;
      RepaintMand3D(True);
    end;
end;

procedure TMand3DForm.CalcStatistic;
var i, iMa: Integer;
    dS, dI, dSC, dIC: Double;
begin
    dS  := 0;
    dI  := 0;
    dSC := 0;
    dIC := 0;
    iMa := 0;
    for i := 1 to MCalcThreadStats.iTotalThreadCount do
    with MCalcThreadStats.CTrecords[i] do
    begin
      dS  := dS + i64DEsteps;
      dI  := dI + i64Its;
      dSC := dSC + iDEAvrCount;
      dIC := dIC + iItAvrCount;
      if MaxIts > iMa then iMa := MaxIts;
    end;
    with MHeader do
    begin
      if dSC > 0 then iAvrgDEsteps := Round(dS * 10 / dSC)
                 else iAvrgDEsteps := 0;
      if dIC > 0 then iAvrgIts := Round(dI * 10 / dIC)
                 else iAvrgIts := 0;
      iMaxIts := iMa;
      if iAvrgDEsteps = 0 then Label31.Caption := '?' else
      Label31.Caption := IntToStr(iAvrgDEsteps div 10) + '.' + IntToStr(iAvrgDEsteps mod 10);
      Label32.Caption := IntToStr(iAvrgIts div 10) + '.' + IntToStr(iAvrgIts mod 10);
      Label40.Caption := IntToStr(iMa);
      Label52.Caption := IntToTimeStr(iCalcTime);
    end;
end;

procedure TMand3DForm.WaitForPaintStop(maxSeconds: Integer);
var i, c, y: Integer;
begin
    i := maxSeconds * 50;
    repeat
      c := 0;
      for y := 0 to RepYThreads - 1 do if RepaintCounts[y] > 0 then Inc(c);
      if c > 0 then Sleep(20);
      Dec(i);
    until (c = 0) or (i = 0);
end;

procedure TMand3DForm.RepaintMand3DnoThread;
begin
    Screen.Cursor := crHourGlass;
    try
      Inc(RepaintCounter);
      Application.ProcessMessages;
      WaitForPaintStop(3);
      RepaintMand3D(False);
      WaitForPaintStop(40);
    finally
      Screen.Cursor := crDefault;
      isRepainting := False;
    end;
end;

procedure TMand3DForm.DoSaveAniImage;
var s, sa, si: String;
begin
    SaveAniImage := False;  //do the correct scaling...
    if ImageScale <> AnimationForm.AniScale then
      UpdateAndScaleImageFull(AnimationForm.AniScale);
    Image1.Repaint;
    si := IntToStrL(AnimationForm.AniFileIndex, 6);
    if AnimationForm.AniStereoMode then
    begin
      if AnimationForm.AniRightImage then sa := AnimationForm.AniProjectName + 'Right'
                                     else sa := AnimationForm.AniProjectName + 'Left';
    end
    else sa := AnimationForm.AniProjectName;
    s := AnimationForm.AniOutputFolder + sa + si;
    if Assigned(AnimationForm.AniOutFile) then
    begin
      case AnimationForm.AniOutputFormat of
        0:  SaveBMP2FStream(s, Image1.Picture.Bitmap, pf24bit, AnimationForm.AniOutFile);
        1:  SavePNG2FStream(s, Image1.Picture.Bitmap, AnimationForm.AniOutFile);
        2:  SaveJPEGfromBMP2FStream(s, Image1.Picture.Bitmap, StrToIntTrim(Edit26.Text), AnimationForm.AniOutFile);
      end;
      AnimationForm.CloseOutPutStream;
    end else
    case AnimationForm.AniOutputFormat of
      0:  SaveBMP(s, Image1.Picture.Bitmap, pf24bit);
      1:  SavePNG(s, Image1.Picture.Bitmap, CheckBox13.Checked);
      2:  SaveJPEGfromBMP(s, Image1.Picture.Bitmap, StrToIntTrim(Edit26.Text));
    end;
    if AnimationForm.CheckBox7.Checked then
    begin
      s := AnimationForm.AniOutputFolder + 'ZBuf ' + sa + si;
      SaveZBuf(s, 0);
    end;
    AnimationForm.NextSubFrame;
end;

procedure TMand3DForm.DoSaveTileImage;
var s: String;
begin
    SaveTileImage := False;    //do the correct scaling...
    if ImageScale <> TilingForm.BigRenderData.brDownScale then
      UpdateAndScaleImageFull(TilingForm.BigRenderData.brDownScale);
    Image1.Repaint;
    with TilingForm do
    begin
      s := SaveDirectory + ProjectName + MakeFilePointIndizes(brActTile, 2, BigRenderData);
      if not SysUtils.DirectoryExists(SaveDirectory) then
        if not CreateDir(SaveDirectory) then
          ShowMessage('The directory:' + #13#10 + SaveDirectory + #13#10 + 'could not be created!');

      Mand3DForm.Label23.Caption := Label23.Caption; //sharpness
      SaveImageO(BigRenderData.brOutputType, s);

      if BigRenderData.brSaveM3I then SaveM3I(s, CheckBox16.Checked);

      if BigRenderData.brSaveZBuf then
      begin
        s := SaveDirectory + 'ZBuf ' + ProjectName + MakeFilePointIndizes(brActTile, 2, BigRenderData);
        SaveZBuf(s, 0);
      end;
      NextTile;
    end;
end;

procedure TMand3DForm.Timer4Timer(Sender: TObject);   // proof if threads are still calculating
var x, y, z, ymin, c, yoff, yimi: Integer;
    yy, xx, ymax: Double;
    s: String;
    DoFrec: TDoFrec;
begin
    ymin := 999999;
    c    := 0;
    yy   := 0;
    with MCalcThreadStats do
    begin
      ymax := (ctCalcRect.Bottom - ctCalcRect.Top + 1) / iTotalThreadCount;
      xx := 1 / Max(1, ctCalcRect.Right - ctCalcRect.Left + 1);
      yimi := 0;
      for y := 1 to iTotalThreadCount do
      with CTrecords[y] do
      begin
        if iActualYpos < ymin then
        begin
          ymin := iActualYpos;
          yimi := y;
        end;
        if isActive > 0 then
        begin
          Inc(c);
          yy := yy + MinCD(ymax, Max(0, iActualYpos - ctCalcRect.Top - y + 1) / iTotalThreadCount +
                                 Max(0, iActualXpos - ctCalcRect.Left) * xx);
        end
        else yy := yy + ymax;
      end;
    end;
    yoff := MCalcThreadStats.ctCalcRect.Top;   //HS:3  AO:4
    if (MCalcThreadStats.iProcessingType in [1, 3, 4]) and (ymin > CalcYact) and             //DEAO
       ((MCalcThreadStats.iProcessingType in [1, 3]) or ((MHeader.bCalcAmbShadowAutomatic and 12) = 12)) then
    begin
      if CalcYact < 0 then CalcYact := 0;
      if ymin >= MHeader.Height then ymin := MHeader.Height - 1;
      if c = 0 then
      begin
        PaintRowsNoThread(CalcYact - yoff, ymin - yoff);   //worst case: still one PaintRows Thread active.. can lead to failures
        x := 600;
        while (ActivePRThreads > 0) and (x > 0) do
        begin
          Dec(x);
          Sleep(50);
        end;
      end          //<0
      else with MCalcThreadStats do
      begin
        PaintRows(CalcYact - yoff, ymin - yoff);
         //new test: give slowest thread a higher priority
        if (iTotalThreadCount > 1) and (yimi > 0) and (HandleType = 1) and (TBoostChanged or not CheckBox14.Checked) then
        try
          for y := 1 to iTotalThreadCount do  //  [0..4] of TTHreadPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher);
          if CTrecords[y].isActive > 0 then
          begin
            if (y = yimi) and not CheckBox14.Checked then
              TThread(CThandles[y]).Priority := ByteToThreadPrio(ComboBox2.ItemIndex + 1)
            else TThread(CThandles[y]).Priority := ByteToThreadPrio(ComboBox2.ItemIndex);
          end;
          TBoostChanged := False;
        except
        end;
      end;
    end
    else if (MCalcThreadStats.iProcessingType in [6, 10]) and (ymin > CalcYact) then
    begin
      if CalcYact < yoff then CalcYact := yoff;
      if ymin >= MHeader.Height then ymin := MHeader.Height - 1; //not in tiling
      UpdateScaledImage((CalcYact - yoff) div ImageScale, (ymin - yoff) div ImageScale);
    end;
    CalcYact := ymin;
    if MCalcThreadStats.iProcessingType in [1, 3, 4, 6, 10] then
    begin
      ProgressBar1.Position := (ProgressBar1.Max * Max(0, (ymin - MCalcThreadStats.ctCalcRect.Top))) div
        Max(1, MCalcThreadStats.ctCalcRect.Bottom - MCalcThreadStats.ctCalcRect.Top);
      if (MCalcThreadStats.iProcessingType in [1, 3, 6, 10]) or (MHeader.bCalcAmbShadowAutomatic and 12 = 12) then
      begin
        y := Max(0, GetTickCount - MCalcThreadStats.cCalcTime);
        if y > 100000 then MButtonsUp;
        xx := y / MSecsPerDay;
        Label1.Caption := dDateTimeToStr(xx);
        if y > 2000 then
        begin
          yy := MaxCD(0.0001, yy);
          Label19.Caption := 'togo: ' +  dDateTimeToStr(xx * (ymax * MCalcThreadStats.iTotalThreadCount - yy) / yy *
                                           (MCalcThreadStats.iTotalThreadCount / Max(c, 1)));
        end;
      end
      else if MCalcThreadStats.iProcessingType = 4 then
        y := Max(0, GetTickCount - MCalcThreadStats.cCalcTime);
    end;

    if c = 0 then
    begin
      if not isRepainting then CloseTries := 0;
      Timer4.Enabled := False;
      c := MCalcThreadStats.iProcessingType;
      MCalcThreadStats.iProcessingType := 0;
      if MCalcStop or not (c in [1, 6]) then MCalcThreadStats.iTotalThreadCount := 0;
      Label19.Caption := '';
      Label6.Caption := '';
      Label1.Caption := '';
      ProgressBar1.Visible := False;
      if not MCalcStop then
      begin          //Postprocessings of single procs
        case c of    //0: not calculating, 1: main calculation, 2: hard shadow postcalc, 3: NsOnZBuf, 4: AO, 5: free, 6: Reflections, 7: DOF
      1, 10:  begin
                MHeader.iCalcTime := Round(y * 0.01);
                if MHeader.bCalc3D > 0 then CalcStatistic;
                MCalcThreadStats.iTotalThreadCount := 0;
                if (AnimationForm.AniOption <= 0) and (c = 1) then LightAdjustForm.MakeHisto;
              end;
          3:  begin //HS
                MHeader.iCalcHStime := Round(y * 0.01);
                Label8.Caption := IntToTimeStr(MHeader.iCalcHStime);
                for z := 0 to 5 do
                  HeaderLightVals.iHScalced[HeaderLightVals.SortTab[z]] :=
                    (MHeader.bHScalculated shr (z + 2)) and 1;
              end;
          4:  begin //AO
                MHeader.iAmbCalcTime := Round(y * 0.01);
                Label48.Caption := IntToTimeStr(MHeader.iAmbCalcTime);
                if (MHeader.bCalcAmbShadowAutomatic and 12) = 8 then
                  if SSAORiteration < MHeader.SSAORcount then c := 3;
              end;
          6:  begin //Reflects
                MHeader.iReflectsCalcTime := Round(y * 0.01);
                Label50.Caption := IntToTimeStr(MHeader.iReflectsCalcTime);
              end;
        end;

        x := 1 shl c;
        while (x < 256) and ((MCalcThreadStats.iAllProcessingOptions and x) = 0) do x := x shl 1;
      //  if (x = 64) and (BatchStatus > 0) then x := 0;

        if (MCalcThreadStats.iAllProcessingOptions and x) > 0 then
        begin              //next processing step
          case x of        // 2: NsOnZBuf, 4: hard shadow postcalc, 8: AO, 16: free, 32: Reflections, 64: DOF
            2:  begin
                  Screen.Cursor := crHourGlass;
                  Label6.Caption := 'Normals on ZBuf';  //before HS!
                  try
                    NormalsOnZbuf(@MHeader, @siLight5[0]);
                  finally
                    Screen.Cursor := crDefault;
                  end;
                  MCalcThreadStats.iProcessingType := 2;
                  Timer4.Enabled := True;
                end;
            4:  CalcHardShadow;
            8:  CalcAmbShadow;
       //    16:
           32:  begin //reflections
                  ProgressBar1.Max := MHeader.Height;
                  ProgressBar1.Position := 0;
                  ProgressBar1.Visible := True;
                  Label6.Caption := 'Reflections';
                  RepaintMand3DnoThread;
                  MCalcThreadStats.iProcessingType := 6;
                  UpdateScaledImageFull;
                  if CalcSRT(@MHeader, @HeaderLightVals, @MCalcThreadStats,
                             @siLight5[0], mFSIstart, mFSIoffset, GetCalcRect) then
                  begin
                    iActiveThreads       := MCalcThreadStats.iTotalThreadCount;
                    CalcYact             := -1;
                    ProgressBar1.Visible := True;
                    Timer4.Interval := 1000;
                    Timer4.Enabled := True;
                  end;
                end;  
           64:  begin
                  ProgressBar1.Max := MHeader.Height;
                  ProgressBar1.Position := 0;
                  ProgressBar1.Visible := True;
                  if (MCalcThreadStats.iAllProcessingOptions and 32) = 0 then
                    RepaintMand3DnoThread
                  else UpdateScaledImageFull;
                  DoFrec.SL := @siLight5[0];
                  DoFrec.colSL := @fullSizeImage[0];
                  DoFrec.MHeader := @MHeader;
                  DoFrec.SLoffset := MHeader.Width * 4;
                  DoFrec.Verbose := True;
                  z := (MHeader.bCalcDOFtype shr 1) and 3;
                  for y := 0 to z do
                  if not MCalcStop then
                  begin
                    DoFrec.pass := y;
                    if z > 0 then
                      Label6.Caption := 'DoF calculation pass ' + IntToStr(y + 1) + ' of ' + IntToStr(z + 1)
                    else Label6.Caption := 'DoF calculation';
                    if ((MHeader.bCalcDOFtype shr 3) and 1) = 1 then
                      doDOF(DoFrec)
                    else
                      doDOFsort(DoFrec);
                  end;
                  ProgressBar1.Visible := False;
                  MCalcThreadStats.iAllProcessingOptions := 0;
                end;
          end;
        end;
        if (MCalcThreadStats.iAllProcessingOptions and x) = 0 then
        begin
          if AnimationForm.AniOption > 0 then
          begin
            if MCalcThreadStats.iAllProcessingOptions = 0 then  // for all last processings where no repaint has to occur
              DoSaveAniImage
            else
            begin
              if c > 5 then //SR
              begin
                UpdateScaledImageFull;
                DoSaveAniImage;
              end
              else
              begin
                SaveAniImage := True;
                RepaintMand3D(True);
              end;
            end;
          end
          else if SaveM3IfileAuto then
          begin
            SaveM3I(SaveAutoM3Ifilename, True);
            EnableButtons;
          end
          else if BatchStatus > 0 then
          begin
            if BatchForm1.CheckBox2.Checked then s := IncludeTrailingPathDelimiter(IniDirs[0]) +
              ExtractFileName(BatchForm1.ListView1.Items[BatchForm1.CurrentListIndex].Caption)
            else s := BatchForm1.ListView1.Items[BatchForm1.CurrentListIndex].Caption;
            SaveM3I(s, True);
            BatchForm1.NextFile;
          end
          else if TilingForm.SaveThisTile and (MHeader.TilingOptions <> 0) then  //with TilingForm
          begin
            if MCalcThreadStats.iAllProcessingOptions = 0 then  // for all last processings where no repaint has to occur
              DoSaveTileImage
            else
            begin
              if c > 5 then //SR
              begin
                UpdateScaledImageFull;
                DoSaveTileImage;
              end
              else
              begin
                SaveTileImage := True;
                RepaintMand3D(True);
              end;
            end;
          end
          else
          begin
            if PPFormCreated and PostProForm.CheckBox25.Checked then  //calcSR rect   access violation, not created on startup?
            begin
              PostProForm.Button15.Enabled := True;
              Image1.Cursor := crCross;
            end
            else EnableButtons;
            if (c = 4) and ((MCalcThreadStats.iAllProcessingOptions and $FFF0) = 0) and
               (MCalcThreadStats.iAllProcessingOptions <> 0) then  //calcambsh only if no more calcs... or repaint seperate also in this function
              RepaintMand3D(True)
            else if (c < 4) and ((MCalcThreadStats.iAllProcessingOptions and $FFFC) = 0) then
               RepaintMand3D(True)
            else if c > 4 then
              UpdateScaledImageFull;
          end;
        end;
        if (AnimationForm.AniOption <= 0) and (c = 4) then
          for x := 1 to 9 do SetLength(ATrousWL[x], 0);
      end
      else
      begin
        EnableButtons;
        UpdateScaledImageFull;
        if c = 4 then for x := 1 to 9 do SetLength(ATrousWL[x], 0);
        if BatchStatus > 0 then
        begin
          BatchStatus := -1;
          BatchForm1.NextFile;
        end;
      end;
    end;
end;

procedure TMand3DForm.Timer5Timer(Sender: TObject);
begin  //only on start check if all forms are made then start app
    if FGUIFormCreated and LAFormCreated then
    begin
      Timer5.Enabled := False;
      FirstShowUpdate;
      LightAdjustForm.Visible := True;
      FormulaGUIForm.Visible := True;
      LoadStartupParas;
    end;
end;

procedure TMand3DForm.Timer6Timer(Sender: TObject);
begin
    if not isRepainting then
    begin
      Inc(RepaintCounter);
      Timer6.Enabled := False;
      PaintRect(DrawRect);
    end;
end;

// http://docs.embarcadero.com/products/rad_studio/delphiAndcpp2009/HelpUpdate2/EN/html/devcommon/delphiioerrors_xml.html
procedure TMand3DForm.SaveCurrParamAsM3P( const Filename: String );
var f: file;
  procedure CheckIOError(const Part: Integer);
  var
    ErrCode: Integer;
  begin
    ErrCode := IOResult;
    if ErrCode <> 0 then
      raise Exception.Create('IOError<' + IntToStr(Part)+'>: '+IntToStr(ErrCode));
  end;
begin
  MakeHeader;
  AssignFile(f, ChangeFileExtSave(Filename, '.m3p'));
  CheckIOError(1);
  Rewrite(f, 1);
  CheckIOError(2);
  InsertAuthorsToPara(@MHeader, Authors);
  try
    BlockWrite(f, MHeader, SizeOf(MHeader));
  finally
    IniMHeader; //to get pointers back
  end;
  HAddon.bHCAversion := 16;
  BlockWrite(f, HAddon, SizeOf(THeaderCustomAddon));
  CheckIOError(2);
  CloseFile(f);
  CheckIOError(3);
end;

procedure TMand3DForm.Button4Click(Sender: TObject);  // save parameter
var f: file;
begin
  if SaveDialog2.Execute then
  begin
    SaveCurrParamAsM3P( SaveDialog2.FileName );
    SetSaveDialogNames(SaveDialog2.FileName);
  end;
end;

procedure TMand3DForm.Button5Click(Sender: TObject);  // open parameter
begin
    if OpenDialog1.Execute and LoadParameter(MHeader, OpenDialog1.FileName, True) then
    begin
      AllPresetsUp;
      OutMessage('Parameters loaded, press "Calculate 3D" to render.');
      ClearScreen;
      SetSaveDialogNames(OpenDialog1.FileName);
    end;
end;

procedure TMand3DForm.Button7Click(Sender: TObject);
var x, y, z: Double;
 //   Q: TQuaternion;
begin
    //apply euler angles to image -> make rotation matrix from euler
    x := StrToFloatK(Edit27.Text) * Pid180;
    y := StrToFloatK(Edit31.Text) * Pid180;
    z := StrToFloatK(Edit32.Text) * Pid180;
   { Q := EulerToQuat(x, y, z);
    CreateMatrixFromQuat(MHeader.hVGrads, Q);  }

    BuildRotMatrix(x, y, z, @MHeader.hVGrads);
    NormVGrads(@MHeader);
    //Test to see new angles
    SetEulerEditsFromHeader;
    ParasChanged;
end;

procedure TMand3DForm.MButtonsUp;
begin
    SpeedButton1.Down := False;
    SpeedButton2.Down := False;
    SpeedButton4.Down := False;
    notAllButtonsUp   := False;
end;

procedure TMand3DForm.MeshExportBtnClick(Sender: TObject);
begin
  BulbTracerFrm.Visible := True;
  BringToFront2(BulbTracerFrm.Handle);
end;

procedure TMand3DForm.SetImageCursor;
begin
    if (iGetPosFromImage > 0) or (PPFormCreated and
       (PostProForm.CheckBox25.Checked or PostProForm.CheckBox21.Checked)) then Image1.Cursor := crCross
    else if SpeedButton2.Down then Image1.Cursor := crHandPoint
    else Image1.Cursor := crDefault;
end;

procedure TMand3DForm.SpeedButton1Click(Sender: TObject);
begin
    if Image1.Cursor <> crHourGlass then SetImageCursor;
    notAllButtonsUp := SpeedButton1.Down or SpeedButton2.Down or SpeedButton4.Down;
end;

procedure TMand3DForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var vec4: TVec4D;
    v: TVec3D;
    i: Integer;
begin
    if not (Image1.Cursor = crHourGlass) then
    begin
      GetCursorPos(MStartPos);
      MOrigStartPos := Point(X, Y);
      MmaxShapeWid  := 0;
      MZtranslate   := 0;
      if Image1.Cursor = crHandPoint then
      begin
        Shape1.SetBounds(Image1.Left, Image1.Top, Image1.Width, Image1.Height);
        if (ssLeft in Shift) then Shape1.Visible := True;
      end
      else if (Image1.Cursor = crCross) and (ssLeft in Shift) then
      begin
        if PostProForm.CheckBox21.Checked or PostProForm.CheckBox25.Checked then  //reflections preview
        begin
          MXYStartPos := Point(X, Y);
          PostProForm.iRect := Rect(X * ImageScale, Y * ImageScale, X * ImageScale, Y * ImageScale);
          Shape1.SetBounds(X + Image1.Left, Y + Image1.Top, 0, 0);
          Shape1.Visible := True;
        end  
        else if iGetPosFromImage > 0 then  //if ssRight in Shift then popupmenu1.popup(x,y);
        begin
          if iGetPosFromImage in [1, 10] then       //DOF Zsharp
          begin
            CalcStepWidth(@MHeader);
            if iGetPosFromImage = 1 then
            begin
              if SizeOK(False) then PostProForm.Edit1.Text :=
                FloatToStrSingle(GetZPos(X * ImageScale, Y * ImageScale,
                @MHeader, @siLight5[0]) / (MHeader.dStepWidth * MHeader.Width));
              PostProForm.Button2.Caption := 'Get Z1';
            end else begin
              if SizeOK(False) then PostProForm.Edit10.Text :=
                FloatToStrSingle(GetZPos(X * ImageScale, Y * ImageScale,
                @MHeader, @siLight5[0]) / (MHeader.dStepWidth * MHeader.Width));
              PostProForm.Button18.Caption := 'Get Z2';
            end;
          end
          else if iGetPosFromImage = 2 then  //posLight midpoint
          begin
            i := LightAdjustForm.TabControl1.TabIndex;
            LightAdjustForm.ButtonGetPos.Caption := 'mid';
            CalcRealPosOffsetsFromImagePos(X * ImageScale, Y * ImageScale, @MHeader, @siLight5[0], @v);
            v := AddVecF(v, GetRealMidPos(@MHeader));
            LightAdjustForm.LAposMids[i] := TPos3D(v);
            SetLightPosFromDVec(LightAdjustForm.LAtmpLight.Lights[i], v);
            LightAdjustForm.TrackBar16Change(LightAdjustForm.TrackBar16);
          end
          else if iGetPosFromImage in [3, 6, 22] then  //Julia Vals, cutting vals, get midpoint
          begin
            CalcRealPosOffsetsFromImagePos(X * ImageScale, Y * ImageScale, @MHeader, @siLight5[0], @vec4);
            vec4[3] := 0;
            AddVec(@vec4, GetRealMidPos(@MHeader));
            case iGetPosFromImage of
         3: begin
              Rotate4Dvec(vec4);
              Edit28.Text := FloatToStr(vec4[0]);
              Edit29.Text := FloatToStr(vec4[1]);
              Edit30.Text := FloatToStr(vec4[2]);
              Edit7.Text := FloatToStr(vec4[3]);
              CheckBox7.Checked := True;
              Button16.Caption := 'Get values from image';
            end;
        22: begin
              v[0] := MHeader.dZmid - MHeader.dZstart;
              v[1] := MHeader.dZend - MHeader.dZmid;
              Edit1.Text := FloatToStr(vec4[2] - v[0]);  //zstart
              Edit17.Text := FloatToStr(vec4[2]); //zmid
              Edit3.Text := FloatToStr(vec4[2] + v[1]);  //zend
              Edit9.Text := FloatToStr(vec4[0]);  //xmid
              Edit10.Text := FloatToStr(vec4[1]); //ymid
              // rotate view + mod zstart to get the same camera pos?
              SpeedButton30.Caption := 'get midpoint';
            end;
         6: begin
              Edit23.Text := FloatToStr(vec4[0]);   //cutting
              Edit24.Text := FloatToStr(vec4[1]);
              Edit22.Text := FloatToStr(vec4[2]);
              CheckBox4.Checked := True;
              CheckBox5.Checked := True;
              CheckBox6.Checked := True;
              Button20.Caption := 'Get values from image';
            end;
            end;
            ParasChanged;
          end
          else if iGetPosFromImage = 4 then  //Stereo Zpoint of Screen, calc min distance, not ready yet
          begin
            if SizeOK(False) then
              vec4[0] := GetZPos(X * ImageScale, Y * ImageScale, @MHeader, @siLight5[0]);  //abs val relative to zstart
//      Edit15.Text := FloatToStrSingle(StereoScreenWidth);
  //    Edit18.Text := FloatToStrSingle(StereoScreenDistance);
         //   MHeader.StereoMinDistance := ;

         //rotation angle of y axis is: dr := FOVx * -0.065 / StereoScreenWidth; //FOVx := dFOVy * Pid180 * Width / Height;

            Edit13.Text := FloatToStrSingle(MHeader.StereoMinDistance);
            Button17.Caption := 'Get min.dist. from image';
          end;
          iGetPosFromImage := 0;
          SetImageCursor;
        end
        else if Shape2.Visible then ModColOnImage(X * ImageScale, Y * ImageScale);
      end;
    end;
end;

procedure TMand3DForm.ModColOnImage(X, Y: Integer);
var ModOTrap, ShapeRect, ColCycling: LongBool;
    sCStart, sCmul, sColZmul, StepWid, DCIplus, st: Single;
    ps, ps2: TPsiLight5;
    ir, irr, ix, iy, wCol, wInOut, maxZdiff, iZ, iZ0, wid, hei: Integer;
    Zcorr, ZcMul, ZZstmitDif, ZZ: Double;
begin
    if not SizeOk(True) then Exit;
    GetPaintTileSizes(@MHeader, wid, hei, ix, iy);
    if (X < 0) or (Y < 0) or (X >= wid) or (Y >= hei) then Exit;
    ir := (Shape2.Width div 2) * ImageScale;  //radius
    ShapeRect := Shape2.Shape = stRectangle;
    if ShapeRect then Dec(ir);
    irr := ir * ir;
    if (not ShapeRect) and (irr < 10) and (irr > 3) then Dec(irr, 2);
    ps := @siLight5[X + Y * wid];
    if ps.Zpos > 32767 then Exit;
    sColZmul := MHeader.Light.VarColZpos * -0.005 / (MHeader.dStepWidth * MHeader.Width);
    CalcPPZvals(MHeader, Zcorr, ZcMul, ZZstmitDif);
    Zcorr := 1 / Zcorr;
    ZcMul := 1 / ZcMul;
    iZ0 := PInteger(@ps.RoughZposFine)^ shr 8;
    ZZ := (Sqr((8388351.5 - iZ0) * ZcMul + 1) - 1) * Zcorr;
    maxZdiff := Round(2 * ir * (1 + ZZ * GetDEstopFactor(@MHeader)) / Abs(ZZ - (Sqr((8388352.5 - iZ0) * ZcMul + 1) - 1) * Zcorr));
    ModOTrap := LightAdjustForm.CheckBox2.Checked and (DrawInOutside = 0);
    ColCycling := LightAdjustForm.CheckBox1.Checked;
    CalcSCstartAndSCmul(@MHeader, sCStart, sCmul, DrawInOutside = 1);
    sCmul := 1 / sCmul;
    if sCmul < 0 then DCIplus := -1 else DCIplus := 1;
    StepWid := MHeader.dStepWidth;
    if DrawInOutside = 1 then
    begin
      sCStart := sCStart - 32768;
      wInOut := $8000;
    end else wInOut := 0;
    for iy := -ir to ir do if (Y + iy >= 0) and (Y + iy < hei) then
    for ix := -ir to ir do if (X + ix >= 0) and (X + ix < wid) then
    if ShapeRect or (Sqr(iy) + Sqr(ix) < irr) then    //3x3 9   2,0 4  2,1 5  2,2 8
    begin
      ps2 := @siLight5[X + ix + (Y + iy) * wid];
      if ps2.Zpos > 32767 then Continue;
      iZ := PInteger(@ps2.RoughZposFine)^ shr 8;
      ZZ := (Sqr((8388351.5 - iZ) * ZcMul + 1) - 1) * Zcorr;
      if Abs(iZ0 - iZ) <= maxZdiff then
      begin    //DrawColSIndex * 32767 = ((wCol - sCStart) * sCmul + sColZmul * (ZZ * StepWidth + ZZstmitDif)) * 16384) and $7FFF
        wCol := Round(MinMaxCS(-1e9, (DrawColSIndex * 2 - sColZmul * (ZZ * StepWid + ZZstmitDif)) * sCmul + sCStart, 1e9));
        if (wCol < 0) or (wCol > 32767) then
        begin
          if ColCycling then
          begin
            if wCol < 0 then st := DCIplus else st := -DCIplus;
            wCol := Round(MinMaxCS(-1e9, ((DrawColSIndex + st) * 2 - sColZmul * (ZZ * StepWid + ZZstmitDif)) * sCmul + sCStart, 1e9));
            if (wCol < 0) or (wCol > 32767) then Continue;
          end
          else Continue;//sometimes it is clipped dependend on adjustment settings
        end;
        if ModOTrap then
        begin
          ps2.OTrap := wCol;
          ps2.SIgradient := ps2.SIgradient and $7FFF;// or wInOut;
        end
        else ps2.SIgradient := wCol or wInOut;
      end;
    end;
    TriggerRepaintDraw(Rect(X - ir, Y - ir, X + ir, Y + ir));
end;

procedure TMand3DForm.MutaGenBtnClick(Sender: TObject);
begin
  MutaGenFrm.Visible := True;
  BringToFront2(MutaGenFrm.Handle);
  MutaGenFrm.RestartFromMain;
end;

procedure TMand3DForm.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var MAktPos: TPoint;
    ih, iy, sl, sw, st, sh: Integer;
begin
    if (ssLeft in Shift) and (Image1.Cursor <> crHourGlass) and
       (Image1.Cursor <> crCross) and notAllButtonsUp then
    begin
      GetCursorPos(MAktPos);
      if Image1.Cursor = crHandPoint then
        Shape1.SetBounds(MaktPos.X - MStartPos.X + Image1.Left,
              MaktPos.Y - MStartPos.Y + Image1.Top, Image1.Width, Image1.Height)
      else
      begin
        if SpeedButton4.Down then
        begin
          MZtranslate := MStartPos.Y - MaktPos.Y;
          Label20.Caption := IntToStr(-MZtranslate);
        end
        else
        begin
          ih := (Abs(MOrigStartPos.X - X) * Image1.Height) div Image1.Width;
          if Y > MOrigStartPos.Y then iy := 0 else iy := ih;
          Shape1.SetBounds(Min(MOrigStartPos.X, X) + Image1.Left,
                           MOrigStartPos.Y - iy + Image1.Top,
                           Abs(MOrigStartPos.X - X) + 1, ih);
          if Shape1.Width > MmaxShapeWid then MmaxShapeWid := Shape1.Width;
        end;
      end;
      if not SpeedButton4.Down then Shape1.Visible := True;
    end
    else if (Image1.Cursor = crCross) and (ssLeft in Shift) and
      (PostProForm.CheckBox21.Checked or PostProForm.CheckBox25.Checked) and Shape1.Visible then
    begin
      if X > MXYStartPos.X then
      begin
        PostProForm.iRect.Right := X * ImageScale;
        PostProForm.iRect.Left := MXYStartPos.X * ImageScale;
        sl := MXYStartPos.X;
        sw := X - sl + 1;
      end else begin
        PostProForm.iRect.Right := MXYStartPos.X * ImageScale;
        PostProForm.iRect.Left := X * ImageScale;
        sl := X;
        sw := MXYStartPos.X - X + 1;
      end;
      if Y > MXYStartPos.Y then
      begin
        PostProForm.iRect.Bottom := Y * ImageScale;
        PostProForm.iRect.Top := MXYStartPos.Y * ImageScale;
        st := MXYStartPos.Y;
        sh := Y - st + 1;
      end else begin
        PostProForm.iRect.Bottom := MXYStartPos.Y * ImageScale;
        PostProForm.iRect.Top := Y * ImageScale;
        st := Y;
        sh := MXYStartPos.Y - Y + 1;
      end;
      Shape1.SetBounds(sl + Image1.Left, st + Image1.Top, sw, sh);
    end
    else if Shape2.Visible then
    begin
      sh := Shape2.Width div 2;
      Shape2.Left := X - sh + Image1.Left;
      Shape2.Top := Y - sh + Image1.Top;
      if ssLeft in Shift then ModColOnImage(X * ImageScale, Y * ImageScale);
    end;
  {  //test
    CalcRealPosOffsetsFromImagePos(X * ImageScale, Y * ImageScale, @MHeader, @siLight5[0], @Pos3);
    Label19.Caption := FloatToStrSingle(Pos3[0] + MHeader.dXmid) + ',' +
                       FloatToStrSingle(Pos3[1] + MHeader.dYmid) + ',' +
                       FloatToStrSingle(Pos3[2] + MHeader.dZmid); }
end;

procedure TMand3DForm.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var xh, yh, xx, yy, dZ: Double;
    Update: LongBool;
    iLeft, iTop: Integer;
    M: TMatrix3;
begin
    if (Image1.Cursor <> crHourGlass) and (Image1.Cursor <> crCross) and
      notAllButtonsUp then
    with MHeader do
    begin
      if Shape1.Width < 8 then Shape1.Visible := False;
      Update := False;
      iLeft  := Shape1.Left - Image1.Left;
      iTop   := Shape1.Top  - Image1.Top;
      xh     := Image1.Width  * 0.5;
      yh     := Image1.Height * 0.5;
      xx     := 0;
      yy     := 0;
      dZ     := 1;
      if Image1.Cursor = crHandPoint then  //shift image
      begin
        if Button = mbLeft then
        begin
          xx     := - iLeft;
          yy     := - iTop;
          Update := True;
        end;
      end
      else if Shape1.Visible then
      begin
        xx := iLeft + Shape1.Width  * 0.5 - xh;
        yy := iTop  + Shape1.Height * 0.5 - yh;
        Update := True;
      end
      else if MmaxShapeWid < 8 then
      begin
        xx := X - xh;
        yy := Y - yh;
        Update := True;
      end;
      if Update then
      begin
        if SpeedButton4.Down then  // Zpos
        begin
          Label20.Caption := '';
          xx := 0;
          yy := 0;
          Update := MZtranslate <> 0;
        end
        else
        begin
          MZtranslate := 0;
          if Shape1.Visible then  // marking zoom
            dZ := Image1.Width / Shape1.Width
          else                    // click zoom    todo: if clicked pixel has zpos < 32768 do calc new pos on Zpos and FOVy
            if Button = mbLeft then dZ := 1.4      //zoom in
                               else dZ := 1 / 1.4; //zoom out
        end;
        if Update then
        begin
          MakeHeader;

          xx := xx * ImageScale;
          yy := yy * ImageScale;
          MZtranslate := MZtranslate * ImageScale;

          yh := 2.1345 / (dZoom * Width);
          yh := yh * (1 + Sin(dFOVy * Pid180) * (dZmid - dZstart) / (yh * Height));

          M := NormaliseMatrixTo(yh, @hVGrads);
          dXmid := dXmid + xx * M[0, 0] + yy * M[1, 0] - MZtranslate * M[2, 0];
          dYmid := dYmid + xx * M[0, 1] + yy * M[1, 1] - MZtranslate * M[2, 1];
          yh    := xx * M[0, 2] + yy * M[1, 2] - MZtranslate * M[2, 2];
          if Abs(dZ - 1) > 1e-4 then
          begin
            dZoom       := dZoom * dZ;
            Edit5.Text  := FloatToStr(dZoom);
            dZstart     := dZmid + (dZstart - dZmid) / dZ;
            dZend       := dZmid + (dZend - dZmid) / dZ;
          end;
          dZend   := dZend + yh;
          dZmid   := dZmid + yh;
          dZstart := dZstart + yh;
          Edit1.Text  := FloatToStr(dZstart);
          Edit3.Text  := FloatToStr(dZend);
          Edit9.Text  := FloatToStr(dXmid);
          Edit10.Text := FloatToStr(dYmid);
          Edit17.Text := FloatToStr(dZmid);
          SliceCalc   := 2;
          Timer1.Enabled := True;
        end;
      end;
      Shape1.Visible := False;
    end;
end;

procedure TMand3DForm.SaveM3I(FileName: String; bSaveImgBuf: LongBool);
var f: file;
begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      MHeader.bImageScale := ImageScale;
      LightAdjustForm.PutLightFInHeader(MHeader);
      AssignFile(f, ChangeFileExtSave(FileName, '.m3i'));
      Rewrite(f, 1);
      InsertAuthorsToPara(@MHeader, Authors);
      try
        BlockWrite(f, MHeader, SizeOf(MHeader));
      finally
        IniMHeader;
      end;
      BlockWrite(f, siLight5[0], SizeOf(TsiLight5) * Length(siLight5));
      HAddon.bHCAversion := 16;
      BlockWrite(f, HAddon, SizeOf(THeaderCustomAddon));
      if bSaveImgBuf then
        BlockWrite(f, fullSizeImage[0], Length(fullSizeImage) * SizeOf(Cardinal));
      CloseFile(f);
    finally
      Screen.Cursor := crDefault;
    end;
end;

procedure TMand3DForm.Button8Click(Sender: TObject);  // save full m3i
var TileSize: TPoint;
begin
    TileSize := GetTileSize(@MHeader);    //check imagesize
    if (Length(siLight5) <> TileSize.X * TileSize.Y) and
      (MessageDlg('The Imagesize does not fit to the parameters, store anyways?',
                  mtWarning, [mbYes, mbNo], 0) = mrNo) then Exit;
    if SaveDialog3.Execute then
    begin
      SaveM3I(SaveDialog3.FileName, CheckBox16.Checked);
      SetSaveDialogNames(SaveDialog3.FileName);
    end;
end;

procedure TMand3DForm.Button9Click(Sender: TObject);  // open full m3i
begin
    if OPD.Execute then
    begin
      Timer1.Enabled := False;
      LoadFullM3I(MHeader, OPD.FileName);
      AllPresetsUp;
      SetSaveDialogNames(OPD.FileName);
    end;
end;

procedure TMand3DForm.ButtonAuthorClick(Sender: TObject);
var s: String;
begin
    s := Copy(InputBox('Authorname', 'Maximum 16 characters!', IniVal[33]), 1, 16);
    if not CheckAuthorValid(s) then
    begin
      ShowMessage('This name is not valid, max 16 characters and not to much uncommon characters.');
      Exit;
    end
    else IniVal[33] := s;
end;

procedure TMand3DForm.ButtonInsertAuthorClick(Sender: TObject);
begin
    if IniVal[33] = '' then Exit;
    if (Edit33.Text = '') then Edit33.Text := IniVal[33] else
    if (Edit33.Text <> IniVal[33]) then Edit34.Text := IniVal[33];
end;

procedure TMand3DForm.ButtonR0Click(Sender: TObject);
begin
    BuildRotMatrix(0, 0, 0, @MHeader.hVGrads);
    NormVGrads(@MHeader);
    SetEulerEditsFromHeader;
    ParasChanged;
end;

procedure TMand3DForm.ButtonVolLightClick(Sender: TObject);
begin
    if ButtonVolLight.Caption = 'Dyn. fog on It.:' then
      MHeader.bVolLightNr := 1 or (2 shl 4)
    else MHeader.bVolLightNr := 2 shl 4;
    SetEdit16Text;
end;

procedure TMand3DForm.PageControl1Change(Sender: TObject);
var i: Integer;
begin
    if CheckBox7.Checked then TabSheet9.Caption := 'Julia On'
                         else TabSheet9.Caption := 'Julia Off';
    if CheckBox4.Checked or CheckBox5.Checked or CheckBox6.Checked then
      TabSheet8.Caption := 'Cutting*'
    else TabSheet8.Caption := 'Cutting';
    i := 0;
    case PageControl1.ActivePageIndex of
      0: i := CheckBox2.Top + CheckBox2.Height + 2 - TabSheet2.Height; //calculations
      6: i := Edit16.Top + Edit16.Height + 2 - TabSheet3.Height;       //coloring
      7: i := Button12.Top + Button12.Height + 2 - TabSheet6.Height;   //stereo
    end;
    if i > 0 then PageControl1.Height := PageControl1.Height + i;
end;

procedure TMand3DForm.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //  if Button = mbRight then PopupMenu4.Popup(X, Y);
end;

procedure TMand3DForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if ((MCalcThreadStats.iProcessingType > 0) and Timer4.Enabled and
       ((GetTickCount - CalcStart) > 900000)) or
       (MCForm.Button2.Caption = 'Stop rendering') then
    begin
      if MessageDlg('Do you really want to stop the calculations?', mtWarning,
                    [mbYes, mbNo], 0) = mrNo then
      begin
        CanClose := False;
        Exit;
      end;
    end;
    Inc(RepaintCounter);
    Inc(NglobalCounter);
    MCalcStop := True;
    MCForm.MCCalcStop := True;
    CanClose  := not ((MCalcThreadStats.iProcessingType > 0) or isRepainting or
                     (FNavigator.Visible and FNavigator.isCalculating));
    Inc(CloseTries);
    if CloseTries > 3 then CanClose := True;// else
   // if CloseTries = 2 then StopCalcThreads(MCalcThreadStats);
    if not CanClose then OutMessage('Stopping calculations...(' + IntToStr(CloseTries) + ')');
    AnimationForm.CloseOutPutStream;
end;

procedure TMand3DForm.Image2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    GetCursorPos(MStartPos);
end;

procedure TMand3DForm.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var Mpos: TPoint;
    newWidth, newHeight: Integer;
begin
    if ssLeft in Shift then
    begin
      newWidth  := Width;
      newHeight := Height;
      GetCursorPos(Mpos);
      if Width + Mpos.x - MStartPos.X >= Constraints.MinWidth then
      begin
        newWidth    := Width + Mpos.x - MStartPos.X;
        MStartPos.X := Mpos.X;
      end;
      if Height + Mpos.y - MStartPos.y >= Constraints.MinHeight then
      begin
        newHeight   := Height + Mpos.Y - MStartPos.Y;
        MStartPos.Y := Mpos.Y;
      end;
      if (Width <> newWidth) or (Height <> newHeight) then
        SetBounds(Left, Top, newWidth, newHeight);
    end;
end;

procedure TMand3DForm.SetM3Dini;
var i, j, l, w: Integer;
begin
    j := StrToIntTrim(IniVal[0]);
    FormsSticky[1] := j and 3;
    bAniFormStick := (j shr 2) and 3;
    FormsSticky[0] := (j shr 4) and 3;
    FormsSticky[2] := (j shr 6) and 3;
    Edit4.Text := IniVal[1];
    i := Pos(':', IniVal[11]);  //user aspect
    if i > 0 then
    try
      j := StrToIntTrim(Copy(IniVal[11], i + 1, Length(IniVal[11]) - i));
      if j > 0 then
      begin
        UserAspect.Y := j;
        UserAspect.X := StrToIntTrim(Copy(IniVal[11], 1, i - 1));
      end;
    except
    end;
    CheckBox13.Checked := IniVal[23] <> 'No';
    CheckBox14.Checked := IniVal[30] <> 'No';
    CheckBox15.Checked := IniVal[29] <> '-1';
    CheckBox16.Checked := IniVal[31] = 'Yes';
    if CheckBox15.Checked then ComboBox2.ItemIndex := StrToIntTry(IniVal[29], 2);
    if IniVal[24] <> '' then
    begin  //set pos+size
      l := StrToIntTry(StrFirstWord(IniVal[24]), 65);
      j := StrToIntTry(StrLastWord(IniVal[24]), 100);
      w := StrToIntTry(StrFirstWord(IniVal[25]), 779);
      i := StrToIntTry(StrLastWord(IniVal[25]), 671);
      SetBounds(l, j, w, i);
    end;
    if TryStrToInt(IniVal[13], i) then Label23.Caption := IntToStr(i);
    if TryStrToInt(IniVal[15], i) then if i = 0 then CheckBox11.Checked := False;
    if IniVal[21] <> 'Auto' then // detect corecount
    begin
      CheckBox12.Checked := False;
      UpDown3.Position := Min(64, Max(1, StrToIntTry(IniVal[21], UpDown3.Position)));
    end;
    OPD.InitialDir := IniDirs[0];
    SaveDialog3.InitialDir := IniDirs[0];
    OpenDialog1.InitialDir := IniDirs[1];
    SaveDialog2.InitialDir := IniDirs[1];
    SaveDialog4.InitialDir := IniDirs[2];
    SaveDialog6.InitialDir := IniDirs[2];
    SaveDialog1.InitialDir := IniDirs[2];
end;

procedure TMand3DForm.FirstShowUpdate;  //after light+formula windows were made
var i: Integer;
begin
    Label3.Caption := 'M3D Version ' + ProgramVersionStr(M3dVersion);
    RadioGroup2.Hint := 'Panorama mode:' + #13#10 +
                        '- The FOV is choosen automatically' + #13#10 +
'- Use the 24bit SSAO or DEAO for ambient shadows' + #13#10 +
'- A 2:1 aspect ratio is recommended, but not necessary.';
    Edit19.Hint := 'If set to a higher value than 0, the surface normals will be calculated with an average' + #13#10 +
'of distributed points and a roughness factor is calculated too, resulting in lower aliasing.' + #13#10 +
'A value of 8 will average over a volume, what is very slow but can be used in very' + #13#10 +
'critical situations.  You could also use the Normals on ZBuf in postprocessings.';
    Edit20.Hint := 'Defines how accurate the position with the defined distance to the surface will be calculated.' + #13#10 +
'Higher values leads to more accuracy what leads also to a better normals calculation.' + #13#10 +
'Much more than 12 are rarely needed.';
    UpDown4.Hint := 'Sharpen factor of the saved output image,' + #13#10 +
'works only with downscales of 1:2 and 1:3 !' + #13#10 +
'0: no sharpening ... 3: maximum sharpening';
    Edit16.Hint := 'Dynamic fog:' + #13#10 +
'The lower the number the farer away from the object the fog shows up.' + #13#10 +
'With dIFS, the fog is around the object part calculated at this iteration.' + #13#10 +
'Zero to disable this feature and do the dynamic fog on raystep count as usual.' + #13#10 +
'Hint: Check the ''First step random'' option to prevent steps.' + #13#10 +
'Volumetric light:' + #13#10 +
'Choose the light nr from which lightscattering will be calculated.';
    Image1.Canvas.Brush.Color := clBtnFace;
    Image1.Canvas.Font.Color := clWindowText;
//    if Testing then Showmessage('M3D onshow...');
    MakeHeader;
    BuildRotMatrix(-0.7, -0.0001, 0, @MHeader.hVgrads);
    SetEulerEditsFromHeader;
    Application.HintHidePause  := 20000;
    Application.HintShortPause := 0;
    for i := 0 to 3 do LoadAccPreset(i);
    UpdateAspectCaption;
 //   if Testing then Showmessage('M3D load extern formulas now...');
    if SupportSSE then ChangeMathFuncsToSSE;
    if SupportSSE2 then ChangeMathFuncsToSSE2;
    if SupportSSE then VolLightMapPos := VolLightMapPosSSE;
    if SupportSSE then GetVolLightMapVec := GetVolLightMapVecSSE;

    InternAspect := Max(1, MHeader.Width) / Max(1, MHeader.Height);
    LastHisParSaveTime := Now;
    FastMove(MHeader.Light, LHPSLight, SizeOf(TLightingParas9));
    FormResize(Self); //to do light+formula sticky options
    PageControl1Change(Self); //to fit height
end;

procedure TMand3DForm.LoadStartupParas;
var s: String;
    bStartTimer: LongBool;
begin
    bStartTimer := True;
    if ParamCount > 0 then
    begin
      s := UpperCase(ExtractFileExt(ParamStr(1)));
      if s = '.M3P' then
      begin
        LoadParameter(MHeader, ParamStr(1), True);
        AllPresetsUp;
        OutMessage('Parameters loaded, press "Calculate 3D" to render.');
        ClearScreen;
        bStartTimer := False;
      end
      else if s = '.M3I' then
        StartupLoadM3I := True
      else if (s = '.M3A') and AnimationForm.LoadAni(ParamStr(1)) then
      begin
        AniStartLoad := True;
        AnimationForm.Visible := True;
      end
      else if (s = '.BIG') and TilingForm.LoadBig(ParamStr(1)) then TilingForm.Visible := True;
    end
    else if not LoadParameter(MHeader, AppFolder + 'Default.m3p', True) then
      if not LoadParameter(MHeader, IncludeTrailingPathDelimiter(IniDirs[1]) + 'Default.m3p', True) then
        FormulaGUIForm.TabControl1.OnChange(Self);
    Timer1.Enabled := bStartTimer;
end;

procedure TMand3DForm.FormShow(Sender: TObject);
begin
    Caption := 'Mandelbulb 3D    v' + ProgramVersionStr(M3dVersion);
    SetM3Dini;
//SaveFormulaBytes;
end;

procedure SaveFormulaBytes;
var s: String;
    i, c, ci: Integer;
    f: TextFile;
    P1: PByte;
    Last4: array[0..3] of Byte;
begin
    AssignFile(f, appfolder + 'Test.txt');
    Rewrite(f);
    try
      P1 := PByte(@TestHybrid); //   TestHybrid    HybridCustomIFStest
      s := '';
      c := 0;
      ci := 0;
      for i := 0 to 2000 do
      begin
        s := s + IntToHex(P1^, 2);
        Last4[ci] := P1^;
        if (P1^ = 0) and (c > 3) then //until $5DC20800
        begin
          if (Last4[(ci - 1) and 3] = 8) and (Last4[(ci - 2) and 3] = $C2) and
             (Last4[(ci - 3) and 3] = $5D) then Break;
                                       //1 remove to work
        end;
        if (P1^ = $C3) and (c > 3) then //until  $114EE0C3  (dIFS, only with apply scale+)
        begin
          if (Last4[(ci - 1) and 3] = $E0) and (Last4[(ci - 2) and 3] = $4E) and
             (Last4[(ci - 3) and 3] = $11) then Break;
        end;
        Inc(c);
        ci := (ci + 1) and 3;
        Inc(P1);
        if (i and 31) = 31 then
        begin
          Writeln(f, s);
          s := '';
        end;
      end;
      Writeln(f, s);
    finally
      CloseFile(f);
    end;
end;

procedure TMand3DForm.FormResize(Sender: TObject);
begin
    if LAFormCreated then
    begin
      if FormsSticky[1] = 1 then
        LightAdjustForm.SetBounds(Left + Width, Top, LightAdjustForm.Width,
                                  LightAdjustForm.Height)
      else if FormsSticky[1] = 2 then
        LightAdjustForm.SetBounds(Left - LightAdjustForm.Width, Top,
                                 LightAdjustForm.Width, LightAdjustForm.Height);
    end;
    if FGUIFormCreated then
    begin
      if FormsSticky[0] = 1 then
        FormulaGUIForm.SetBounds(Left + Width, Top, FormulaGUIForm.Width,
                                  FormulaGUIForm.Height)
      else if FormsSticky[0] = 2 then
        FormulaGUIForm.SetBounds(Left - FormulaGUIForm.Width, Top,
                                 FormulaGUIForm.Width, FormulaGUIForm.Height);
    end;
    if AFormCreated and (bAniFormStick = 1) then
      AnimationForm.SetBounds(Left, Top + Height, AnimationForm.Width,
                              AnimationForm.Height);
    if PPFormCreated then
    begin
      if FormsSticky[2] = 1 then
        PostProForm.SetBounds(Left + Width, Top, PostProForm.Width,
                                  PostProForm.Height)
      else if FormsSticky[2] = 2 then
        PostProForm.SetBounds(Left - PostProForm.Width, Top,
                                 PostProForm.Width, PostProForm.Height);
    end;
    Memo1.Height := Min(240, Max(80, Panel1.Height - Memo1.Top - Panel4.Height - 1));
end;

procedure TMand3DForm.Timer8Timer(Sender: TObject);  //Repaint done? + Animation save BMP
var y, ymin, c: Integer;
begin
    ymin := 999999;
    c := 0;
    for y := 0 to RepYThreads - 1 do
    begin
      if RepaintCounts[y] > 0 then Inc(c);
      if RepYact[y] < ymin then ymin := RepYact[y];
    end;
    if ymin >= RepaintYact then
      UpdateScaledImage(RepaintYact div ImageScale, ymin div ImageScale);
    RepaintYact := ymin;
    if c = 0 then
    begin
      Timer8.Enabled := False;
      isRepainting   := False;
      if (AnimationForm.AniOption > 0) and SaveAniImage then DoSaveAniImage else
      if SaveTileImage then DoSaveTileImage else
      if Timer3.Enabled then Timer3Timer(Self) else StoreUndoLight;
    end;
    Timer8.Interval := 100;
end;

procedure TMand3DForm.DisableBchange;
begin
    SpinEdit2.OnChangingEx := nil;
    Edit25.OnChange        := nil;
    Edit6.OnChange         := nil;
    Edit8.OnChange         := nil;
    SpinEdit5.OnChangingEx := nil;
end;

procedure TMand3DForm.EnableBchange;
begin
    SpinEdit2.OnChangingEx := SpinEdit2ChangingEx;
    Edit25.OnChange        := SpinEdit2Change;
    Edit6.OnChange         := SpinEdit2Change;
    Edit8.OnChange         := SpinEdit2Change;
    SpinEdit5.OnChangingEx := SpinEdit2ChangingEx;
end;

procedure TMand3DForm.SpeedButton3Click(Sender: TObject);
var SB: TSpeedButton;
    t: Integer;
begin
    SB := Sender as TSpeedButton;
    t  := SB.Tag;
    if SB.Cursor = crUpArrow then
    begin
      SpeedButton3.Cursor  := crDefault;
      SpeedButton13.Cursor := crDefault;
      SpeedButton5.Cursor  := crDefault;
      SpeedButton6.Cursor  := crDefault;
      SpeedButton10.Down   := False;
      FillInPreset(t);
      SaveAccPreset(t);
    end
    else if SB.Down then SetPreset(t);
end;

procedure TMand3DForm.SpeedButton7Click(Sender: TObject);
begin
    MakeHeader;
    CopyHeaderAsTextToClipBoard(@MHeader, Caption);
end;

procedure TMand3DForm.TextParsLoadSuccess;
begin
    InternAspect := MHeader.Width / Max(1, MHeader.Height);
    ImageScale := Min(10, Max(1, MHeader.bImageScale));
    LoadBackgroundPicT(@MHeader.Light);
    SetEditsFromHeader;
    bUserChange := False;
    LightAdjustForm.CheckBox21.Checked := False;
    bUserChange := True;
    LightAdjustForm.SetLightFromHeader(MHeader);
    if MHeader.Light.BGbmp[0] = 0 then LightAdjustForm.Image5.Visible := False else
      MakeLMPreviewImage(LightAdjustForm.Image5, @M3DBackGroundPic);
    MButtonsUp;
    AllPresetsUp;
    OutMessage('Parameters loaded, press "Calculate 3D" to render.');
    ClearScreen;
    Caption := 'Mandelbulb 3D';
end;

procedure TMand3DForm.SpeedButton8Click(Sender: TObject);
var PC: PChar;
    i: Integer;
    s: String;
begin
    PC := StrAlloc(3000);
    try
      i := Clipboard.GetTextBuf(PChar(PC), 3000);
      if (i > 800) and GetHeaderFromText(StrPas(PC), MHeader, s) then
      begin
        TextParsLoadSuccess;
        Caption := s;
      end
      else
        FTextBox.Visible := True;
    finally
      StrDispose(PC);
    end;
end;

procedure TMand3DForm.SpeedButton10Click(Sender: TObject);
begin
    if SpeedButton3.Cursor = crUpArrow then
    begin
      SpeedButton3.Cursor  := crDefault;
      SpeedButton13.Cursor := crDefault;
      SpeedButton5.Cursor  := crDefault;
      SpeedButton6.Cursor  := crDefault;
      SpeedButton10.Down   := False;
    end else begin
      SpeedButton3.Cursor  := crUpArrow;
      SpeedButton13.Cursor := crUpArrow;
      SpeedButton5.Cursor  := crUpArrow;
      SpeedButton6.Cursor  := crUpArrow;
      AllPresetsUp;
    end;
end;

procedure TMand3DForm.Rotate4Dvec(var vec: TVec4D);
var x, y, z: Double;
    v3b: TVec3D;
    Smatrix4: TSMatrix4;
begin
    if FormulaGUIForm.Panel2.Enabled then
    begin
      x := StrToFloatK(FormulaGUIForm.XWEdit.Text) * Pid180;
      y := StrToFloatK(FormulaGUIForm.YWEdit.Text) * Pid180;
      z := StrToFloatK(FormulaGUIForm.ZWEdit.Text) * Pid180;
      v3b := TPVec3D(@vec)^;
      BuildSMatrix4(x, y, z, Smatrix4);
      Rotate4Dex(@v3b, @vec, @Smatrix4);
    end;
end;

procedure TMand3DForm.RotationBtnClick(Sender: TObject);
begin
  RotationPnl.Top := RotationBtn.Top+RotationBtn.Height;
  RotationPnl.Visible := not RotationPnl.Visible;
end;

procedure TMand3DForm.Button13Click(Sender: TObject);  //insert julia values
var v4: TVec4D;
begin
    v4[0] := StrToFloatK(Edit9.Text);  //mid vals
    v4[1] := StrToFloatK(Edit10.Text);
    v4[2] := StrToFloatK(Edit17.Text);
    v4[3] := 0;
    Rotate4Dvec(v4);
    Edit28.Text := FloatToStr(v4[0]);
    Edit29.Text := FloatToStr(v4[1]);
    Edit30.Text := FloatToStr(v4[2]);
    Edit7.Text := FloatToStr(v4[3]);
      //Wadd
{The following code causes “stay on top” forms to allow a MessageBox to appear on top. After the message box is closed, the topmost forms are restored so that they continue to float to the top.
Begin
  with Application do
  begin
    NormalizeTopMosts;
    MessageBox('This should be on top.', 'Look', MB_OK);
    RestoreTopMosts;
  end;
end; }
{  with Application do
  begin
    NormalizeTopMosts;
    MessageBox(PChar(FloatToStr(v4[3])), 'You have to set the W_Add value in the formula to:', MB_OK);
    RestoreTopMosts;
  end;  }
   //   InputBox('Information', 'You have to set the W_Add value in the formula to:', FloatToStr(v4[3]));
end;

procedure TMand3DForm.SpeedButton12Click(Sender: TObject);
begin
    AnimationForm.Visible := True;
    BringToFront2(AnimationForm.Handle);
end;

procedure TMand3DForm.SpinEdit2Change(Sender: TObject);
begin
    AllPresetsUp;
end;

procedure TMand3DForm.SpinEdit2ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
begin
    AllPresetsUp;
end;

procedure TMand3DForm.FormDestroy(Sender: TObject);
var i: Integer;
begin
    SaveIni(False); //only if filedatetime = lastIniFileDatetime
    for i := 0 to 5 do FreeCF(@HybridCustoms[i]);
    for i := 0 to 5 do FreeCF(@calcHybridCustoms[i]);
    OPD.Free;
end;

procedure TMand3DForm.IniDirsBtnClick(Sender: TObject);
begin
    LoadIni;
    IniDirForm.Visible := True;
end;

procedure TMand3DForm.Button10Click(Sender: TObject);
begin
    FormulaGUIForm.Visible := True;
    BringToFront2(FormulaGUIForm.Handle);
end;

procedure TMand3DForm.ProofPosLight;
begin
    with LightAdjustForm do
    begin
      if (PageControl1.ActivePageIndex = 1) then
      begin
        bUserChange := False;
        SetPosLightTo0(TabControl1.TabIndex);
        PageControl1Change(Self);
        bUserChange := True;
      end;
    end;
end;

procedure TMand3DForm.SpeedButton15Click(Sender: TObject);
begin
    FNavigator.Visible := True;
    BringToFront2(FNavigator.Handle);
end;

procedure TMand3DForm.Button14Click(Sender: TObject);  //reset pos
var d: Double;
begin
    Edit1.Text := '-2.0';
    Edit17.Text := '0.0';
    Edit3.Text := '30.0';
    Edit9.Text := '0.0';
    Edit10.Text := '0.0';
    Edit5.Text := '0.8';
    Edit14.Text := '30';
    BuildRotMatrix(0.0001, -0.0001, 0, @MHeader.hVgrads);
    if TryStrToFloat(FormulaGUIForm.RBailoutEdit.Text, d) and (d > 500) then
    begin
      Edit1.Text := '-8.0';
      Edit17.Text := '0.0';
      Edit3.Text := '120.0';
      Edit5.Text := '0.18';
    end;
    ParasChanged;
    SetEulerEditsFromHeader;
end;

procedure TMand3DForm.Button15Click(Sender: TObject);
begin
    PostProForm.Visible := True;
    BringToFront2(PostProForm.Handle);
end;

procedure TMand3DForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #27) and (Screen.Cursor = crNone) then FNavigator.ChangeNaviMode;
end;

procedure TMand3DForm.SpeedButton19Click(Sender: TObject);  //aspect
var t, wid: Integer;
    b: LongBool;
begin
    t := (Sender as TSpeedButton).Tag;
    wid := StrToIntTrim(Edit11.Text);
    b := bUserChange;
    bUserChange := False;
    case t of
      1:  Edit12.Text := IntToStr((wid * 3) div 4);
      2:  Edit12.Text := IntToStr((wid * 3) div 5);
      3:  if UserAspect.X > 0 then
            Edit12.Text := IntToStr((wid * UserAspect.Y) div UserAspect.X);
    end;
    MHeader.Height := StrToIntTry(Edit12.Text, MHeader.Height);
    MHeader.TilingOptions := 0;
    CheckBox10Click(Sender);
    bUserChange := b;
end;

procedure TMand3DForm.UpdateAspectCaption;
begin
    if UserAspect.X > 0 then
      SpeedButton21.Caption := IntToStr(UserAspect.X) + ':' + IntToStr(UserAspect.Y)
    else
      SpeedButton21.Caption := 'user';
end;

procedure TMand3DForm.SpeedButton21MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
begin
    if ssRight in Shift then    //define user aspect ratio
    begin
      i := StrToIntTrim(InputBox('User defined aspect ratio', 'Input the width factor:', '16'));
      if i < 1 then Exit;
      UserAspect.X := i;
      i := StrToIntTrim(InputBox('User defined aspect ratio', 'Input the height divisor:', '9'));
      if i < 1 then
      begin
        UserAspect.X := 0;
        Exit;
      end;
      UserAspect.Y := i;
      UpdateAspectCaption;
      IniVal[11] := SpeedButton21.Caption;
    end;
end;
        
procedure TMand3DForm.Edit11Change(Sender: TObject);
var i: Integer;
    s: Single;
begin
    if bUserChange then
    begin
      AllPresetsUp;
      if CheckBox10.Checked and ((Sender as TEdit).Tag > 0) then
      begin
        if (Sender as TEdit).Tag = 1 then  //width changing
        begin
          if TryStrToInt(Trim(Edit11.Text), i) and (i > 0) then
          begin
            s := i / MHeader.Width;
            bUserChange := False;
            Edit12.Text := IntToStr(Round(i / InternAspect));
            ScaleDEstop(s);
            ScaleRclip(s);
            bUserChange := True;
          end;
        end
        else if (Sender as TEdit).Tag = 2 then  //height changing
        begin
          if TryStrToInt(Trim(Edit12.Text), i) and (i > 0) then
          begin
            bUserChange := False;
            Edit11.Text := IntToStr(Round(i * InternAspect));
            if TryStrToInt(Trim(Edit11.Text), i) and (i > 0) then
            begin
              s := i / MHeader.Width;
              ScaleDEstop(s);
              ScaleRclip(s);
            end;
            bUserChange := True;
          end;
        end;
      end;
      if TryStrToInt(Trim(Edit11.Text), i) and (i > 0) then
        MHeader.Width := i;
      if TryStrToInt(Trim(Edit12.Text), i) and (i > 0) then
        MHeader.Height := i;
      MHeader.TilingOptions := 0;
    end;
end;

procedure TMand3DForm.Edit33Change(Sender: TObject);
begin
    if bUserChange then Authors[0] := Edit33.Text;
end;

procedure TMand3DForm.Edit34Change(Sender: TObject);
begin
    if bUserChange then Authors[1] := Edit34.Text;
end;

procedure TMand3DForm.SpeedButton18MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var rot: Double;
    M: TMatrix3;
begin
    ProofPosLight;
    MakeHeader;         // +.. store Undo in Header files!
    with MHeader do
    begin
      rot := StrToFloatK(Edit4.Text) * MPid180;
      case (Sender as TSpeedButton).Tag of
        11:  BuildRotMatrix(rot, 0, 0, @M);
        12:  BuildRotMatrix(-rot, 0, 0, @M);
        13:  BuildRotMatrix(0, -rot, 0, @M);
        14:  BuildRotMatrix(0, rot, 0, @M);
        15:  BuildRotMatrix(0, 0, rot, @M);
        16:  BuildRotMatrix(0, 0, -rot, @M);
      end;
      if Button = mbLeft then
      begin
        Multiply2Matrix(@M, @hVgrads);
        hVgrads := M;
      end else begin
        Multiply2Matrix(@hVgrads, @M);
        RotateVectorReverse(@dXmid, @M);
        SetEditsFromHeader;
      end;
      SliceCalc := 2;
      Timer1.Enabled := True; //calc2D
    end;
end;

procedure TMand3DForm.SpeedButton25Click(Sender: TObject);  //Batch process
begin
    BatchForm1.Visible := True;
    BringToFront2(BatchForm1.Handle);
end;

procedure TMand3DForm.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    Accept := True;
end;

procedure TMand3DForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    Shape1.Visible := False;
end;

procedure TMand3DForm.Shape2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
    if ssRight in Shift then
    begin
      p := Point(X, Y);
      p := Shape2.ClientToScreen(p);
      PopupMenu4.Popup(p.X, p.Y);
    end
    else
      Image1MouseDown(Sender, Button, Shift, X + Shape2.Left - Image1.Left, Y + Shape2.Top - Image1.Top);
end;

procedure TMand3DForm.Shape2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    Image1MouseMove(Sender, Shift, X + Shape2.Left - Image1.Left, Y + Shape2.Top - Image1.Top);
end;

procedure TMand3DForm.ShapeBox1Click(Sender: TObject);
begin
    Shape2.Shape := stRectangle;
end;

procedure TMand3DForm.ShapeDisc1Click(Sender: TObject);
begin
    Shape2.Shape :=stCircle;
end;

procedure TMand3DForm.SpeedButton9MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then RestoreUndo else
    if Button = mbRight then Redo else Exit;
    SetEditsFromHeader;
    LightAdjustForm.SetLightFromHeader(MHeader);
    LightAdjustForm.ComboBox3.ItemIndex := -1;
    FormulaGUIForm.TabControl1Change(Sender);
    ParasChanged;
    AllPresetsUp;
end;

procedure TMand3DForm.SpeedButton26Click(Sender: TObject);  //Save Zbuf
begin
    if SaveDialog6.Execute then SaveZBuf(SaveDialog6.Filename, SaveDialog6.FilterIndex);
end;

procedure TMand3DForm.SaveDialog6TypeChange(Sender: TObject);
var S: String;
begin
    case SaveDialog6.FilterIndex of
      1:  SaveDialog6.DefaultExt := 'bmp';
      2:  SaveDialog6.DefaultExt := 'png';
    end;
    S := SaveDialog6.Filename;
    if SysUtils.DirectoryExists(S) then S := '';
    if S <> '' then
      case SaveDialog6.FilterIndex of
        1:  S := ChangeFileExt(S, '.bmp');
        2:  S := ChangeFileExt(S, '.png');
      else
        S := '';
      end;
    if S <> '' then
      SendMessage(GetParent(SaveDialog6.Handle), CDM_SETCONTROLTEXT, $480, Longint(PChar(ExtractFileName(S))));
end;

procedure TMand3DForm.SaveImageO(OutputType: Integer; FileNam: String);
var TileRect: TRect;
    Crop: Integer;
    bmp: TBitmap;
begin
    if (MHeader.TilingOptions shr 28) and 3 <> 0 then
    begin
      GetTilingInfosFromHeader(@MHeader, TileRect, Crop);
      SdoAA;
      bmp := TBitmap.Create;
      try
        bmp.PixelFormat := pf24bit;
        bmp.SetSize((TileRect.Right - TileRect.Left + 1 - 2 * Crop) div ImageScale,
          (TileRect.Bottom - TileRect.Top + 1 - 2 * Crop) div ImageScale);
        bmp.Canvas.CopyRect(Rect(0, 0, bmp.Width, bmp.Height), Mand3DForm.Image1.Picture.Bitmap.Canvas,
            Rect(Crop div ImageScale, Crop div ImageScale,
                 Crop div ImageScale + bmp.Width, Crop div ImageScale + bmp.Height));
        case OutputType of
          0:  SavePNG(FileNam, bmp, CheckBox13.Checked);
          1:  SaveJPEGfromBMP(FileNam, bmp, StrToIntTry(Edit26.Text, 95));
          2:  SaveBMP(FileNam, bmp, pf24bit);
        end;
      finally
        bmp.Free;
      end;
    end
    else
    begin
      SdoAA;
      case OutputType of
        0:  SavePNG(FileNam, Mand3DForm.Image1.Picture.Bitmap, CheckBox13.Checked);
        1:  SaveJPEGfromBMP(FileNam, Mand3DForm.Image1.Picture.Bitmap, StrToIntTry(Edit26.Text, 95));
        2:  SaveBMP(FileNam, Mand3DForm.Image1.Picture.Bitmap, pf24bit);
      end;
    end;
end;

procedure TMand3DForm.Button3Click(Sender: TObject);    //save BMP,PNG
var i, c: Integer;
begin
    Val(IniVal[16], i, c);
    if c = 0 then SaveDialog6.FilterIndex := i + 1;
    if SaveDialog6.Execute then
    begin
      IniVal[16] := IntToStr(SaveDialog6.FilterIndex - 1);
      SaveImageO(4 - SaveDialog6.FilterIndex * 2, SaveDialog6.FileName);
      SetSaveDialogNames(SaveDialog6.FileName);
    end;
end;

procedure TMand3DForm.SpeedButton24Click(Sender: TObject);
begin
    FVoxelExport.Visible := True;
    BringToFront2(FVoxelExport.Handle);
end;

procedure TMand3DForm.Button11Click(Sender: TObject);    //calculate a rough 8x8blocky image
var TileSize: TPoint;
begin
    PropagateCurrFrameNumber;
    TilingForm.SaveThisTile := False;
    MakeHeader;
    if (MHeader.Width < 1) or (MHeader.Height < 1) then Exit;
    MHeader.bCalc3D := 1;
    MHeader.bStereoMode := 0;
    MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, MHeader.bStereoMode);
    ProofPosLight;
    try
      TileSize := GetTileSize(@MHeader);
      SetLength(siLight5, TileSize.X * TileSize.Y);
      mSLoffset := TileSize.X * SizeOf(TsiLight5);
      SetImageSize;
    except
      SetLength(siLight5, 0);
      mSLoffset := 0;
    end;
    if Length(siLight5) = 0 then
    begin
      mSLoffset := 0;
      Button2.Caption := 'Calculate 3D';
      ShowMessage('Out of memory, decrease the imagesize.');
      Exit;
    end;
    DisableButtons;
    try
      MCalcThreadStats.pLBcalcStop := @MCalcStop;
      MCalcThreadStats.pMessageHwnd := Self.Handle;
      CalcMandBlocky;
    finally
      EnableButtons;
      MCalcThreadStats.iProcessingType := 0;
    end;
end;

procedure TMand3DForm.Button12Click(Sender: TObject);   // calculate left eye image
begin
    MHeader.bCalc3D := 1;
    StoreUndo;
    MHeader.bStereoMode := (Sender as TButton).Tag;
    CalcMand(True);
end;

procedure TMand3DForm.Button16Click(Sender: TObject);
var B: TButton;
begin
    B := Sender as TButton;
    if B.Caption = 'Click on image' then
    begin
      if B.Tag = 4 then
        B.Caption := 'Get min.dist. from image'
      else
        B.Caption := 'Get values from image';
      iGetPosFromImage := 0;
      SetImageCursor;
    end
    else
    begin
      B.Caption := 'Click on image';
      iGetPosFromImage := B.Tag;
      MButtonsUp;
      Image1.Cursor := crCross;
    end;
end;

procedure TMand3DForm.SpinButton2DownClick(Sender: TObject);
begin
    ImageScale := Min(10, ImageScale + 1);
    SetImageSize;
    UpdateScaledImageFull;
end;

procedure TMand3DForm.SpinButton2UpClick(Sender: TObject);
begin
    ImageScale := Max(1, ImageScale - 1);
    SetImageSize;
    UpdateScaledImageFull;
end;

procedure TMand3DForm.N111Click(Sender: TObject);
var s: Integer;
begin
    s := (Sender as TMenuItem).Tag;
    if s in [1..10] then
    begin
      ImageScale := s;
      SetImageSize;
      UpdateScaledImageFull;
    end;
end;

procedure TMand3DForm.N11Click(Sender: TObject);     //change style, buggy, recalc2D clicks/changes?
begin
 {   bUserChange := False;
    try
    case (Sender as TMenuItem).Tag of
      1: TStyleManager.SetStyle('Windows');
      2: TStyleManager.TrySetStyle('Ruby Graphite');      //  Amethyst Kamri
      3: TStyleManager.TrySetStyle('Emerald Light Slate');
    end;
    finally
      bUserChange := True;
    end;   }
end;

function TMand3DForm.OverImage(p: TPoint): LongBool;
begin
    Result := (p.X >= 0) and (p.Y >= 0) and (p.X < Max(Image1.Width, ScrollBox1.Width))
                         and (p.Y < Max(Image1.Height, ScrollBox1.Height));
end;

procedure TMand3DForm.SetShape2Size(NewSize: Integer);
var mx, my, ns: Integer;
begin
    if NewSize in [3..31] then
    begin
      ns := Shape2.Width div 2;
      mx := Shape2.Left + ns;
      my := Shape2.Top + ns;
      ns := NewSize div 2;
      Shape2.SetBounds(mx - ns, my - ns, NewSize, NewSize);
    end;
end;

procedure TMand3DForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    if Shape2.Visible then
    begin
      if WheelDelta < 0 then SetShape2Size(Shape2.Width - 2) else
      if WheelDelta > 0 then SetShape2Size(Shape2.Width + 2);
      Handled := True;
    end
    else if OverImage(Image1.ScreenToClient(MousePos)) then
    begin
      if WheelDelta < 0 then SpinButton2DownClick(Sender) else
      if WheelDelta > 0 then SpinButton2UpClick(Sender);
      Handled := True;
    end;
end;

procedure TMand3DForm.SpeedButton27Click(Sender: TObject);   //Big renders
begin
    TilingForm.Visible := True;
    BringToFront2(TilingForm.Handle);
end;

procedure TMand3DForm.SpeedButton28Click(Sender: TObject);
begin
    MCForm.Visible := True;
    BringToFront2(MCForm.Handle);
end;

procedure TMand3DForm.SaveDialog1TypeChange(Sender: TObject);
var S: String;
begin
    case SaveDialog1.FilterIndex of
      1:  SaveDialog1.DefaultExt := 'jpg';
      2:  SaveDialog1.DefaultExt := 'png';
    end;
    S := SaveDialog1.Filename;
    if SysUtils.DirectoryExists(S) then S := '';
    if S <> '' then
      case SaveDialog1.FilterIndex of
        1:  S := ChangeFileExt(S, '.jpg');
        2:  S := ChangeFileExt(S, '.png');
      else
        S := '';
      end;
    if S <> '' then
      SendMessage(GetParent(SaveDialog1.Handle), CDM_SETCONTROLTEXT, $480, Longint(PChar(ExtractFileName(S))));
end;

procedure TMand3DForm.SpeedButton29Click(Sender: TObject); //save paras+image
var f: file;
begin
    if SaveDialog1.Execute then
    begin
      MakeHeader;
      AssignFile(f, ChangeFileExt(SaveDialog1.FileName, '.m3p'));
      Rewrite(f, 1);
      MHeader.MandId := actMandId;
      BlockWrite(f, MHeader, SizeOf(MHeader));
      HAddon.bHCAversion := 16;
      BlockWrite(f, HAddon, SizeOf(THeaderCustomAddon));
      CloseFile(f);
      SaveImageO(2 - SaveDialog1.FilterIndex, SaveDialog1.FileName);
      SetSaveDialogNames(SaveDialog1.FileName);
    end;
end;

procedure TMand3DForm.Button18Click(Sender: TObject);
begin
    LightAdjustForm.Visible := True;
    BringToFront2(LightAdjustForm.Handle);
  //  LightAdjustForm.Invalidate; //for wine
end;

procedure TMand3DForm.Button19Click(Sender: TObject);
begin
    Edit23.Text := Edit9.Text;
    Edit24.Text := Edit10.Text;
    Edit22.Text := Edit17.Text;
end;

procedure TMand3DForm.Button10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var CP: TPoint;
    i: Integer;
begin
    if Button = mbRight then
    begin
      StickIt := Max(0, Min(2, (Sender as TButton).Tag));
      i := FormsSticky[StickIt];
      Stickthiswindowtotherightside1.Checked := i = 1;
      Stickthiswindowtotheleftside1.Checked := i = 2;
      Donotmakethiswindowsticky1.Checked := i = 0;
      GetCursorPos(CP);
      PopupMenu2.Popup(CP.X, CP.Y);
    end;
end;

procedure TMand3DForm.SendMove;
var M: TMessage;
begin
    M.Msg := WM_Move;
    M.WParam := 0;
    M.LParam := 0;
    WndProc(M);
end;

procedure TMand3DForm.Stickthiswindowtotherightside1Click(Sender: TObject);
begin
    FormsSticky[StickIt] := (Sender as TMenuItem).Tag;
    SendMove;
end;

procedure TMand3DForm.Button2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var CP: TPoint;
begin
    if (Button = mbRight) and (Button2.Caption = 'Calculate 3D') then
    begin
      GetCursorPos(CP);
      PopupMenu3.Popup(CP.X, CP.Y);
    end;
end;

procedure TMand3DForm.StartrenderingandsaveafterwardstheM3Ifile1Click(
  Sender: TObject);
begin  //start rendering+save M3I autom.
    if SaveDialog3.Execute then
    begin
      SaveAutoM3Ifilename := SaveDialog3.FileName;
      Button2Click(Self);
      SaveM3IfileAuto := True;
    end;
end;

procedure TMand3DForm.SpeedButton30Click(Sender: TObject); //get midpoint from image
begin
    if SpeedButton30.Caption = 'click image' then
    begin
      SpeedButton30.Caption := 'get midpoint';
      iGetPosFromImage := 0;
      SetImageCursor;
    end
    else
    begin
      SpeedButton30.Caption := 'click image';
      iGetPosFromImage := 22;
      MButtonsUp;
      Image1.Cursor := crCross;
    end;
end;

procedure TMand3DForm.FormHide(Sender: TObject);
begin
    IniVal[24] := IntToStr(Left) + ' ' + IntToStr(Top);
    IniVal[25] := IntToStr(Width) + ' ' + IntToStr(Height);
end;

procedure TMand3DForm.CheckBox10Click(Sender: TObject);
var dw, dh: Double;
begin
    if CheckBox10.Checked then //keep aspect
      if StrToFloatKtry(Edit11.Text, dw) and StrToFloatKtry(Edit12.Text, dh) and
        (dw > 0.5) and (dh > 0.5) then InternAspect := dw / dh;
end;

procedure TMand3DForm.CheckBox14Click(Sender: TObject);
begin
    TBoostChanged := True;
end;

procedure TMand3DForm.CheckBox7Click(Sender: TObject);
begin
    PageControl1Change(Sender);
end;

procedure TMand3DForm.Timer2Timer(Sender: TObject);
begin
    if (Button2.Caption = 'Calculate 3D') and (Now - LastHisParSaveTime > 1 / (24 * 12)) and
      not (CompareMem(@LHPSLight, @MHeader.Light, SizeOf(TLightingParas9)) or
      (AFormCreated and (AnimationForm.AniOption > 0)) or (BatchStatus > 0)) then
    begin
      StoreHistoryPars(MHeader);
      FastMove(MHeader.Light, LHPSLight, SizeOf(TLightingParas9));
    end;
end;

procedure TMand3DForm.SpeedButton35Click(Sender: TObject);
var CP: TPoint;
begin
    CP := SpeedButton35.ClientToScreen(Point(0, SpeedButton35.Height));
    PopupMenu1.Popup(CP.X, CP.Y);
end;

procedure TMand3DForm.RefreshNavigator(const Enabled: Boolean);
begin
  if Enabled and FNavigator.Visible then begin
    FNavigator.SpeedButton11Click(nil);
  end;
end;

function TMand3DForm.IsCalculating: Boolean;
begin
  Result := Button2.Caption = 'Stop';
end;

procedure TMand3DForm.PropagateCurrFrameNumber;
begin
  TMapSequenceFrameNumberHolder.SetCurrFrameNumber( StrToInt('0'+Mand3DForm.FrameEdit.Text) );
end;

Initialization

    AppFolder  := ExtractFilePath(Application.ExeName);
    AppDataDir := GetSpecialFolderPath(CSIDL_LOCAL_APPDATA) + '\Mandelbulb3D';
    if not SysUtils.DirectoryExists(AppDataDir) then AppDataDir := AppFolder;
    AppDataDir := IncludeTrailingPathDelimiter(AppDataDir);
    M3DBackGroundPic.LMnumber := 0;
    M3DBackGroundPic.LMframe := 0;
    M3DBackGroundPic.LMWidth := 0;

end.
