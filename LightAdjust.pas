unit LightAdjust;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, TypeDefinitions, Math3D,
  Menus, TrackBarEx, Vcl.ImgList, Vcl.ExtDlgs;

type
  TLightAdjustForm = class(TForm)
    ColorDialog1: TColorDialog;
    Panel3: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    TabControl1: TTabControl;
    Label8: TLabel;
    Label9: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButtonMem: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    CheckBox4: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TabSheet2: TTabSheet;
    Label13: TLabel;
    Label14: TLabel;
    TrackBar15: TTrackBarEx;
    TrackBar16: TTrackBarEx;
    Label15: TLabel;
    TrackBar17: TTrackBarEx;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    ButtonGetPos: TButton;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Panel4: TPanel;
    TrackBar18: TTrackBar;
    Label16: TLabel;
    Label17: TLabel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    TrackBar11: TTrackBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TrackBar5: TTrackBar;
    TrackBar7: TTrackBar;
    SpeedButton3: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    TrackBar4: TTrackBar;
    TrackBar8: TTrackBar;
    CheckBox3: TCheckBox;
    CheckBox9: TCheckBox;
    Label21: TLabel;
    Label22: TLabel;
    SpeedButton9: TSpeedButton;
    TrackBar23: TTrackBar;
    Label23: TLabel;
    TabSheet5: TTabSheet;
    Label6: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    CheckBox8: TCheckBox;
    TrackBar20: TTrackBar;
    TrackBar21: TTrackBar;
    TrackBar22: TTrackBar;
    Label24: TLabel;
    ComboBox3: TComboBox;
    SpeedButton5: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox10: TCheckBox;
    Label28: TLabel;
    TrackBar24: TTrackBar;
    TabSheet6: TTabSheet;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    TrackBar25: TTrackBar;
    TrackBar26: TTrackBar;
    TrackBar27: TTrackBar;
    Image3: TImage;
    CheckBox14: TCheckBox;
    Panel1: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    SBFineAdj: TSpeedButton;
    Label10: TLabel;
    Label11: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label12: TLabel;
    Label27: TLabel;
    TrackBar9: TTrackBar;
    TrackBar10: TTrackBar;
    TrackBar12: TTrackBar;
    TrackBar13: TTrackBar;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    TrackBar14: TTrackBar;
    Panel2: TPanel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    TrackBar28: TTrackBar;
    TrackBar29: TTrackBar;
    Label37: TLabel;
    Image4: TImage;
    CheckBox15: TCheckBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    TrackBar30: TTrackBar;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    CheckBox17: TCheckBox;
    PopupMenu1: TPopupMenu;
    CopythislighttoLight11: TMenuItem;
    CopythislighttoLight21: TMenuItem;
    CopythislighttoLight31: TMenuItem;
    CopythislighttoLight41: TMenuItem;
    CopythislighttoLight51: TMenuItem;
    CopythislighttoLight61: TMenuItem;
    CheckBox18: TCheckBox;
    Image5: TImage;
    RadioGroup1: TRadioGroup;
    Label38: TLabel;
    TrackBar31: TTrackBar;
    Fog: TTabSheet;
    Label1: TLabel;
    FogResetButton: TSpeedButton;
    Label18: TLabel;
    SpeedButton4: TSpeedButton;
    SpeedButton30: TSpeedButton;
    TrackBar3: TTrackBar;
    TrackBar6: TTrackBar;
    TrackBar19: TTrackBar;
    CheckBox19: TCheckBox;
    Label42: TLabel;
    TrackBar32: TTrackBar;
    Label43: TLabel;
    CheckBox16: TCheckBox;
    Label44: TLabel;
    Edit21: TEdit;
    UpDownDiffMap: TUpDown;
    Edit2: TEdit;
    UpDownLight: TUpDown;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    Label25: TLabel;
    ComboBox4: TComboBox;
    Edit1: TEdit;
    UpDown4: TUpDown;
    Label26: TLabel;
    ComboBox5: TComboBox;
    SpeedButton12: TSpeedButton;
    Label32: TLabel;
    TrackBar33: TTrackBar;
    Label33: TLabel;
    Label45: TLabel;
    PopupMenu2: TPopupMenu;
    ImageList1: TImageList;
    N01: TMenuItem;
    SpeedButton33: TSpeedButton;
    OpenDialogPic: TOpenPictureDialog;
    Label46: TLabel;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    OpenPictureDialog1: TOpenPictureDialog;
    SpeedButton34: TSpeedButton;
    PopupMenu3: TPopupMenu;
    Insertvolumetriclightcolor1: TMenuItem;
    Label47: TLabel;
    procedure TrackBar2Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
//    procedure RadioGroup1Click(Sender: TObject);
  //  procedure RadioGroup2Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBarYangleChange(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButtonMemClick(Sender: TObject);
    procedure SBFineAdjClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TrackBar16Change(Sender: TObject);
  //  procedure CheckBox5Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit1Change(Sender: TObject);
    procedure ButtonGetPosClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TabControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FogResetButtonClick(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure TrackBar21KeyPress(Sender: TObject; var Key: Char);
    procedure TrackBar11KeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox3Select(Sender: TObject);
    procedure ComboBox3DropDown(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure SpeedButton3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpinButton1Down;
    procedure SpinButton1Up;
    procedure TrackBar26Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure SpinEdit2Change(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox16Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TabControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CopythislighttoLight11Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TrackBar16MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure CheckBox21Click(Sender: TObject);
    procedure TrackBar33Change(Sender: TObject);
    procedure N01Click(Sender: TObject);
    procedure TrackBar22Change(Sender: TObject);
    procedure CheckBox22Click(Sender: TObject);
    procedure Edit2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton34Click(Sender: TObject);
    procedure SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Insertvolumetriclightcolor1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    LColHistoMaxN, LColInteriorHistoMaxN, LColInteriorHistoLength: Integer;
    OTColHistoMaxN: Integer;
    OldTB15Pos: Integer;
    OldTB16Pos: Integer;
    OldTB17Pos: Integer;
    LastBGname: array[0..23] of Byte;
    procedure SetPreset(nr: Integer; KeepLights: LongBool);
    procedure GetPreset(nr: Integer);
    procedure MakeGlyph(SB: TSpeedButton; PNr: Integer);
    procedure UpdateTabHeader(nr: Integer);
    function MakeDynFogCol: TRGB;
    function VisFuncToIndex(const Light: TLight8 {Lop: Byte}): Integer;
    function IndexToVisFunc(i: Integer): Byte;
    function GetPageContr1index(Loption: Byte): Integer;
    function TBChanged: LongBool;
    function OverForm(p: TPoint): LongBool;
    procedure MakeDepthColList;
    function VisLightExBit(const Light: TLight8): Integer;
  public
    { Public-Deklarationen }
    bUserChange: Boolean;
    TBcolStartPos, TBcolStopPos: Integer;  // Coarse Color Adjustments
    LAtmpLight: TLightingParas9;    //ersetzt die privaten obigen cols+lights
    LightMaps: array[0..5] of TLightMap;
    DiffColMap: TLightMap;
    LAposMids: array[0..5] of TPos3D;
    ColorFormCreated: LongBool;
    procedure SetSButtonColor(ButtonNr: Integer; Color: TRGB);
//    procedure WndProc(var Message: TMessage); override;
    procedure RepaintColHisto;
    procedure MakeHisto;
    procedure PutLightFInHeader(var Header: TMandHeader11);
    procedure SetLightFromHeader(var Header: TMandHeader11);
    procedure SetStartPreset;
    procedure SetSDButtonColors;
    procedure SetLAplusPosToZero;
    procedure UpdateQuickLoadCB;
    procedure SetPosLightTo0(tab: Integer);
  end;
procedure SetCosTabFunction;
function GetCosTabVal(const Tnr: Integer; const DotP, Rough: Single): Single;
function GetCosTabValSqr(const Tnr: Integer; const DotP, Rough: Single): Single;
function FastPowLUT(base, expo: Single): Single; //for lighting spec calculation
function GetDiffMapNr(LightPars: TPLightingParas9): Integer;
function GetCosTabValNavi(Tnr, i1, i2: Integer): Single;
function GetGaussFuncNavi(iL1, iL2: Integer): Single;
procedure PaintSDPreviewColors(LAtmpLight: TPLightingParas9; CanvasS, CanvasD: TCanvas; Wid: Integer);

var
  LightAdjustForm: TLightAdjustForm;
  LAFormCreated: LongBool = False;
  bLFfirstShow: LongBool = True;
  DiffCosTabNavi: array[0..3, 0..127] of Single; // old one for navigator + imageprocess
//  GaussTab: array of Single;  //for navi spec calculation (power..)
  DiffCosTabNsmall: array[0..7, 0..127] of Single;
  PowerTabSmall: array[0..127] of Single;
  GaussTabSmall: array[0..127] of Single;
  LastZoom: Double = 0;
  LastPositionDMScale: array[0..3] of Integer = (0,0,0,0);
{  DiffNormalPicArr: array of Cardinal;  //-> lightmap ..todo: possible lightmaps for all lights
  DNPWidth, DNPHeight: Integer;
  DNPstart, DNPYinc: Integer;
  DNPXfactor, DNPYfactor: Single; }

  Presets: array[1..5] of TLpreset164 =
  ((AmbTop: $B1AA9F; AmbBot: $3464AA; DepthCol: $B1AA9F; DepthCol2: $3464AA;        //Sand
    ColDif: ($2537A0, $4E9FD1, $62AEB3, $71808E);
    ColSpec: ($0B1026, $132734, $273639, $1C2023);
    Lights: ((Loption: 0; LFunction: 51; Lcolor: $FFFFFF; LXangle: 3363; LYangle: 4000),             //spec,dif,amb
             (Loption: 0; LFunction: 3; Lcolor: $34628F; LXangle: -4915; LYangle: -6500));  TB578pos: (50, 50, 90)),
                                             // $6797C7
   (AmbTop: $FF6000; AmbBot: $40B0; DepthCol: $800000; DepthCol2: $50;
    ColDif: ($E0, $FF0000, $B800, $ABDD);                                           //Slime
    ColSpec: ($F0F0F0, $F0F0F0, $F0F0F0, $F0F0F0);
    Lights: ((Loption: 0; LFunction: 3; Lcolor: $FFFFFF; LXangle: 0; LYangle: 4005),
             (Loption: 1; LFunction: 3; Lcolor: $FFFFFF; LXangle: 0; LYangle: 0));  TB578pos: (110, 22, 220)),

   (AmbTop: $E89660; AmbBot: $304860; DepthCol: $A04B18; DepthCol2: $D0A488;
    ColDif: ($1D85F8, $C0C0C0, $47CCF8, $B9B69B);                                   //Metallic
    ColSpec: ($1D85F8, $C0C0C0, $47CCF8, $B9B69B);
    Lights: ((Loption: 0; LFunction: 2; Lcolor: $AADDFF; LXangle: -637; LYangle: 4915),
             (Loption: 0; LFunction: 2; Lcolor: 2894962; LXangle: 3368; LYangle: -6463));  TB578pos: (160, 50, 30)),

   (AmbTop: $EC974A; AmbBot: $5976A6; DepthCol: $EC974A; DepthCol2: $5976A6;
    ColDif: ($204080, $349120, $1E36C1, $C5AAE6);                                   //Flower
    ColSpec: (0, $40491C, $3B3D60, $60487F);
    Lights: ((Loption: 0; LFunction: 51; Lcolor: $B9EFFF; LXangle: 0; LYangle: 3000),
             (Loption: 1; LFunction: 3; Lcolor: $34628F; LXangle: -4915; LYangle: -6500));  TB578pos: (50, 70, 90)),

//   (AmbTop: $A0A0A0; AmbBot: $A0A0A0; DepthCol: $A0A0A0; DepthCol2: $A0A0A0;
   (AmbTop: $905838; AmbBot: $8BA8C7; DepthCol: $905838; DepthCol2: $8BA8C7;
    ColDif: ($A0A0A0, $A0A0A0, $A0A0A0, $A0A0A0);                                   //Neutral
    ColSpec: ($404040, $404040, $404040, $404040);
    Lights: ((Loption: 0; LFunction: 52; Lcolor: $B9EFFF; LXangle: 4063; LYangle: 6405),
             (Loption: 1; LFunction: 52; Lcolor: $6797C7; LXangle: -4915; LYangle: -7100));  TB578pos: (50, 70, 90)));

  CustomPresets: array[6..15] of TLpreset20;

  LColHisto: array[0..32767] of Integer;
  OTColHisto: array[0..32767] of Integer;
  LColInteriorHisto: array of Integer;
  TBoldpos: array[0..24] of Integer;
                                              //49 = 32 + 16 + 1 = diff3 + 16pow -> 0+32pow=2
const                              //LFunction: 3(4)bit spec func + 2bit diff,   Pow = 8 shl (LFunction and $07), diff = (LFunction shr 4) and 3
  defaultLight8: TLight8 = (Loption: 1; LFunction: 4; Lamp: 10; Lcolor: ($FF, $FF, $FF); LightMapNr: 0;
        LXpos: (0,0,0,0,0,0,0); AdditionalByteEx: 0; LYpos: (0,0,0,0,0,0,0); FreeByte: 0; LZpos: (0,0,0,0,0,0,0));
  defaultLight7: TLight7 = (Loption: 1; LFunction: 3; Lcolor: $FFFFFF; LXangle: 0; LYangle: 0);
 { StartPreset: TLpreset16 =
   (Cols: (5873889, 8837614, $8B491D, 2988346, 12248958, $FFC49F, 11287584, 14579248, 7481121);
   Lights: ((Loption: 0; LFunction: 50; Lcolor: $A0E8FF;
   LXangle: 3368; LYangle: 5279), (Loption: 1; LFunction: 16; Lcolor: 2307911;  //60
   LXangle: -2822; LYangle: -7737),(),()); DepthCol: $8B491D; TB578pos: (34, 102, 90); DepthCol2: $FFC49F; Version: 1);
}  StartPreset: TLpreset16 =
   (Cols: (5873889, 8837614, $8B491D, 2988346, 12248958, $FFC49F, 11287584, 14579248, 7481121);
   Lights: ((Loption: 0; LFunction: 53; Lcolor: $A0E8FF; LXangle: 1500; LYangle: 5200),
            (Loption: 1; LFunction: 16; Lcolor: 2307911; LXangle: -2822; LYangle: -7737),
            (),()); DepthCol: $8B491D; TB578pos: (50, 120, 90); DepthCol2: $FFC49F; Version: 1);
                                               //spec,dif,amb    }
{  StartPreset: TLpreset16 =
   (Cols: ($58B0F8, $101010, $8B491D, $28A050, $206030, $FFC49F, $A07020, $B0B0B0, $DE7630);
   Lights: ((Loption: 0; LFunction: 5; Lcolor: $A0E8FF; LXangle: 0; LYangle: 5000),
            (Loption: 1; LFunction: 53; Lcolor: $233747; LXangle: -2822; LYangle: -7737),
            (),()); DepthCol: $A05018; TB578pos: (50, 100, 90); DepthCol2: $E0D0B0; Version: 1); //}
implementation

uses Mand, CalcThread, DivUtils, Math, PaintThread, FileHandling, ImageProcess,
     Animation, ColorPick, Interpolation, Undo, PostProcessForm, HeaderTrafos,
     Maps, Navigator;

{$R *.dfm}

{
    Loption:    Byte;              // bit1: 0: On  1: Off;  bit2: lightmap;  bit3 = bPosLight, bit4+5 = poslight visible+func, bit6 = global light rel to object, bit7 = HSon
    LFunction:  Byte;              // 4bit spec func + 2bit diff,  Spec expo = 8 shl (LFunction and $07), diff = (LFunction shr 4) and 3
    Lamp:       Word;              // Light amplitude for posLight -> exp 8bit shortint + 8bit byte mant for wide range! -> for all lights
    Lcolor:     TRGB;              // RGB 24bit
    LightMapNr: Word;              // 0: no LM, 1..32000: LMnr,  LM works as ambient light was byte, now with ..Ex as word!
 //   LXpos, LYpos, LZpos: Double;   // not posLight: LXpos=LXangle, LYpos=LYangle  todo?: only 7 bytes precision + 3 extra bytes for LMNRex,RealSpecExpo + 1 free
  //  LightMapNrEx: Byte;
    LXpos: Double7B;
    AdditionalByteEx: Byte;        //LVersionEx in Light1 and DiffMapNrEx in Light2
    LYpos: Double7B;
    FreeByte: Byte;
    LZpos: Double7B;


procedure TLightAdjustForm.MakeColTabsFromLightVals(LVals: TLightVals);
var x, y, iL1, iL2: Integer;
    sc, sp, dT3: Single;
    ps2, ps3: PSingle;
begin
    ps2 := @ObjectColDiff[0][0];
    ps3 := @ObjectColSpec[0][0];
    sc  := -LVals.sCStart * LVals.sCmul;          //Startval + inc... (0..3) or (3..0)
    sp  := LVals.sCmul;
 //   for y := 0 to 1 do
    begin
      sc := Abs(sc - Trunc(sc * 0.3333333333333333) * 3);
      if sc > 2 then
      begin
        sc := sc - 2;
        iL1 := 1;
        iL2 := 3;
      end else if sc > 1 then
      begin
        sc := sc - 1;
        if sc > 1 then sc := 1;
        iL1 := 3;
        iL2 := 2;
      end else begin
        if sc < 0 then sc := 0;
        iL1 := 2;
        iL2 := 1;
      end;
      for x := 0 to 32767 do
      with LVals do
      begin
        dT3 := 1 - sc;
        ps2^ := sc * PLColS^[iL1, 1, 0] + dT3 * PLColS^[iL2, 1, 0];
        Inc(ps2);
        ps2^ := sc * PLColS^[iL1, 1, 1] + dT3 * PLColS^[iL2, 1, 1];
        Inc(ps2);
        ps2^ := sc * PLColS^[iL1, 1, 2] + dT3 * PLColS^[iL2, 1, 2];
        ps3^ := sc * PLColS^[iL1, 2, 0] + dT3 * PLColS^[iL2, 2, 0];
        Inc(ps3);
        ps3^ := sc * PLColS^[iL1, 2, 1] + dT3 * PLColS^[iL2, 2, 1];
        Inc(ps3);
        ps3^ := sc * PLColS^[iL1, 2, 2] + dT3 * PLColS^[iL2, 2, 2];
        sc := sc + sp;
        if sc > 1 then
        begin


        end
        else if sc < 0 then
        begin


        end;
        Inc(ps2);
        Inc(ps3);
      end;
      sc := -LVals.sCiStart * LVals.sCimul;
      sp := LVals.sCimul;
    end;
end;  }

function GetDiffMapNr(LightPars: TPLightingParas9): Integer;
begin
    Result := LightPars.bColorMap or (LightPars.Lights[1].AdditionalByteEx shl 8);
end;

procedure TLightAdjustForm.MakeHisto; 
var x: Integer;
    PL: TPsiLight5;
    dHL: Double;
const dm: Double = 0.0000305175;
begin
    for x := 0 to 32767 do LColHisto[x] := 0;
    for x := 0 to 32767 do OTColHisto[x] := 0;
    LColInteriorHistoLength := Image2.Width;
    SetLength(LColInteriorHisto, LColInteriorHistoLength);
    for x := 0 to LColInteriorHistoLength - 1 do LColInteriorHisto[x] := 0;
    PL := @Mand3DForm.siLight5[0];
    dHL := LColInteriorHistoLength - 1;
    for x := 0 to High(Mand3DForm.siLight5) do
    begin
      if PL.Zpos < 32768 then
      begin
        if PL.SIgradient < 32768 then
          Inc(LColHisto[PL.SIgradient])
        else
          Inc(LColInteriorHisto[Round(Sqrt(Sqrt((PL.SIgradient - 32768) * dm)) * dHL)]);
        Inc(OTColHisto[PL.OTrap and $7FFF]);
      end;
      Inc(PL);
    end;
    LColHistoMaxN := 1;
    LColInteriorHistoMaxN := 1;
    OTColHistoMaxN := 1;
    for x := 0 to 32767 do
      if LColHisto[x] > LColHistoMaxN then LColHistoMaxN := LColHisto[x];
    for x := 0 to 32767 do
      if OTColHisto[x] > OTColHistoMaxN then OTColHistoMaxN := OTColHisto[x];
    for x := 1 to LColInteriorHistoLength - 1 do
      if LColInteriorHisto[x] > LColInteriorHistoMaxN then
        LColInteriorHistoMaxN := LColInteriorHisto[x];
    RepaintColHisto;
end;

procedure TLightAdjustForm.RepaintColHisto;
var x, y, c, x2, x3, a, x2inc: Integer;
    d, dmin, dmul: Double;
begin
    y := Image1.Height + 1;
    with Image1.Picture.Bitmap do
    begin
      SetSize(Image1.Width, y - 1);
    //  Width  := Image1.Width;
    //  Height := y - 1;
      if SBFineAdj.Down then
      begin
        dmin := Sqr((TBcolStartPos + 30) / 90) * 32767 - 10900;
        dmul := (Sqr((TBcolStopPos + 30) / 90) * 32767 - 10900 - dmin) / 32767;
        x2   := Round(-16384 * dmul + dmin);
      end else begin
        dmin := 0;
        dmul := 1;
        x2   := 0;
      end;
      for x := 0 to Width - 1 do
      begin
        if SBFineAdj.Down then
          x3 := Round((x * 65535 / (Width - 1) - 16384) * dmul + dmin)
        else
          x3 := Round(Sqr(x * 4 / (3 * (Width - 1))) * 32767 - 10900);
        x2inc := Sign(x3 - x2);
        a := 0;
        d := 0;
        if CheckBox2.Checked then
        begin
          repeat
            if (x2 >= 0) and (x2 < 32768) then
            begin
              d := d + OTColHisto[x2];
              Inc(a);
            end;
            x2 := x2 + x2inc;
          until x2 = x3;
          if (OTColHistoMaxN <> 0) and (a <> 0) then d := d / (a * OTColHistoMaxN); //was: int overflow
        end else begin
          repeat
            if (x2 >= 0) and (x2 < 32768) then
            begin
              d := d + LColHisto[x2];
              Inc(a);
            end;
            x2 := x2 + x2inc;
          until x2 = x3;
          if (LColHistoMaxN <> 0) and (a <> 0) then d := d / (a * LColHistoMaxN);
        end;
        c := 255 - Round(Sqrt(Sqrt(Clamp01D(d))) * 255);
        Canvas.Pen.Color := c or (c shl 8) or (((c and $FE) + 200)  shl 15);
        Canvas.MoveTo(x, 0);
        Canvas.LineTo(x, y);
      end;
    end;
    y := Image2.Height + 1;
    if Length(LColInteriorHisto) >= Image2.Width then
    with Image2.Picture.Bitmap do
    begin
      Width  := Image2.Width;
      Height := y - 1;
      for x := 0 to Width - 1 do
      begin                                                             
        d := LColInteriorHisto[x] / LColInteriorHistoMaxN;     //read of adr 0 when starting with parameter m3p file! ->CB2.click
        if d > 1 then d := 1;
        c := 255 - Round(Sqrt(Sqrt(d)) * 255);
        Canvas.Pen.Color := c or (c shl 8) or (((c and $FE) + 200)  shl 15);
        Canvas.MoveTo(x, 0);
        Canvas.LineTo(x, y);
      end;
    end;
end;

{procedure TLightAdjustForm.WndProc(var Message: TMessage);
var xLDif, xRDif, yDif: Integer;
begin
    if Message.Msg = WM_Move then
    begin
      yDif  := Abs(Top - Mand3DForm.Top);
      if yDif < 17 then
      begin
        xLDif := Abs(Left + Width - Mand3DForm.Left);
        xRDif := Abs(Left - Mand3DForm.Left - Mand3DForm.Width);
        if xLDif < 17 then FormsSticky[1] := 2 else
        if xRDif < 17 then Mand3DForm.bLightFormStick := 1 else
          Mand3DForm.bLightFormStick := 0;
      end
      else Mand3DForm.bLightFormStick := 0;
    end;
    inherited WndProc(Message);
end;     }

procedure SetCosTabFunction; //.. function to interpolate and less vals in tab. +Also a similar power function with some tabs + ipol
var i, j, k, l: Integer;
    d: Double;
    e: Extended;
    TmpTabSmall: array[0..127] of Single;
begin
    for i := 0 to 127 do
    begin
      d := Cos(i * 0.0490873852123405184);    //old for navi: 0 to 2pi angle
      DiffCosTabNavi[0][i] := Clamp0D(d);           //average: 0.318
      DiffCosTabNavi[1][i] := Sqr(Clamp0D(d));       //average: 0.25
      DiffCosTabNavi[2][i] := d * s05 + s05;        //average: 0.5
      DiffCosTabNavi[3][i] := Sqr(d * s05 + s05);   //average: 0.375
      d := 1 - (i - 2) / 60;
      if d > 0.15 then DiffCosTabNsmall[0][i] := (d - 0.08) * 1.0869565 else
      if d <= 0 then DiffCosTabNsmall[0][i] := 0 else
        DiffCosTabNsmall[0][i] := Power(d, Max(1, (0.505 - d) * 3.8));
      DiffCosTabNsmall[1][i] := Sqr(Clamp0D(d));
      DiffCosTabNsmall[2][i] := d * s05 + s05;
      DiffCosTabNsmall[3][i] := Sqr(d * s05 + s05);
      d := 1 - (i - 2) / 380;
      if d >= 1 then PowerTabSmall[i] := 1 else
      if d <= 0 then PowerTabSmall[i] := 0 else PowerTabSmall[i] := Power(d, 38);
      GaussTabSmall[i] := Power(enat, -Sqr(i * 0.0503936));
    end;
    for k := 0 to 3 do
    begin
      for j := 0 to 127 do TmpTabSmall[j] := Sqrt(Max0S(DiffCosTabNsmall[k][j]));
      for j := 0 to 127 do
      begin
        e := 0;
        for i := 0 to 60 do
        begin
          l := Abs(j + i - 30);
          if l < 128 then e := e + TmpTabSmall[l];
        end;
        DiffCosTabNsmall[k + 4][j] := Sqr(e * 0.011 + Sqr(e * 0.007)); //DiffCosTabN[k + 4][Round(Min0MaxCS((j - 2) * 16384/121, 16383))];
      end;
    end;
//    showmessage(floattostr(DiffCosTabN[6][16383]) + ' ' + floattostr(DiffCosTabN[3][16383]));
end;

function FastPowLUT(base, expo: Single): Single; //for lighting spec calculation with float exponent!
var w1: Single;
    ip: Integer;
    w: TSVec;
    p1: TPSingleArray;
begin
    if base <= 0 then Result := 0 else
    if base >= 1 then Result := 1 else
    begin
      w1 := (1 - base) * 10 * expo;
      ip := Trunc(w1);
      if ip < 0 then Result := 1 else 
      if ip > 123 then Result := 13e-7 / (w1 - 120) else
      begin
        w := MakeSplineCoeff(Frac(w1));
        p1 := @PowerTabSmall[ip + 1]; //0
        Result := p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3];
  {      p1 := @PowerTabSmall[1][ip + 1];
        w1 := Min0MaxCS((Expo - 8) * 0.02, 1); //weight LUT 0->1
        Result := (Result + w1 * (p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3] - Result));  }
      end;
    end;
end;

                                  //  ebp+8          eax
procedure MakeCubicWeightsFromT(const t: Single; var sv: TSVec);  //all weights 6 times bigger!
const s3: Single = 3;
    s6: Single = 6;
{begin
    sv[3] := t*t*t;
    sv[2] := 3*t*t;
    sv[0] := -sv[3] + sv[2] - 2*t;
    sv[1] := 3*sv[3] - 2*sv[2] - 3*t + 6;
    sv[2] := -3*sv[3] + sv[2] + 6*t;
    sv[3] := sv[3] - t;              }
asm
    fld  dword [ebp + 8]
    fld  st
    fmul st, st      //t*t,t
    fld  st
    fmul st, st(2)   //t³,t²,t
    fld  s3
    fmul st(2), st   //3, t³=sv[3], 3*t²=sv[2], t
    fld  st(2)       //sv[2], 3, sv[3], sv[2], t
    fsub st, st(2)   //sv[2]-sv[3], 3, sv[3], sv[2], t
    fsub st, st(4)   //sv[2]-sv[3]-t, 3, sv[3], sv[2], t
    fsub st, st(4)   //sv[2]-sv[3]-2*t, 3, sv[3], sv[2], t
    fstp dword [eax] //3, sv[3], sv[2], t
    fld  st(1)       //sv[3], 3, sv[3], sv[2], t
    fmul st, st(1)   //3*sv[3], 3, sv[3], sv[2], t
    fsub st, st(3)   //3*sv[3]-sv[2], 3, sv[3], sv[2], t
    fsub st, st(3)   //3*sv[3]-2*sv[2], 3, sv[3], sv[2], t
    fld  st(4)
    fmul st, st(2)
    fsubp
    fadd s6
    fstp dword [eax + 4]
    fmul st, st(1)
    fsubp st(2), st  //t³,3*t²-3*t³,t
    fsub st, st(2)
    fstp dword [eax + 12]  //3*t²-3*t³,t
    fxch
    fmul s6
    faddp
    fstp dword [eax + 8]
end;
                        //0..16383
function GetGaussFuncNavi(iL1, iL2: Integer): Single;
var i1, i2: Integer;
    t1, t2: Single;
    p1, p2: TPSingleArray;
const s1d128: Single = 1/128;
begin
    i1 := iL1 shr 7;
    i2 := iL2 shr 7;
    t1 := (iL1 and $7F) * s1d128;
    t2 := (iL2 and $7F) * s1d128;
    if i1 > 126 then
    begin
      i1 := 126;
      t1 := 1;
    end;
    if i2 > 126 then
    begin
      i2 := 126;
      t2 := 1;
    end;
    p1 := @GaussTabSmall[i1];
    p2 := @GaussTabSmall[i2];
    Result := (p1[0] + t1 * (p1[1] - p1[0])) * (p2[0] + t2 * (p2[1] - p2[0]));
end;
                           //  0..16383 +edges
function GetCosTabValNavi(Tnr, i1, i2: Integer): Single;
var i1t, i2t: Integer;
    t1, t2: Single;
    p1, p2: TPSingleArray;
const s1d128: Single = 1/128;
begin
    i1t := (i1 and $7FFF) shr 1;
    i2t := (i2 and $7FFF) shr 1;
    t1 := (i1t and $7F) * s1d128;
    t2 := (i2t and $7F) * s1d128;
    i1t := i1t shr 7;
    i2t := i2t shr 7;
    if i1t > 126 then
    begin
      i1t := 126;
      t1 := 1;
    end;
    if i2t > 126 then
    begin
      i2t := 126;
      t2 := 1;
    end;
    p1 := @DiffCosTabNavi[Tnr][i1t];
    p2 := @DiffCosTabNavi[Tnr][i2t];
    Result := (p1[0] + t1 * (p1[1] - p1[0])) * (p2[0] + t2 * (p2[1] - p2[0]));
end;

                   // 0..3          -1..1  0..1           0..1
function GetCosTabVal(const Tnr: Integer; const DotP, Rough: Single): Single;
var ip: Integer;
    t: Single;
    w: TSVec;
    p1: TPSingleArray;
begin //new function for tabs[0..(127)255]  (62)122 is midpoint=0 of DotP
    t := 62 - 60 * DotP;
    ip := Trunc(t) - 1;
    if ip < 0 then
    begin
      ip := 0;
      t := 0;
    end
    else if ip > 124 then
    begin
      ip := 124;
      t := 1;
    end
    else t := Frac(t);
    w := MakeSplineCoeff(t);     // MakeCubicWeightsFromT(t, w);
    if SupportSSE then
    asm
      mov edx, Tnr
      shl edx, 7
      add edx, ip
      lea eax, DiffCosTabNsmall + edx * 4
      movups xmm2, w
      movups xmm0, [eax]
      movups xmm1, [eax + $800]
      mulps  xmm0, xmm2
      mulps  xmm1, xmm2
      movaps xmm3, xmm0
      unpcklps xmm3, xmm1
      unpckhps xmm0, xmm1
      addps   xmm3, xmm0
      movhlps xmm0, xmm3
      addps  xmm3, xmm0     
      movaps xmm2, xmm3
      shufps xmm2, xmm2, 1
      subss  xmm2, xmm3
      mulss  xmm2, Rough
      addss  xmm2, xmm3
      movss  Result, xmm2
    end
    else
    begin
      p1 := @DiffCosTabNsmall[Tnr][ip];
      Result := p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3]; 
      p1 := @DiffCosTabNsmall[Tnr + 4][ip];
      Result := (Result + Rough * (p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3] - Result));
    end;
end;

function GetCosTabValSqr(const Tnr: Integer; const DotP, Rough: Single): Single;
var ip: Integer;
    t: Single;
    w: TSVec;
    p1: TPSingleArray;
begin //new function for tabs[0..127]  62 is midpoint=0 of DotP
    t := 62 - 60 * DotP;
    ip := Trunc(t) - 1;
    if ip < 0 then
    begin
      ip := 0;
      t := 0;
    end
    else if ip > 124 then
    begin
      ip := 124;
      t := 1;
    end
    else t := Frac(t);
    w := MakeSplineCoeff(t);
    if SupportSSE then
    asm
      mov edx, Tnr
      shl edx, 7
      add edx, ip
      lea eax, DiffCosTabNsmall + edx * 4
      movups xmm2, w
      movups xmm0, [eax]
      movups xmm1, [eax + $800]
      mulps  xmm0, xmm2
      mulps  xmm1, xmm2
      movaps xmm3, xmm0
      unpcklps xmm3, xmm1
      unpckhps xmm0, xmm1
      addps   xmm3, xmm0
      movhlps xmm0, xmm3
      addps  xmm3, xmm0
      mulps  xmm3, xmm3
      movaps xmm2, xmm3
      shufps xmm2, xmm2, 1
      subss  xmm2, xmm3
      mulss  xmm2, Rough
      addss  xmm2, xmm3
      movss  Result, xmm2
    end
    else   
    begin
      p1 := @DiffCosTabNsmall[Tnr][ip];
      Result := Sqr(p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3]);
      p1 := @DiffCosTabNsmall[Tnr + 4][ip];
      Result := (Result + Rough * (Sqr(p1[0] * w[0] + p1[1] * w[1] + p1[2] * w[2] + p1[3] * w[3]) - Result));
    end;
end;

procedure TLightAdjustForm.SetLightFromHeader(var Header: TMandHeader11);
var i: Integer;
begin
    bUserChange := False;
    with Header do
    try
      SBFineAdj.Down := (Light.TBoptions and $10000) > 0;
      TBcolStartPos  := Light.TBpos[9];
      TBcolStopPos   := Light.TBpos[10];
      TrackBar14.Position := Light.VarColZpos;
      TrackBar3.Position  := Light.TBpos[3] and $FFFF;
      TrackBar19.Position := Light.TBpos[3] shr 16;
      TrackBar20.Position := Light.PicOffsetX;
      TrackBar21.Position := Light.PicOffsetY;
      TrackBar22.Position := Light.PicOffsetZ;
      TrackBar23.Position := ShortInt((Light.TBpos[11] shr 8) and $FF) + 53;
      TrackBar24.Position := Light.RoughnessFactor;
      TrackBar11.Position := Light.TBpos[11] and $FF;
      TrackBar32.Position := Light.Lights[3].AdditionalByteEx;
      UpDownDiffMap.Position := GetDiffMapNr(@Light);
      CheckBox15.Checked  := GetDiffMapNr(@Light) <> 0;
      if CheckBox15.Checked then
      begin
        TrackBar30.Position := (Light.TBpos[8] shr 20) and $FF;
        TrackBar29.Position := (Light.TBpos[7] shr 12) and $FF;
        TrackBar28.Position := (Light.TBpos[7] shr 20) and $FF;
        TrackBar31.Position := Light.Lights[2].AdditionalByteEx;
      end else begin
        TrackBar30.Position := 128;
        TrackBar29.Position := 128;
        TrackBar28.Position := 128;
        TrackBar31.Position := 30;
      end;
      for i := 4 to 10 do if not (i in [7, 8]) then
(FindComponent('TrackBar' + IntToStr(i)) as TTrackBar).Position := Light.TBpos[i];
      TrackBar7.Position := Light.TBpos[7] and $FFF;
      TrackBar8.Position := Light.TBpos[8] and $FFF;
      LAtmpLight := Light;
      SetSButtonColor(3, Light.AmbCol);
      SetSButtonColor(4, MakeDynFogCol);
      SetSButtonColor(6, Light.AmbCol2);
      SetSButtonColor(10, Light.DepthCol);
      SetSButtonColor(11, Light.DepthCol2);
      SetSButtonColor(30, Light.DynFogCol2);
      SetSDButtonColors;
      if (Light.TBoptions and $10000) > 0 then
      begin
        TrackBar9.Position  := Integer(Light.FineColAdj1) - 30;
        TrackBar10.Position := Integer(Light.FineColAdj2) - 30;
      end;
      TrackBar12.Position := (Light.TBoptions and 127);
      TrackBar13.Position := (Light.TBoptions shr 7) and 127;
      CheckBox1.Checked   := (Light.TBoptions and $4000) <> 0;
      CheckBox2.Checked   := (Light.TBoptions and $20000) <> 0;
      CheckBox3.Checked   := (Light.TBoptions and $40000) <> 0;
      CheckBox12.Checked  := (Light.TBoptions and $8000) = 0;
      CheckBox13.Checked  := (Light.TBoptions and $80000) <> 0;     //smooth BGimage on load
      TrackBar18.Position := (Light.TBoptions shr 23) and $3F;
      CheckBox9.Checked   := (Light.TBoptions and $20000000) <> 0;  //BG+Amb light rel to object
      CheckBox5.Checked   := (Light.AdditionalOptions and $80) <> 0;//convert to spherical on load
      CheckBox10.Checked  := (Light.AdditionalOptions and 1) <> 0;  //Internal gamma of 2
      RadioGroup1.ItemIndex := Light.Lights[1].FreeByte and 3;
      CheckBox16.Checked  := (Light.Lights[2].FreeByte and 1) <> 0;
      CheckBox17.Checked  := (Light.AdditionalOptions and 8) <> 0;  //Add BGpic light
      CheckBox18.Checked  := (Light.AdditionalOptions and 4) <> 0;  //DiffMap relative to object. now: y+c comb
      CheckBox19.Checked  := (Light.Lights[0].FreeByte and 1) <> 0; //Blend DynFog
      CheckBox23.Checked  := (Light.Lights[0].FreeByte and 2) <> 0; //only add light
      //change on new lighting:
      CheckBox20.Checked := (Light.AdditionalOptions and 16) <> 0;  //fit left+right edges in load
      CheckBox21.Checked := (Light.AdditionalOptions and 32) <> 0;  //small bg image for ambient
      CheckBox22.Checked := (Light.Lights[3].FreeByte and 1) <> 0;  //No color interpolation
      TrackBar33.Position := Light.Lights[4].AdditionalByteEx;
      CheckBox8.Checked := Light.BGbmp[0] <> 0;                    //BG picture -> try load on para load when Mid > 19!

      if (Light.TBoptions and $40000000) > 0 then SpeedButton5.Down := True else
      if (Light.TBoptions and $80000000) > 0 then SpeedButton8.Down := True else
                                                  SpeedButton7.Down := True;

      TabControl1.TabIndex := 0;
      TabControl1Change(Self);

      SetLAplusPosToZero;
      for i := 0 to 5 do if (Light.Lights[i].Loption and 12) > 0 then SetPosLightTo0(i);

      UpdateTabHeader(-1);
      if ColorFormCreated and ColorForm.Visible then ColorForm.RepaintImage(@Light, False);

      if not AnsiSameText(CustomFtoStr(Light.BGbmp), CustomFtoStr(LastBGname)) then
      begin
        MakeLMPreviewImage(Image5, @M3DBackGroundPic);
        FastMove(LAtmpLight.BGbmp, LastBGname, 24);
      end;

    finally
      bUserChange := True;
    end;
end;

procedure TLightAdjustForm.PutLightFInHeader(var Header: TMandHeader11);
var i: Cardinal;
begin
    with Header do
    begin
      Light := LAtmpLight;
      for i := 3 to 11 do Light.TBpos[i] :=
                (FindComponent('TrackBar' + IntToStr(i)) as TTrackBar).Position;

      Light.TBpos[3] := Light.TBpos[3] or (TrackBar19.Position shl 16);  //fog far offset
      Light.TBpos[11] := Light.TBpos[11] or ((ShortInt(TrackBar23.Position - 53) shl 8) and $FF00);    //ambient 2nd reflection

      if SBFineAdj.Down then
      begin
        Light.FineColAdj1 := Light.TBpos[9] + 30;
        Light.FineColAdj2 := Light.TBpos[10] + 30;
        Light.TBpos[9]  := TBcolStartPos;
        Light.TBpos[10] := TBcolStopPos;
      end
      else
      begin
        Light.FineColAdj1 := 0;
        Light.FineColAdj2 := 0;
      end;
      Light.PicOffsetX := TrackBar20.Position;
      Light.PicOffsetY := TrackBar21.Position;
      Light.PicOffsetZ := TrackBar22.Position;
      Light.VarColZpos := TrackBar14.Position;
      Light.RoughnessFactor := TrackBar24.Position;
      if Panel2.Visible then
      begin
        Light.bColorMap := UpDownDiffMap.Position and $FF;
        Light.Lights[1].AdditionalByteEx := UpDownDiffMap.Position shr 8;
        Light.TBpos[7] := Light.TBpos[7] or (TrackBar29.Position shl 12) or (TrackBar28.Position shl 20);  //diffcolormap x,y offsets
        Light.TBpos[8] := Light.TBpos[8] or (TrackBar30.Position shl 20);
      end
      else
      begin
        Light.bColorMap := 0;                      
        Light.Lights[1].AdditionalByteEx := 0;
      end;
      Light.AdditionalOptions := (Ord(CheckBox5.Checked) shl 7)
          or (Ord(CheckBox10.Checked) and 1) //or (Min(1, RadioGroup1.ItemIndex) shl 1)
          or ((Ord(CheckBox20.Checked) and 1) shl 4) or ((Ord(CheckBox17.Checked) and 1) shl 3)
          or ((Ord(CheckBox18.Checked) and 1) shl 2) or ((Ord(CheckBox21.Checked) and 1) shl 5);  //diffmap rel to object: now: comb map Y with diff colors!
      Light.Lights[1].FreeByte := RadioGroup1.ItemIndex;
      if SpeedButton5.Down then i := $40000000 else
      if SpeedButton8.Down then i := $80000000 else i := 0;
      i := i or (actLightId shl 20);
      Light.Lights[0].AdditionalByteEx := actLightIdEx;
      Light.Lights[0].FreeByte := (Ord(CheckBox19.Checked) and 1) or ((Ord(CheckBox23.Checked) and 1) shl 1);
      Light.Lights[2].FreeByte := Ord(CheckBox16.Checked) and 1;
      Light.Lights[3].FreeByte := Ord(CheckBox22.Checked) and 1;
      Light.Lights[2].AdditionalByteEx := TrackBar31.Position;
      Light.Lights[3].AdditionalByteEx := TrackBar32.Position;
      Light.Lights[4].AdditionalByteEx := TrackBar33.Position;
      Light.TBoptions := TrackBar12.Position or
                         (TrackBar13.Position shl 7) or
                         (Ord(CheckBox1.Checked) shl 14) or
                         ((1 - Ord(CheckBox12.Checked)) shl 15) or
                         (Ord(SBFineAdj.Down) shl 16) or
                         (Ord(CheckBox2.Checked) shl 17) or
                         (Ord(CheckBox3.Checked) shl 18) or
                         (Ord(CheckBox13.Checked) shl 19) or
                         (Ord(CheckBox9.Checked) shl 29) or
                         (TrackBar18.Position shl 23) or i;
    end;
end;

function TLightAdjustForm.TBChanged: LongBool;
var i: Integer;
    TB: TTrackBar;
const TBnr: array[0..24] of Byte = (3,4,5,6,7,8,9,10,11,12,13,14,18,19,20,21,22,
                                    23,24,28,29,30,31,32,33);
begin
    Result := False;
    for i := 0 to 24 do
    begin
      TB := FindComponent('TrackBar' + IntToStr(TBnr[i])) as TTrackBar;
      if TB = nil then
        TBoldpos[i] := i
      else
      if TB.Position <> TBoldpos[i] then   //rangecheck
      begin
        Result := True;
        TBoldpos[i] := TB.Position;
      end;  
    end;
end;

procedure TLightAdjustForm.TrackBar2Change(Sender: TObject);
begin
    if bUserChange and TBChanged then TriggerRepaint;
    LastPositionDMScale[RadioGroup1.ItemIndex] := TrackBar31.Position; //diffmap mode
end;

procedure TLightAdjustForm.TrackBar33Change(Sender: TObject);
begin
    Label45.Caption := FloatToStrSingle(Power(1.04, TrackBar33.Position - 40));
    if bUserChange and TBChanged then TriggerRepaint;
end;

procedure PaintSDPreviewColors(LAtmpLight: TPLightingParas9; CanvasS, CanvasD: TCanvas; Wid: Integer);
var x, xFrom, xTo, actN: Integer;                                                      //34
    w1, sm: Single;
    bNoColIpol: LongBool;
begin
    actN   := 1;
    xFrom  := 0;
    sm     := Wid * s1d32767;
    with LAtmpLight^ do
    begin
      bNoColIpol := (Lights[3].FreeByte and 1) <> 0;
      xTo := Round(LCols[1].Position * sm);
      for x := 0 to Wid - 1 do  //33
      begin
        if (x > xTo) and (actN < 10) then
        begin
          Inc(actN);
          xFrom := xTo;
          if actN > 9 then xTo := Wid - 1 else xTo := Round(LCols[actN].Position * sm);
          if xTo <= xFrom then xTo := xFrom + 1;
        end;
        w1 := 1 - (x - xFrom) / Max(1, xTo - xFrom);
        if bNoColIpol then CanvasD.Pen.Color := LCols[actN - 1].ColorDif and $FFFFFF else
        CanvasD.Pen.Color :=    //diff
          InterpolateColor(LCols[actN - 1].ColorDif, LCols[actN mod 10].ColorDif, w1, 1 - w1);
        CanvasD.MoveTo(x + 2, 1);
        CanvasD.LineTo(x + 2, 12);
        if bNoColIpol then CanvasS.Pen.Color := LCols[actN - 1].ColorSpe and $FFFFFF else
        CanvasS.Pen.Color :=    //Spec
          InterpolateColor(LCols[actN - 1].ColorSpe, LCols[actN mod 10].ColorSpe, w1, 1 - w1);
        CanvasS.MoveTo(x + 2, 4);
        CanvasS.LineTo(x + 2, 12);
        if bNoColIpol then CanvasS.Pen.Color := TransparencyToColor(LCols[actN - 1].ColorSpe) else
        CanvasS.Pen.Color :=    //Transp
          InterpolateColor(TransparencyToColor(LCols[actN - 1].ColorSpe),
                           TransparencyToColor(LCols[actN mod 10].ColorSpe), w1, 1 - w1);
        CanvasS.MoveTo(x + 2, 1);
        CanvasS.LineTo(x + 2, 4);
     end;
   end;
end;

procedure TLightAdjustForm.SetSDButtonColors;
var x, xFromI, xToI, actNI: Integer;
    w1, sm: Single;
    bNoColIpol: LongBool;
begin
    actNI  := 1;
    xFromI := 0;
    sm     := 34 * s1d32767;
    with LAtmpLight do
    begin
      bNoColIpol := (Lights[3].FreeByte and 1) <> 0;
      PaintSDPreviewColors(@LAtmpLight, SpeedButton2.Glyph.Canvas, SpeedButton1.Glyph.Canvas, 34);
      xToI := Round(ICols[1].Position * sm);
      for x := 0 to 33 do
      begin
        if (x > xToI) and (actNI < 4) then
        begin
          Inc(actNI);
          xFromI := xToI;
          if actNI > 3 then xToI := 33 else xToI := Round(ICols[actNI].Position * sm);
          if xToI <= xFromI then xToI := xFromI + 1;
        end;
        w1 := 1 - (x - xFromI) / (xToI - xFromI);
        if bNoColIpol then SpeedButton33.Glyph.Canvas.Pen.Color := ICols[actNI - 1].Color and $FFFFFF else
        SpeedButton33.Glyph.Canvas.Pen.Color :=    //cuts
          InterpolateColor(ICols[actNI - 1].Color, ICols[actNI and 3].Color, w1, 1 - w1);
        SpeedButton33.Glyph.Canvas.MoveTo(x + 2, 4);
        SpeedButton33.Glyph.Canvas.LineTo(x + 2, 12);
        if bNoColIpol then SpeedButton33.Glyph.Canvas.Pen.Color :=
          TransparencyToColor(ICols[actNI - 1].Color) else
        SpeedButton33.Glyph.Canvas.Pen.Color :=    //Transp+spec
          InterpolateColor(TransparencyToColor(ICols[actNI - 1].Color),
                           TransparencyToColor(ICols[actNI and 3].Color), w1, 1 - w1);
        SpeedButton33.Glyph.Canvas.MoveTo(x + 2, 1);
        SpeedButton33.Glyph.Canvas.LineTo(x + 2, 4);
     end;
   end;
end;

procedure TLightAdjustForm.SetSButtonColor(ButtonNr: Integer; Color: TRGB);
var SB: TSpeedButton;
begin
    SB := FindComponent('SpeedButton' + IntToStr(ButtonNr)) as TSpeedButton;
    if SB <> nil then
    begin
      SB.Glyph.Canvas.Pen.Color   := clBlack;
      SB.Glyph.Canvas.Brush.Color := RGBtoCardinal(Color);
      SB.Glyph.Canvas.Rectangle(1, 0, 14, 13);
    end;
end;

function TLightAdjustForm.MakeDynFogCol: TRGB;
begin
    Result[0] := LAtmpLight.DynFogR;
    Result[1] := LAtmpLight.DynFogG;
    Result[2] := LAtmpLight.DynFogB;
end;

procedure TLightAdjustForm.SpeedButton1Click(Sender: TObject);
var T: Integer;
    tmpRGB: TRGB;
begin
    T := (Sender as TSpeedButton).Tag;
    if T in [3,4,6,10,11,12,30] then
    begin
      Case T of
         3: tmpRGB := LAtmpLight.AmbCol;
         4: tmpRGB := MakeDynFogCol;
         6: tmpRGB := LAtmpLight.AmbCol2;
        10: tmpRGB := LAtmpLight.DepthCol;
        11: tmpRGB := LAtmpLight.DepthCol2;
        12: tmpRGB := LAtmpLight.Lights[TabControl1.TabIndex].Lcolor;
        30: tmpRGB := LAtmpLight.DynFogCol2;
      end;
      ColorDialog1.Color := RGBtoCardinal(tmpRGB);
      if ColorDialog1.Execute then
      begin
        tmpRGB := CardinalToRGB(ColorToRGB(ColorDialog1.Color));
        SetSButtonColor(T, tmpRGB);
        Case T of
           3: LAtmpLight.AmbCol := tmpRGB;
           4: begin
                LAtmpLight.DynFogR := tmpRGB[0];
                LAtmpLight.DynFogG := tmpRGB[1];
                LAtmpLight.DynFogB := tmpRGB[2];
              end;
           6: LAtmpLight.AmbCol2   := tmpRGB;
          10: LAtmpLight.DepthCol  := tmpRGB;
          11: LAtmpLight.DepthCol2 := tmpRGB;
          12: LAtmpLight.Lights[TabControl1.TabIndex].Lcolor := tmpRGB;
          30: LAtmpLight.DynFogCol2 := tmpRGB;
        end;
        TriggerRepaint;
      end;
    end;
end;

procedure TLightAdjustForm.MakeGlyph(SB: TSpeedButton; PNr: Integer);
var BMP: TBitmap;
begin
    BMP := MakeColPresetGlyph(PNr);
    SB.Glyph.Assign(BMP);
    BMP.Free;
end;

procedure TLightAdjustForm.N01Click(Sender: TObject);
var t: Integer;
    P: TLpreset20;
begin
    t := (Sender as TMenuItem).Tag;
    if t in [1..15] then
    begin
      if t > 5 then P := CustomPresets[t]
               else P := ConvertColPreset164To20(Presets[t]);
      LAtmpLight.DepthCol  := CardinalToRGB(P.DepthCol);
      LAtmpLight.DepthCol2 := CardinalToRGB(P.DepthCol2);
      SetSButtonColor(10, LAtmpLight.DepthCol);
      SetSButtonColor(11, LAtmpLight.DepthCol2);
      TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.MakeDepthColList;
var i: Integer;
    P: TLpreset20;
    bmp: TBitmap;
    MI: TMenuItem;
begin
    ImageList1.Clear;
    PopupMenu2.Items.Clear;
    bmp := TBitmap.Create;
    bmp.PixelFormat := pf32Bit;
    bmp.Width := 32;
    bmp.Height := 16;
    for i := 1 to 15 do
    begin
      if i > 5 then P := CustomPresets[i]
               else P := ConvertColPreset164To20(Presets[i]);
      bmp.Canvas.Brush.Color := P.DepthCol and $FFFFFF;
      bmp.Canvas.FillRect(Rect(1,1,15,15));
      bmp.Canvas.Brush.Color := P.DepthCol2 and $FFFFFF;
      bmp.Canvas.FillRect(Rect(16,1,31,15));
      ImageList1.Add(bmp, nil);
      MI := TMenuItem.Create(PopupMenu2);
      MI.Caption := IntToStr(i);
      MI.Tag := i;
      MI.ImageIndex := i - 1;
      MI.OnClick := N01Click;
      PopupMenu2.Items.Add(MI);
    end;
    bmp.Free;
end;

procedure TLightAdjustForm.FormShow(Sender: TObject); //FormShow earlier than MainWindow.FormShow!!! -> IniDirs load onCreate
var i: Integer;
begin
    if bLFfirstShow then
    begin
      bLFfirstShow := False;
    //  if Testing then Showmessage('M3D lightform show...');
      SetStartPreset;
      if FormsSticky[1] = 0 then
        SetBounds(StrToIntTry(StrFirstWord(IniVal[27]), 844),
                  StrToIntTry(StrLastWord(IniVal[27]), 100), Width, Height);
      SetSButtonColor(3, LAtmpLight.AmbCol);
      SetSButtonColor(4, MakeDynFogCol);
      SetSButtonColor(6, LAtmpLight.AmbCol2);
      SetSButtonColor(10, LAtmpLight.DepthCol);
      SetSButtonColor(11, LAtmpLight.DepthCol2);
      SetSButtonColor(30, LAtmpLight.DynFogCol2);
      SetDialogDirectory(OpenDialogPic, IniDirs[6]);
      OpenDialog1.InitialDir := IniDirs[7];
      SaveDialog1.InitialDir := IniDirs[7];
      for i := 1 to 5 do
        MakeGlyph((FindComponent('SpeedButton' + IntToStr(i + 14)) as TSpeedButton), i);
 //     if Testing then Showmessage('M3D lightform load presets...');
      for i := 0 to 9 do
      begin
        if LoadColPreset(i) then
          MakeGlyph((FindComponent('SpeedButton' + IntToStr(i + 20)) as TSpeedButton), i + 6)
        else CustomPresets[i + 6] := ConvertColPreset164To20(Presets[5]);
      end;
      TabControl1Change(Sender);
   //   if Testing then Showmessage('M3D lightform show done');
      UpdateQuickLoadCB;
      //make popupm2 depthcol images and create items...
      MakeDepthColList;
    end;
end;

procedure TLightAdjustForm.UpdateQuickLoadCB;
var F: TSearchRec;
begin
    ComboBox3.Items.Clear;
    if FindFirst(IniDirs[7] + '*.m3l', faAnyFile, F) = 0 then
    begin
      repeat
        ComboBox3.Items.Add(ChangeFileExt(F.Name, ''));
      until FindNext(F) <> 0;
    end;
    FindClose(F);
end;

procedure TLightAdjustForm.Button1Click(Sender: TObject);   //Load Light paras
begin
    if OpenDialog1.Execute and GetLightParaFile(OpenDialog1.FileName, Mand3DForm.MHeader.Light, CheckBox11.Checked) then
    begin
      LoadBackgroundPicT(@Mand3DForm.MHeader.Light);
      SetLightFromHeader(Mand3DForm.MHeader);
      TriggerRepaint;
      ComboBox3.ItemIndex := -1;
      RepaintColHisto;
    end;
end;

procedure TLightAdjustForm.Button2Click(Sender: TObject); //Save Light paras
var f: file;
begin
    if SaveDialog1.Execute then
    begin
      PutLightFInHeader(Mand3DForm.MHeader);
      AssignFile(f, ChangeFileExtSave(SaveDialog1.FileName, '.m3l'));
      Rewrite(f, 1);
      BlockWrite(f, Mand3DForm.MHeader.Light, SizeOf(Mand3DForm.MHeader.Light));
      CloseFile(f);
      UpdateQuickLoadCB;
    end;
end;

function TLightAdjustForm.VisLightExBit(const Light: TLight8): Integer;
begin
    if (Light.Loption and 4) <> 0 then Result := (ComboBox5.ItemIndex and 4) shl 5
    else Result := (ComboBox4.ItemIndex and 4) shl 5;
end;

procedure TLightAdjustForm.ComboBox1Change(Sender: TObject);
begin
    if bUserChange then
    begin
      LAtmpLight.Lights[TabControl1.TabIndex].LFunction :=         // vislight source dependend on choosen light...
        ComboBox2.ItemIndex or (ComboBox1.ItemIndex shl 4) or
        VisLightExBit(LAtmpLight.Lights[TabControl1.TabIndex]);    // or ((ComboBox4(5).ItemIndex and 4) shl 5 // = bit 8 of 8
      TriggerRepaint;                                          // or VisLightFuncEx(LightNr)
    end;
end;

procedure TLightAdjustForm.SetLAplusPosToZero;
var x, y: Integer;
begin
    for y := 0 to 5 do for x := 0 to 2 do LAposMids[y, x] := 0;
    OldTB15Pos := 0;
    OldTB16Pos := 0;
    OldTB17Pos := 0;
end;

procedure TLightAdjustForm.FormCreate(Sender: TObject);
var x: Integer;
begin
    SetLAplusPosToZero;
    ColorFormCreated := False;
    for x := 0 to 5 do FreeLightMap(@LightMaps[x]);
    FreeLightMap(@DiffColMap);
    LAFormCreated := True;
end;

procedure TLightAdjustForm.FormDestroy(Sender: TObject);
begin
    LAtmpLight.Lights[0].Loption := 1;
end;

function TLightAdjustForm.VisFuncToIndex(const Light: TLight8): Integer;
const Ctab: array[0..3] of Integer = (0, 3, 1, 2);
begin
    Result := Ctab[(Light.Loption shr 3) and 3] or ((Light.LFunction and 128) shr 5);
end;

function TLightAdjustForm.IndexToVisFunc(i: Integer): Byte;
const Ctab: array[0..3] of Byte = (0, $10, $18, 8);
begin
    Result := Ctab[i and 3];
end;

procedure TLightAdjustForm.Insertvolumetriclightcolor1Click(Sender: TObject);
var i: Integer;
begin   //insert vol light color in dynfogs
    i := Max(0, Min(5, StrToIntTrim(Mand3DForm.Edit16.Text) - 1));
    LAtmpLight.DynFogCol2 := LAtmpLight.Lights[i].Lcolor;
    LAtmpLight.DynFogR := LAtmpLight.DynFogCol2[0];
    LAtmpLight.DynFogG := LAtmpLight.DynFogCol2[1];
    LAtmpLight.DynFogB := LAtmpLight.DynFogCol2[2];
    SetSButtonColor(4, LAtmpLight.DynFogCol2);
    SetSButtonColor(30, LAtmpLight.DynFogCol2);
    TriggerRepaint;
end;

function TLightAdjustForm.GetPageContr1index(Loption: Byte): Integer;
const pc1: array[0..3] of Integer = (0, 2, 1, 0);
begin
    Result := pc1[(Loption shr 1) and 3];  //bit2: lmap bit3: poslight.. 0-0 1-2 2-1
end;

procedure TLightAdjustForm.TabControl1Change(Sender: TObject); //Light nr tab
var i, n, n2: Integer;
    btmp: LongBool;
begin
    btmp := bUserChange;
    bUserChange := False;
    try
      i := TabControl1.TabIndex;
      CheckBox4.Checked := (LAtmpLight.Lights[i].Loption and 1) = 0;
      CheckBox7.Checked := (LAtmpLight.Lights[i].Loption and $40) = 0;
      n := PageControl1.TabIndex;
      n2 := GetPageContr1index(LAtmpLight.Lights[i].Loption);
      if (n <> 1) or (n = n2) then PageControl1.SelectNextPage(n = 0);
      n := PageControl1.TabIndex;
      if n <> n2 then PageControl1.SelectNextPage(n < n2);
      SetSButtonColor(12, LAtmpLight.Lights[i].Lcolor);
      ComboBox2.ItemIndex := LAtmpLight.Lights[i].LFunction and $07;          //spec func
      ComboBox1.ItemIndex := (LAtmpLight.Lights[i].LFunction shr 4) and 3;    //amb func
      ComboBox4.ItemIndex := VisFuncToIndex(LAtmpLight.Lights[i]);    //vis poslight func
      ComboBox5.ItemIndex := ComboBox4.ItemIndex;
    finally
      bUserChange := btmp;
    end;
end;

procedure TLightAdjustForm.TrackBar1Change(Sender: TObject);  //global light angles
var d7: Double7B;
begin
    if bUserChange then
    begin
      d7 := LAtmpLight.Lights[TabControl1.TabIndex].LXpos;
      LAtmpLight.Lights[TabControl1.TabIndex].LXpos := DoubleToD7B(TrackBar1.Position * -Pid180);
      if not D7Bequal(d7, LAtmpLight.Lights[TabControl1.TabIndex].LXpos) then TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.TrackBarYangleChange(Sender: TObject);
var d7: Double7B;
begin
    if bUserChange then
    begin
      d7 := LAtmpLight.Lights[TabControl1.TabIndex].LYpos;
      LAtmpLight.Lights[TabControl1.TabIndex].LYpos := DoubleToD7B(TrackBar2.Position * Pid180);
      if not D7Bequal(d7, LAtmpLight.Lights[TabControl1.TabIndex].LYpos) then TriggerRepaint;
    end;  
end;

procedure TLightAdjustForm.SetStartPreset;
var P: TLpreset20;
begin
    P := ConvertColPreset16To20(@StartPreset);
    P.Lights[2] := defaultLight8;  //lights[1] too..
    P.Lights[3] := defaultLight8;
    FastMove(P.AmbCol, LAtmpLight.AmbCol, 16);
    FastMove(P.Lights, LAtmpLight.Lights, 316);
    UpdateLightParasAbove3(LAtmpLight); //new
    PutLightFInHeader(Mand3DForm.MHeader);
    Mand3DForm.MHeader.Light.DynFogCol2 := MakeDynFogCol;
    SetLightFromHeader(Mand3DForm.MHeader);
    TrackBar7.Position := StartPreset.TB578pos[0];
    TrackBar5.Position := StartPreset.TB578pos[1];
    TrackBar8.Position := StartPreset.TB578pos[2];
end;
  { TLight8 = packed record
    Loption:    Byte;              // bit1: 0: On  1: Off;  bit2: lightmap;  bit3 = bPosLight, bit4+5 = poslight visible+func, bit6 = global light rel to object, bit7 = HSon
    LFunction:  Byte;              // 4bit spec func + 2bit diff,  Spec expo = 8 shl (LFunction and $07), diff = (LFunction shr 4) and 3
    Lamp:       Word;              // Light amplitude for posLight -> exp 8bit shortint + 8bit byte mant for wide range! -> for all lights
    Lcolor:     TRGB;              // RGB 24bit
    LightMapNr: Word;              // 0: no LM, 1..32000: LMnr,  LM works as ambient light was byte, now with ..Ex as word!
    LXpos: Double7B;
    AdditionalByteEx: Byte;        // LVersionEx in Light[0] and DiffMapNrEx in Light[1], diffmap scale in Light[2], diff shadowing in Light[3], BGscale in Light[4]
    LYpos: Double7B;
    FreeByte: Byte;                // iColOnOT := 2 + (HLight.Lights[1].FreeByte and 3);  HLight.Lights[0].FreeByte for bgpic options
    LZpos: Double7B;               // HLight.Lights[2].FreeByte  iExModes
  end;                             // 32 Byte    (+72 byte for 4 lights, +136 byte for 6 lights, +200 byte for 8 lights)
    }
procedure TLightAdjustForm.SetPreset(nr: Integer; KeepLights: LongBool);
var P: TLpreset20;
    i: Integer;
    ba: array[0..5] of Byte;
begin
    if nr > 5 then P := CustomPresets[nr]
              else P := ConvertColPreset164To20(Presets[nr]);
    UpdatePresetFrom20(P);
    FastMove(P.AmbCol, LAtmpLight.AmbCol, 15);
    if not KeepLights then
    begin
      for i := 0 to 5 do if (P.Lights[i].Loption and 1) = 0 then  //only lights that are on, else just turn off...
      begin
        // FastMove(P.Lights[i], LAtmpLight.Lights[i], 32)
        FastMove(P.Lights[i], LAtmpLight.Lights[i], 16);  //only up to AdditionalByteEx
        LAtmpLight.Lights[i].LYpos := P.Lights[i].LYpos;
        LAtmpLight.Lights[i].LZpos := P.Lights[i].LZpos;
      end
      else LAtmpLight.Lights[i].Loption := LAtmpLight.Lights[i].Loption or 1;
    end
    else for i := 0 to 5 do ba[i] := LAtmpLight.Lights[i].LFunction and $80;
    FastMove(P.LCols, LAtmpLight.LCols, 124); //object cols out+inside
    LAtmpLight.TBoptions := (LAtmpLight.TBoptions and $FF8FFFFF) or (4 shl 20);
    UpdateLightParasAbove3(LAtmpLight);
    LAtmpLight.Lights[3].FreeByte := P.Lights[3].FreeByte; //NN col ipol
    if KeepLights then for i := 0 to 5 do
      LAtmpLight.Lights[i].LFunction := (LAtmpLight.Lights[i].LFunction and $7F) or ba[i]; //visLight nr4
    SetSButtonColor(3, LAtmpLight.AmbCol);
    SetSButtonColor(4, MakeDynFogCol);
    SetSButtonColor(6, LAtmpLight.AmbCol2);
    SetSButtonColor(10, LAtmpLight.DepthCol);
    SetSButtonColor(11, LAtmpLight.DepthCol2);
    LAtmpLight.DynFogCol2 := MakeDynFogCol;       //DFC2 is not in preset
    SetSButtonColor(30, LAtmpLight.DynFogCol2);
    bUserChange := False;
    CheckBox22.Checked := LAtmpLight.Lights[3].FreeByte <> 0;
    SetSDButtonColors;
    TrackBar7.Position := P.TB578pos[0];
    TrackBar5.Position := P.TB578pos[1];
    TrackBar8.Position := P.TB578pos[2];
    if ColorForm.Visible then ColorForm.RepaintImage(@LAtmpLight, False);
    if not KeepLights then
    begin
      TabControl1Change(Self);
      SetLAplusPosToZero;
      for i := 0 to 5 do if (p.Lights[i].Loption and 12) > 0 then SetPosLightTo0(i);
      UpdateTabHeader(-1);
    end;
    ComboBox3.ItemIndex := -1;
    bUserChange := True;
end;

procedure TLightAdjustForm.GetPreset(nr: Integer);
begin
    if nr > 5 then
    begin
      FastMove(LAtmpLight.AmbCol, CustomPresets[nr].AmbCol, 16);
      FastMove(LAtmpLight.Lights, CustomPresets[nr].Lights, 316);
      CustomPresets[nr].TB578pos[0] := TrackBar7.Position;
      CustomPresets[nr].TB578pos[1] := TrackBar5.Position;
      CustomPresets[nr].TB578pos[2] := TrackBar8.Position;
    end;
end;

procedure TLightAdjustForm.SpeedButton15Click(Sender: TObject); //preset pushed
var SB: TSpeedButton;
    t, i: Integer;
begin
    SB := Sender as TSpeedButton;
    t  := SB.Tag;
    if SB.Cursor = crUpArrow then
    begin
      SpeedButtonMem.Down := False;
      for i := 20 to 29 do
        (FindComponent('SpeedButton' + IntToStr(i)) as TSpeedButton).Cursor := crDefault;
      GetPreset(t);
      SaveColPreset(t - 6);
      MakeGlyph(SB, t);
    end else begin
      SetPreset(t, CheckBox11.Checked);
      TriggerRepaint;
    end;  
end;

procedure TLightAdjustForm.SpeedButtonMemClick(Sender: TObject);
var i: Integer;
begin
    if SpeedButton20.Cursor = crUpArrow then
    begin
      for i := 20 to 29 do
        (FindComponent('SpeedButton' + IntToStr(i)) as TSpeedButton).Cursor := crDefault;
      SpeedButtonMem.Down := False;
    end else begin
      for i := 20 to 29 do
        (FindComponent('SpeedButton' + IntToStr(i)) as TSpeedButton).Cursor := crUpArrow;
    end;
end;

procedure TLightAdjustForm.SBFineAdjClick(Sender: TObject);
begin
    if SBFineAdj.Down then
    begin
      TBcolStartPos := TrackBar9.Position;
      TBcolStopPos  := TrackBar10.Position;
      TrackBar9.Position  := 0;
      TrackBar10.Position := 60;
    end
    else
    begin
      bUserChange := False;
      TrackBar9.Position  := TBcolStartPos;
      bUserChange := True;
      TrackBar10.Position := TBcolStopPos;
    end;
    RepaintColHisto;
end;

procedure TLightAdjustForm.CheckBox1Click(Sender: TObject); //Color cycling
begin
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.CheckBox21Click(Sender: TObject); //use a small image as ambient color
begin
    if CheckBox21.Checked then
    begin
      if CheckBox8.Checked then
      begin
        MakeSmallLMimage(@M3DSmallBGpic, @M3DBackGroundPic);
        //test:
     //   MakeLMPreviewImage(Image5, @M3DSmallBGpic);
      end
      else CheckBox21.Checked := False;
    end;
    SpeedButton3.Enabled := not CheckBox21.Checked;
    SpeedButton6.Enabled := not CheckBox21.Checked;
    TrackBar8.Enabled := not CheckBox21.Checked;
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.CheckBox22Click(Sender: TObject);
begin
    LAtmpLight.Lights[3].FreeByte := Ord(CheckBox22.Checked) and 1;
    if ColorFormCreated and ColorForm.Visible then
      ColorForm.RepaintImage(@LAtmpLight, False);
    SetSDButtonColors;
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.CheckBox2Click(Sender: TObject);
begin
    RepaintColHisto;
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.SpeedButton2Click(Sender: TObject); //Object Colors change
begin
    ColorForm.Visible := True;
    ColorForm.BringToFront;
    if (Sender is TSpeedButton) and ((Sender as TSpeedButton).Tag = 33) then
      ColorForm.RadioGroup1.ItemIndex := 1 else ColorForm.RadioGroup1.ItemIndex := 0;
end;

procedure TLightAdjustForm.UpdateTabHeader(nr: Integer);
var i, i1, i2: Integer;
begin
    i1 := nr;
    i2 := nr;
    if nr < 0 then
    begin
      i1 := 0;
      i2 := 5;
    end;
    for i := i1 to i2 do if (LAtmpLight.Lights[i].Loption and 1) = 0 then
      TabControl1.Tabs[i] := 'Li.' + IntToStr(i + 1) + ' •'
    else
      TabControl1.Tabs[i] := 'Li.' + IntToStr(i + 1);
end;

procedure TLightAdjustForm.CheckBox4Click(Sender: TObject);
begin    //light on/off
    if bUserChange then
    begin
      LAtmpLight.Lights[TabControl1.TabIndex].LOption := (LAtmpLight.Lights[TabControl1.TabIndex].LOption and $F8)
        or (1 - (Byte(CheckBox4.Checked) and 1)) or (GetPageContr1index(PageControl1.TabIndex shl 1) shl 1);
      TriggerRepaint;
    end;
    UpdateTabHeader(TabControl1.TabIndex);
end;

procedure TLightAdjustForm.CheckBox7Click(Sender: TObject);  //HS enabled = bit7, default = on = 0
begin
    if bUserChange then
    begin
      if CheckBox7.Checked then LAtmpLight.Lights[TabControl1.TabIndex].Loption :=
        LAtmpLight.Lights[TabControl1.TabIndex].Loption and $BF
      else LAtmpLight.Lights[TabControl1.TabIndex].Loption :=
        LAtmpLight.Lights[TabControl1.TabIndex].Loption or $40;
      if CheckBox4.Checked then TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.SetPosLightTo0(tab: Integer);
begin
    TPVec3D(@LAposMids[tab])^ := DVecFromLightPos(LAtmpLight.Lights[tab]);
    OldTB15Pos := 0;
    OldTB16Pos := 0;
    OldTB17Pos := 0;
end;

procedure TLightAdjustForm.PageControl1Change(Sender: TObject);
var i: Integer;
    b: LongBool;
begin
    i := TabControl1.TabIndex;
    b := bUserChange;
    if b then LAtmpLight.Lights[i].Loption := (LAtmpLight.Lights[i].Loption and $F9) or
                                              (GetPageContr1index(PageControl1.TabIndex shl 1) shl 1);
    SpeedButton12.Visible := PageControl1.TabIndex < 2;
    ComboBox1.Enabled := SpeedButton12.Visible;
    ComboBox2.Enabled := SpeedButton12.Visible;

    bUserChange := False;
    if PageControl1.TabIndex = 0 then  //global light
    begin
      if b then
      begin
        LAtmpLight.Lights[i].LightMapNr := 0;
        TrackBar1.Position := 0;
        TrackBar2.Position := 0;
        LAtmpLight.Lights[i].LYpos := CDouble7B0;
        LAtmpLight.Lights[i].LXpos := CDouble7B0;
        LAtmpLight.Lights[i].Lamp := Word(SingleToShortFloat(1));
      end else begin
        TrackBar2.Position := Round(D7BtoDouble(LAtmpLight.Lights[i].LYpos) * -M180dPi);
        TrackBar1.Position := Round(D7BtoDouble(LAtmpLight.Lights[i].LXpos) * M180dPi);
      end;
      CheckBox6.Checked := (LAtmpLight.Lights[i].Loption and $20) > 0;
    end
    else if PageControl1.TabIndex = 1 then
    begin        //positional light
      if b then LAtmpLight.Lights[i].LightMapNr := 0;
      TrackBar16.Position := 0;
      TrackBar15.Position := 0;
      TrackBar17.Position := 0;
      OldTB15pos := 0;
      OldTB16pos := 0;
      OldTB17pos := 0;
      if b then //new: set light amount based on zoom
        LAtmpLight.Lights[i].Lamp := Word(SingleToShortFloat(1 / Mand3DForm.MHeader.dZoom));
      Edit1.Text := ShortFloatToStr(ShortFloat(LAtmpLight.Lights[i].Lamp)); //FloatToStrSingle(ShortFloatToSingle(@LAtmpLight.Lights[i].Lamp));
    end
    else  //LightMap
    begin
      if b then
      begin
        Inc(RepaintCounter);
        TrackBar26.Position := 128;
        TrackBar25.Position := 128;
        TrackBar27.Position := 128;
        LAtmpLight.Lights[i].LXpos[0] := 128;
        LAtmpLight.Lights[i].LYpos[0] := 128;
        LAtmpLight.Lights[i].LZpos[0] := 128;
        UpDownLight.Position := 1;
        LAtmpLight.Lights[i].LightMapNr := 1;
        LAtmpLight.Lights[i].Lamp := Word(SingleToShortFloat(1));
      end else begin
        TrackBar26.Position := LAtmpLight.Lights[i].LXpos[0];
        TrackBar25.Position := LAtmpLight.Lights[i].LYpos[0];
        TrackBar27.Position := LAtmpLight.Lights[i].LZpos[0];
        UpDownLight.Position := LAtmpLight.Lights[i].LightMapNr;
        if LAtmpLight.Lights[i].LightMapNr = 0 then
        begin
          LAtmpLight.Lights[i].LightMapNr := 1;
          UpDownLight.Position := 1;
          TriggerRepaint;
        end;
      end;
      CheckBox14.Checked := (LAtmpLight.Lights[i].Loption and $20) > 0;
      LoadLightMapNr(UpDownLight.Position, @LightMaps[i]);
      MakeLMPreviewImage(Image3, @LightMaps[TabControl1.TabIndex]);
    end;
    Edit1.Text := ShortFloatToStr(ShortFloat(LAtmpLight.Lights[i].Lamp));
    bUserChange := b;
    if b then TriggerRepaint;
end;

procedure TLightAdjustForm.TrackBar16Change(Sender: TObject);    //posLight
var dm, d: Double;
    dv, lp, lv, cp: TVec3D;
    m: TMatrix3;
    i: Integer;
begin
    if bUserChange then
    begin
      i := TabControl1.TabIndex;
      CalcStepWidth(@Mand3DForm.MHeader);
      m := NormaliseMatrixTo(1, @Mand3DForm.MHeader.hVGrads);

      cp := CalcCamPos(@Mand3DForm.MHeader);
      lp := DVecFromLightPos(LAtmpLight.Lights[i]);
      lv := SubtractVectors(lp, cp);  //vec from cam to light

      if Mand3DForm.MHeader.bStereoMode = 2 then d := 180 else d := Mand3DForm.MHeader.dFOVy;

   //   dm := Abs(DotOfVectors(@dv, @m[2]));      //distance from viewplane to lightpos

      dm := LengthOfVec(lv);

      dm := (Mand3DForm.MHeader.dStepWidth + dm * Sin(d * Pid180 / Mand3DForm.MHeader.Height))
            * LengthOfSize(@Mand3DForm.MHeader) * 0.0025;

      dv[0] := (TrackBar16.Position - OldTB16pos) * dm;   //-180..180 pos
      dv[1] := (TrackBar15.Position - OldTB15pos) * -dm;
      dm := (TrackBar17.Position - OldTB17pos) * dm;  //new
      dv[2] := 0; //new
      OldTB15pos := TrackBar15.Position;
      OldTB16pos := TrackBar16.Position;

      //lv rotated m (like in normals calc rough) for movement?

      TranslatePos(@lp, @dv, @m);
      if TrackBar17.Position <> OldTB17pos then   //new
      begin
        OldTB17pos := TrackBar17.Position;
        dv := NormaliseVectorTo(1, lv);
        mAddVecWeight(@lp, @dv, dm);
      end;
      SetLightPosFromDVec(LAtmpLight.Lights[i], lp);
      LAposMids[i] := TPos3D(DVecFromLightPos(LAtmpLight.Lights[i]));
      TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.TrackBar16MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    bUserChange := False;
    try
      (Sender as TTrackBarEx).Position := 0;
      if Sender = TrackBar15 then OldTB15pos := 0 else
      if Sender = TrackBar16 then OldTB16pos := 0 else
      if Sender = TrackBar17 then OldTB17pos := 0;
    finally
      bUserChange := True;
    end;
end;

procedure TLightAdjustForm.UpDown1Click(Sender: TObject; Button: TUDBtnType); //poslight move 1 step
var t, i: Integer;
    d: Double;
    dv, lv: TVec3D;
    m: TMatrix3;
begin
    i := TabControl1.TabIndex;
    CalcStepWidth(@Mand3DForm.MHeader);
    m := NormaliseMatrixTo(1, @Mand3DForm.MHeader.hVGrads);
    dv := GetRealMidPos(@Mand3DForm.MHeader);
    mAddVecWeight(@dv, @m[2], Mand3DForm.MHeader.dZstart - Mand3DForm.MHeader.dZmid); //Startpos on viewplane
    lv := DVecFromLightPos(LAtmpLight.Lights[i]);
    dv := SubtractVectors(@lv, dv);  //vec from cam to light
    d := Abs(DotOfVectors(@dv, @m[2]));                      //distance from viewplane to lightpos
    d := (Mand3DForm.MHeader.dStepWidth + d * Sin(Mand3DForm.MHeader.dFOVy * Pid180 / Mand3DForm.MHeader.Height)) * s05;
    t := (Sender as TUpDown).Tag;
    if Button <> btNext then d := -d;
    if t = 1 then d := -d;
    mAddVecWeight(@lv, @m[t], d);
    SetLightPosFromDVec(LAtmpLight.Lights[i], lv);
    mAddVecWeight(@LAposMids[i], @m[t], d);
    TriggerRepaint;
end;

procedure TLightAdjustForm.UpDown4Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btPrev then SpinButton1Down else
    if Button = btNext then SpinButton1Up;
end;

procedure TLightAdjustForm.Edit1Change(Sender: TObject);
var d: Double;
begin
    if bUserChange then
    begin
      if StrToFloatKtry(Edit1.Text, d) then
      begin
        LAtmpLight.Lights[TabControl1.TabIndex].Lamp := Word(SingleToShortFloat(d));
        TriggerRepaint;
      end;
    end;
end;

procedure TLightAdjustForm.Edit2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin   //Rightclick on MapEditField will bring up opendialog for lightmap
    if Button = mbRight then
    begin
      SetDialogDirectory(OpenPictureDialog1, IniDirs[9]);
      OpenPictureDialog1.FileName := (Sender as TEdit).Text;
      if OpenPictureDialog1.Execute and (GetFirstNumberFromFilename(OpenPictureDialog1.FileName) > '') then
        (Sender as TEdit).Text := GetFirstNumberFromFilename(OpenPictureDialog1.FileName);
    end;
end;

procedure TLightAdjustForm.ButtonGetPosClick(Sender: TObject);
begin
    if ButtonGetPos.Caption = 'image' then
    begin
      ButtonGetPos.Caption := 'mid';
      Mand3DForm.iGetPosFromImage := 0;
      Mand3DForm.SetImageCursor;
    end
    else
    begin
      if PostProForm.CheckBox21.Checked then PostProForm.CheckBox21.Checked := False;
      if PostProForm.CheckBox25.Checked then PostProForm.CheckBox25.Checked := False;
      ButtonGetPos.Caption := 'image';
      Mand3DForm.iGetPosFromImage := 2;
      Mand3DForm.MButtonsUp;
      Mand3DForm.Image1.Cursor := crCross;
      bUserChange := False;
      SetPosLightTo0(TabControl1.TabIndex);
      TrackBar15.Position := 0;
      TrackBar16.Position := 0;
      TrackBar17.Position := 0;
      bUserChange := True;
    end;
end;

procedure TLightAdjustForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
    if bUserChange then SetPosLightTo0(TabControl1.TabIndex);
end;

procedure TLightAdjustForm.TabControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
    if (PageControl1.ActivePageIndex = 1) then SetPosLightTo0(TabControl1.TabIndex);
end;

procedure TLightAdjustForm.FogResetButtonClick(Sender: TObject);
begin
    TrackBar3.Position := 128;
    TrackBar6.Position := 53;
    TrackBar19.Position := 128;
end;

function FindVecAngles(var d1, d2: Double; sv: TPSVec; m: TPMatrix3; bAbs: LongBool): Double;
var i, iskip, x, y: Integer;
    dmin, dt, db1, db2: Double;
    svt: TSVec;
function AbsErr(sv1, sv2: TPSVec): Double;
begin
    Result := Abs(sv1[0] - sv2[0]) + Abs(sv1[1] - sv2[1]) + Abs(sv1[2] - sv2[2]);
end;
begin
    dmin := 1000;
    for y := -5 to 5 do for x := -5 to 5 do
    begin
      d1 := x * Pi * 0.2;
      d2 := y * Pi * 0.2;
      BuildViewVectorFOV(d2, d1, @svt);
      SVectorChangeSign(@svt);
      if bAbs then RotateSVectorReverse(@svt, m);
      NormaliseSVectorVar(svt);
      dt := AbsErr(sv, @svt);
      if dt < dmin then
      begin
        dmin := dt;
        db1 := d1;
        db2 := d2;
      end;
    end;
    d1 := db1;
    d2 := db2;

    i := 4000;
    repeat
      if (i and 1) = 1 then d1 := db1 + dmin * 0.001   //gradient proof
                       else d2 := db2 + dmin * 0.001;
      BuildViewVectorFOV(d2, d1, @svt);
      SVectorChangeSign(@svt);
      if bAbs then RotateSVectorReverse(@svt, m);
      NormaliseSVectorVar(svt);
      dt := AbsErr(sv, @svt);
      dt := dmin * dmin * 0.001 / NonZero(dmin - dt);  //stepwidth based on gradient and result
      if (i and 1) = 1 then d1 := db1 + dt else d2 := db2 + dt;
      BuildViewVectorFOV(d2, d1, @svt);
      SVectorChangeSign(@svt);
      if bAbs then RotateSVectorReverse(@svt, m);
      NormaliseSVectorVar(svt);
      dt := AbsErr(sv, @svt);
      if dt < dmin then
      begin
        dmin := dt;
        db1 := d1;
        db2 := d2;
      end else begin
        d1 := db1;
        d2 := db2;
      end;
      Dec(i);
    until (i < 0) or (dmin < 1e-7);

    while d1 < -Pi do d1 := d1 + Pi * 2;
    while d1 > Pi do d1 := d1 - Pi * 2;
    while d2 < -Pi do d2 := d2 + Pi * 2;
    while d2 > Pi do d2 := d2 - Pi * 2;
    Result := dmin;
end;

procedure TLightAdjustForm.CheckBox6Click(Sender: TObject);
var sv: TSVec;
    dtmp, dtmp2: Double;
    Lnr: Integer;
begin
    if bUserChange then   //global light / LightMap rel to object
    begin
      Lnr := TabControl1.TabIndex;
      if Sender = CheckBox6 then
      begin  //global light, convert angles so that lightvec stays same
        dtmp := -D7BtoDouble(LAtmpLight.Lights[Lnr].LXpos);  //-pi..pi   -180..180
        dtmp2 := D7BtoDouble(LAtmpLight.Lights[Lnr].LYpos);
        BuildViewVectorFOV(dtmp2, dTmp, @sv);
        SVectorChangeSign(@sv);
        if not CheckBox6.Checked then RotateSVectorReverse(@sv, @Mand3DForm.MHeader.hVGrads);
        NormaliseSVectorVar(sv);
        if FindVecAngles(dtmp, dtmp2, @sv, @Mand3DForm.MHeader.hVGrads, CheckBox6.Checked) < 1e-3 then
        begin  //set sliders
          LAtmpLight.Lights[Lnr].LXpos := DoubleToD7B(-dtmp);
          LAtmpLight.Lights[Lnr].LYpos := DoubleToD7B(dtmp2);
          bUserChange := False;
          TrackBar1.Position := Round(dtmp * -M180dPi);
          TrackBar2.Position := Round(dtmp2 * -M180dPi);
          bUserChange := True;
        end;
      end;
      if (Sender as TCheckBox).Checked then
        LAtmpLight.Lights[Lnr].Loption := LAtmpLight.Lights[Lnr].Loption or $20
      else LAtmpLight.Lights[Lnr].Loption := LAtmpLight.Lights[Lnr].Loption and $DF;
      TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.CheckBox8Click(Sender: TObject);   //background image
var bLoadSuccess: LongBool;
begin
    if bUserChange then
    begin
      bLoadSuccess := False;
      if CheckBox8.Checked and OpenDialogPic.Execute then
      begin
        Inc(RepaintCounter);
        PutStringInLightFilename(LAtmpLight.BGbmp, ExtractFileName(OpenDialogPic.FileName));
        bLoadSuccess := LoadBackgroundPicT(@LAtmpLight);
       // if not bLoadSuccess then question: should i copy it to the bg directory?...
      end;
      if not bLoadSuccess then
      begin
        bUserChange := False;
        CheckBox8.Checked := False;
        bUserChange := True;
        LAtmpLight.BGbmp[0] := 0;
        SetLength(M3DBackGroundPic.LMa, 0);
        M3DBackGroundPic.LMWidth := 0;
        M3DBackGroundPic.LMHeight := 0;
      end;
      TriggerRepaint;
    end;
    if LAtmpLight.BGbmp[0] = 0 then Image5.Visible := False else
      MakeLMPreviewImage(Image5, @M3DBackGroundPic);
    FastMove(LAtmpLight.BGbmp, LastBGname, 24);
    if not CheckBox8.Checked then CheckBox21.Checked := False;
end;

procedure TLightAdjustForm.TrackBar21KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = '0' then (Sender as TTrackBar).Position := (Sender as TTrackBar).SelStart;
end;

procedure TLightAdjustForm.TrackBar22Change(Sender: TObject);
begin
    if bUserChange and TBChanged then
    begin
      TriggerRepaint;
      if FNaviFormCreated and FNavigator.Visible and (FNavigator.NaviLightVals.iBackBMP = 1) then
      begin
        FNavigator.NaviHeader.Light.PicOffsetX := TrackBar20.Position;
        FNavigator.NaviHeader.Light.PicOffsetY := TrackBar21.Position;
        FNavigator.NaviHeader.Light.PicOffsetZ := TrackBar22.Position;
        FNavigator.NewCalc;
      end;
    end;
end;

procedure TLightAdjustForm.TrackBar11KeyPress(Sender: TObject; var Key: Char);
begin
    if Key = '1' then (Sender as TTrackBar).Position := (Sender as TTrackBar).SelStart;
end;

procedure TLightAdjustForm.SpeedButton9MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then RestoreUndoLight else
    if Button = mbRight then RedoLight else Exit;
    SetLightFromHeader(Mand3DForm.MHeader);
    ComboBox3.ItemIndex := -1;
    TriggerRepaint;
end;

procedure TLightAdjustForm.ComboBox3Select(Sender: TObject);
begin
    if GetLightParaFile(IniDirs[7] + ChangeFileExt(ComboBox3.Items[ComboBox3.ItemIndex], '.m3l'),
                        Mand3DForm.MHeader.Light, CheckBox11.Checked) then
    begin
      LoadBackgroundPicT(@Mand3DForm.MHeader.Light);
      SetLightFromHeader(Mand3DForm.MHeader);
      TriggerRepaint;
      ComboBox3.Font.Color := clWindowText;
      ComboBox3.SetFocus;
      RepaintColHisto;
    end;
end;

procedure TLightAdjustForm.ComboBox3DropDown(Sender: TObject);
begin
    if ComboBox3.Font.Color <> clWindowText then
    begin
      ComboBox3.Font.Color := clWindowText;
      ComboBox3.ItemIndex := -1;
    end;
end;

procedure TLightAdjustForm.ComboBox4Change(Sender: TObject);
var t: Integer;
begin
    if bUserChange then
    begin
      t := TabControl1.TabIndex;
      bUserChange := False;
      if PageControl1.TabIndex = 0 then
      begin
        LAtmpLight.Lights[t].Loption :=
          (LAtmpLight.Lights[t].Loption and $E7) or IndexToVisFunc(ComboBox4.ItemIndex);
        ComboBox5.ItemIndex := ComboBox4.ItemIndex;
      end
      else
      begin
        LAtmpLight.Lights[t].Loption :=
         (LAtmpLight.Lights[t].Loption and $E7) or IndexToVisFunc(ComboBox5.ItemIndex);
        ComboBox4.ItemIndex := ComboBox5.ItemIndex;
      end;
      LAtmpLight.Lights[t].LFunction :=
        (LAtmpLight.Lights[t].LFunction and $3F) or ((ComboBox4.ItemIndex and 4) shl 5);
      bUserChange := True;
      TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.SpeedButton3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then
    begin
      LAtmpLight.AmbCol := LAtmpLight.DepthCol;
      LAtmpLight.AmbCol2 := LAtmpLight.DepthCol2;
      SetSButtonColor(3, LAtmpLight.AmbCol);
      SetSButtonColor(6, LAtmpLight.AmbCol2);
      TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.SpeedButton4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var mp: TPoint;
begin
    if (Button = mbRight) and Mand3DForm.UpDown5.Visible then
    begin
      GetCursorPos(mp);
      PopupMenu3.Popup(mp.X, mp.Y);
    end;
end;

procedure TLightAdjustForm.SpinButton1Down;  //decrease intensity
var d: Double;
begin
    if not StrToFloatKtry(Edit1.Text, d) then d := 1;
    d := d * 0.707;
    LAtmpLight.Lights[TabControl1.TabIndex].Lamp := Word(SingleToShortFloat(d));
    Edit1.Text := ShortFloatToStr(ShortFloat(LAtmpLight.Lights[TabControl1.TabIndex].Lamp));
end;

procedure TLightAdjustForm.SpinButton1Up;    //increase intensity
var d: Double;
begin
    if not StrToFloatKtry(Edit1.Text, d) then d := 1;
    d := d * 1.414;
    LAtmpLight.Lights[TabControl1.TabIndex].Lamp := Word(SingleToShortFloat(d));
    Edit1.Text := ShortFloatToStr(ShortFloat(LAtmpLight.Lights[TabControl1.TabIndex].Lamp));
end;

procedure TLightAdjustForm.TrackBar26Change(Sender: TObject);     //Lightmap rotation x,y,z
var n: Integer;
begin
    if bUserChange then
    begin
      n := 0;
      if TrackBar26.Position <> LAtmpLight.Lights[TabControl1.TabIndex].LXpos[0] then Inc(n);
      LAtmpLight.Lights[TabControl1.TabIndex].LXpos[0] := TrackBar26.Position;
      if TrackBar25.Position <> LAtmpLight.Lights[TabControl1.TabIndex].LYpos[0] then Inc(n);
      LAtmpLight.Lights[TabControl1.TabIndex].LYpos[0] := TrackBar25.Position;
      if TrackBar27.Position <> LAtmpLight.Lights[TabControl1.TabIndex].LZpos[0] then Inc(n);
      LAtmpLight.Lights[TabControl1.TabIndex].LZpos[0] := TrackBar27.Position;
      if n > 0 then TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.SpinEdit1Change(Sender: TObject); //lightmap nr change
begin
    if bUserChange then
    begin
      Inc(RepaintCounter);
      LAtmpLight.Lights[TabControl1.TabIndex].LightMapNr := UpDownLight.Position;
    end;
    LoadLightMapNr(UpDownLight.Position, @LightMaps[TabControl1.TabIndex]);
    MakeLMPreviewImage(Image3, @LightMaps[TabControl1.TabIndex]);
    if bUserChange then TriggerRepaint;
end;

function TLightAdjustForm.OverForm(p: TPoint): LongBool;
begin
    Result := (p.X >= 0) and (p.Y >= 0) and (p.X < Width) and (p.Y < Height);
end;

procedure TLightAdjustForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
    if not OverForm(ScreenToClient(MousePos)) then
    begin
      Handled := True;
      Mand3DForm.FormMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
      Exit;
    end;
    if UpDownLight.Focused then
    begin
      Handled := True;
      if WheelDelta > 0 then
        UpDownLight.Position := UpDownLight.Position + 1
      else if WheelDelta < 0 then
        UpDownLight.Position := UpDownLight.Position - 1;
    end
    else if UpDownDiffMap.Focused then
    begin
      Handled := True;
      if WheelDelta > 0 then
        UpDownDiffMap.Position := UpDownDiffMap.Position + 1
      else if WheelDelta < 0 then
        UpDownDiffMap.Position := UpDownDiffMap.Position - 1;
    end
    else if Edit1.Focused then
    begin
      Handled := True;
      if WheelDelta > 0 then SpinButton1Up else
      if WheelDelta < 0 then SpinButton1Down;
    end;
end;

procedure TLightAdjustForm.SpinEdit2Change(Sender: TObject);
begin   //diffmap nr change
    if bUserChange then
    begin
      Inc(RepaintCounter);
      LAtmpLight.bColorMap := UpDownDiffMap.Position and $FF;
      LAtmpLight.Lights[1].AdditionalByteEx := UpDownDiffMap.Position shr 8;
    end;
    LoadLightMapNr(UpDownDiffMap.Position, @DiffColMap);
    MakeLMPreviewImage(Image4, @DiffColMap);
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.CheckBox15Click(Sender: TObject);
begin
    Panel1.Visible := not CheckBox15.Checked;
    Panel2.Visible := CheckBox15.Checked;
    if CheckBox15.Checked then
    begin
      if bUserChange then Inc(RepaintCounter);
      LoadLightMapNr(UpDownDiffMap.Position, @DiffColMap);
      MakeLMPreviewImage(Image4, @DiffColMap);
    end;
    if bUserChange then TriggerRepaint;
end;

procedure TLightAdjustForm.CheckBox16Click(Sender: TObject); //DiffMap on normals
begin
    if bUserChange then
    begin
      bUserChange := False;
      if RadioGroup1.ItemIndex > 1 then
      try
        if not CompareMem(@Mand3DForm.MHeader.dZoom, @LastZoom, 8) then
        begin
          LastZoom := Mand3DForm.MHeader.dZoom;
          LastPositionDMScale[2] := Round(Log10(LastZoom) * 12 + 30);
          LastPositionDMScale[3] := LastPositionDMScale[2];
        end;
        TrackBar31.Position := LastPositionDMScale[RadioGroup1.ItemIndex];
      except end;
      if RadioGroup1.ItemIndex = 0 then
        TrackBar31.Position := LastPositionDMScale[0];
      bUserChange := True;
      TriggerRepaint;
    end;
  //  Label38.Visible := RadioGroup1.ItemIndex = 0;
 //   CheckBox18.Visible := RadioGroup1.ItemIndex = 1;
    case RadioGroup1.ItemIndex of
    0: begin  //its+otrap
         Label35.Caption := 'Offset X:';
         Label36.Caption := 'Offset Y:';
         Label41.Caption := 'Rotation:';
      //   Label42.Visible := True;
         TrackBar30.Visible := True;
         Label38.Visible := True;
         TrackBar31.Visible := True;  //Scale
       end;
    1: begin  //on normals
         Label35.Caption := 'Rotation X:';
         Label36.Caption := 'Rotation Y:';
         Label41.Caption := 'Rotation Z:';
         TrackBar30.Visible := True;
      //   Label42.Visible := False;
         Label38.Visible := False;
         TrackBar31.Visible := False;
       end;
 2, 3: begin  //wrap
         Label35.Caption := 'Offset X:';
         Label36.Caption := 'Offset Y:';
         Label41.Caption := '';
         TrackBar30.Visible := False;
     //    Label42.Visible := False;
         Label38.Visible := True;
         TrackBar31.Visible := True;
       end;
    end;
end;

procedure TLightAdjustForm.SpeedButton31Click(Sender: TObject);
var b: Boolean;
begin
    SpeedButton31.Tag := 1 - SpeedButton31.Tag;
    b := SpeedButton31.Tag = 0;
    SpeedButton20.Visible := b;
    SpeedButton21.Visible := b;
    SpeedButton22.Visible := b;
    SpeedButton23.Visible := b;
    SpeedButton24.Visible := b;
    SpeedButton25.Visible := b;
    SpeedButton26.Visible := b;
    SpeedButton27.Visible := b;
    SpeedButton28.Visible := b;
    SpeedButton29.Visible := b;
    SpeedButton31.Visible := b;
    SpeedButton32.Visible := not b;
    CheckBox11.Visible := b;
    if b then
    begin
      Panel3.Height := 3 * SpeedButton18.Height + SpeedButton13.Height + 11;
      ClientHeight := ClientHeight + 2 * SpeedButton18.Height;
    end
    else
    begin
      Panel3.Height := SpeedButton18.Height + SpeedButton13.Height + 11;
      ClientHeight := ClientHeight - 2 * SpeedButton18.Height;
    end;
    SpeedButton13.Top := Panel3.Height - SpeedButton13.Height - 5;
    SpeedButton14.Top := SpeedButton13.Top;
    ComboBox3.Top := SpeedButton13.Top + 4;
end;

procedure TLightAdjustForm.SpeedButton34Click(Sender: TObject);
var x, imin, imax, icount, n: Integer;
    dmin, dmul: Double;
    pia: PIntegerArray;
begin  // adjust color sliders to histogram
    imin := -1;
    imax := 32767;
    icount := 0;
    n := 0;
    if CheckBox2.Checked then pia := @OTColHisto else pia := @LColHisto;
    for x := 0 to 32767 do Inc(icount, pia[x]);
    icount := Max(1, icount div 2000);      //use 0.05 percent at both ends...
    for x := 0 to 32767 do if pia[x] > 0 then
    begin
      Inc(n, pia[x]);
      if n >= icount then
      begin
        imin := x;
        Break;
      end;
    end;
    n := 0;
    for x := 32767 downto 0 do if pia[x] > 0 then
    begin
      Inc(n, pia[x]);
      if n >= icount then
      begin
        imax := x;
        Break;
      end;
    end;
    if imin < 0 then Exit;
    if SBFineAdj.Down then
    begin
      dmin := Sqr((TBcolStartPos + 30) / 90) * 32767 - 10900;
      dmul := MaxCD(1e-4, (Sqr((TBcolStopPos + 30) / 90) * 32767 - 10900 - dmin) * s1d32767);
      TrackBar9.Position := Round(Min0MaxCD(((imin - dmin) / dmul + 16384) * 120 * d1d65535, 120)) - 30; //x3 := x * 65535 / (Width - 1)
      TrackBar10.Position := Round(Min0MaxCD(((imax - dmin) / dmul + 16384) * 120 * d1d65535, 120)) - 30;
    end
    else
    begin
      TrackBar9.Position := Round(Min0MaxCD(Sqrt((imin + 10900) * s1d32767) * 90, 120)) - 30;  // x3 := x * 4 / (3 * (Width - 1));
      TrackBar10.Position := Round(Min0MaxCD(Sqrt((imax + 10900) * s1d32767) * 90, 120)) - 30;
    end;
    if TrackBar10.Position = TrackBar9.Position then
    if TrackBar9.Position > 0 then TrackBar9.Position := TrackBar9.Position - 1
                              else TrackBar10.Position := TrackBar10.Position + 1;
end;
  {    if SBFineAdj.Down then
      begin        x3 := Round((x * 65535 / (Width - 1) - 16384) * dmul + dmin)
        x2   := Round(-16384 * dmul + dmin);
      end else begin    imin
        dmin := 0;     // x3 := Sqr(x * 4 / (3 * (Width - 1)))   * 32767 - 10900;
        dmul := 1;
        x2   := 0;
      end;
      for x := 0 to Width - 1 do
}

procedure TLightAdjustForm.FormActivate(Sender: TObject);
begin
    Invalidate;//Repaint;  //for wine, but does not really work
end;

procedure TLightAdjustForm.TabControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var mp: TPoint;
    i: Integer;
begin
    if Button = mbRight then
    begin
      GetCursorPos(mp);
      for i := 0 to 5 do PopupMenu1.Items[i].Enabled := i <> TabControl1.TabIndex;
      PopupMenu1.Popup(mp.X, mp.Y);
    end;
end;

procedure TLightAdjustForm.CopythislighttoLight11Click(Sender: TObject);
var SourceNr, DestNr, b: Integer;
    bRepaint: LongBool;
begin  //copy light to...
    DestNr := Min(5, Max(0, (Sender as TMenuItem).Tag));
    SourceNr := TabControl1.TabIndex;
    if DestNr <> SourceNr then
    begin
      bRepaint := (LAtmpLight.Lights[SourceNr].Loption and LAtmpLight.Lights[DestNr].Loption and 1) = 0;
      b := LAtmpLight.Lights[DestNr].AdditionalByteEx;
      LAtmpLight.Lights[DestNr] := LAtmpLight.Lights[SourceNr];
      LAtmpLight.Lights[DestNr].AdditionalByteEx := b;
      UpdateTabHeader(DestNr);
      if bRepaint then TriggerRepaint;
    end;
end;

procedure TLightAdjustForm.FormHide(Sender: TObject);
begin
    IniVal[27] := IntToStr(Left) + ' ' + IntToStr(Top);
end;

Initialization

  SetCosTabFunction;

end.
