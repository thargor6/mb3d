unit FormulaGUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, TypeDefinitions,
  ListBoxEx, Menus, SpeedButtonEx, Vcl.Samples.Spin, Vcl.Mask, JvExMask, JvSpin;

type
  TFormulaGUIForm = class(TForm)
    TabControl1: TTabControl;
    Panel1: TPanel;
    EditItCount: TEdit;
    LabelItCount: TLabel;
    RBailoutLabel: TLabel;
    RBailoutEdit: TEdit;
    SpeedButton11: TSpeedButton;
    OpenDialog3: TOpenDialog;
    CheckBox1: TCheckBox;
    TabControl2: TTabControl;
    RandomButton: TButton;
    MaxIterEdit: TEdit;
    MinIterEdit: TEdit;
    MaxIterLabel: TLabel;
    MinIterLabel: TLabel;
    Panel2: TPanel;
    Label22: TLabel;
    XWEdit: TEdit;
    XWLabel: TLabel;
    YWEdit: TEdit;
    YWLabel: TLabel;
    ZWEdit: TEdit;
    ZWLabel: TLabel;
    SpeedButton2: TSpeedButton;
    RichEdit1: TRichEdit;
    Button3: TButton;
    Button4: TButton;
    Timer4: TTimer;
    Timer5: TTimer;
    ListBoxEx1: TListBoxEx;
    ListBoxEx2: TListBoxEx;
    ListBoxEx3: TListBoxEx;
    ListBoxEx4: TListBoxEx;
    ListBoxEx5: TListBoxEx;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ListBoxEx6: TListBoxEx;
    SpeedButton3: TSpeedButton;
    CheckBox2: TCheckBox;
    ExchangeFormulaBtn: TSpeedButton;
    ListBoxEx7: TListBoxEx;
    ListBoxEx8: TListBoxEx;
    ListBoxEx9: TListBoxEx;
    PopupMenu1: TPopupMenu;
    Hidethisformula1: TMenuItem;
    Ratethisformulaasnormal1: TMenuItem;
    Ilikethisformula1: TMenuItem;
    voteformula1: TMenuItem;
    SpeedButton4: TSpeedButton;
    ListBoxEx15: TListBoxEx;
    ListBoxEx11: TListBoxEx;
    N1: TMenuItem;
    Deletethisformulapermanently1: TMenuItem;
    ComboBox1: TComboBox;
    MaxIterHybridsPartLabel: TLabel;
    MaxIterHybridPart2Edit: TEdit;
    PopupMenu2: TPopupMenu;
    Copythisformulatoformulanr11: TMenuItem;
    Copythisformulatoformula21: TMenuItem;
    Copythisformulatoformula31: TMenuItem;
    Copythisformulatoformula41: TMenuItem;
    Copythisformulatoformula51: TMenuItem;
    Copythisformulatoformula61: TMenuItem;
    N2: TMenuItem;
    Shiftallformulasonetotheright1: TMenuItem;
    Shifttotheleft1: TMenuItem;
    ListBoxEx10: TListBoxEx;
    SpeedButtonEx1: TSpeedButtonEx;
    SpeedButtonEx7: TSpeedButtonEx;
    SpeedButtonEx2: TSpeedButtonEx;
    SpeedButtonEx3: TSpeedButtonEx;
    SpeedButtonEx4: TSpeedButtonEx;
    SpeedButtonEx5: TSpeedButtonEx;
    SpeedButtonEx6: TSpeedButtonEx;
    SpeedButtonEx8: TSpeedButtonEx;
    SpeedButtonEx9: TSpeedButtonEx;
    SpeedButtonEx10: TSpeedButtonEx;
    ComboEdit1: TEdit;
    Timer1: TTimer;
    Copythevaluesto1: TMenuItem;
    N3: TMenuItem;
    ListBoxEx12: TListBoxEx;
    SpeedButtonEx11: TSpeedButtonEx;
    HybridStartBtn: TUpDown;
    Label28: TLabel;
    Panel3: TPanel;
    Label18: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Edit23: TEdit;
    DECombineCmb: TComboBox;
    Edit25: TEdit;
    ScrollBox1: TScrollBox;
    Panel4: TPanel;
    Edit1: TJvSpinEdit;
    Edit10: TJvSpinEdit;
    Edit11: TJvSpinEdit;
    Edit12: TJvSpinEdit;
    Edit13: TJvSpinEdit;
    Edit14: TJvSpinEdit;
    Edit15: TJvSpinEdit;
    Edit16: TJvSpinEdit;
    Edit2: TJvSpinEdit;
    Edit3: TJvSpinEdit;
    Edit4: TJvSpinEdit;
    Edit5: TJvSpinEdit;
    Edit6: TJvSpinEdit;
    Edit7: TJvSpinEdit;
    Edit8: TJvSpinEdit;
    Edit9: TJvSpinEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit17: TJvSpinEdit;
    Label17: TLabel;
    procedure TabControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure EditItCountChange(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ExchangeFormulaBtnClick(Sender: TObject);
    procedure TabControl2Change(Sender: TObject);
    procedure TabControl2Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure RandomButtonClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButtonEx1MouseEnter(Sender: TObject);
    procedure SpeedButtonEx1MouseLeave(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure ListBoxEx1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBoxEx1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxEx1MouseEnter(Sender: TObject);
    procedure ListBoxEx1MouseLeave(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton3Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Hidethisformula1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ListBoxEx15MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBoxEx9DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxEx11MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboEdit1Change(Sender: TObject);
    procedure ComboEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComboEdit1Exit(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure TabControl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Copythisformulatoformulanr11Click(Sender: TObject);
    procedure Shiftallformulasonetotheright1Click(Sender: TObject);
    procedure Shifttotheleft1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Copythevaluesto1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HybridStartBtnClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private-Deklarationen }
    OldTab2index: Integer;
    MaxLBheight: Integer;
    HighlightedFormula: String;
    procedure CalcRstop;
    procedure SetTabNames;
    function FNormalPos(Formula: THAformula): TPoint;
    procedure Check4DandInfo;
    procedure AdjustTC1height;
    procedure HideAllListBoxExPopupsButNot(const n: Integer);
    procedure SetListBoxWidth(LB: TListBoxEx);
    procedure AddFormulaName(FName: String; DEfunc: Integer);
    function FNameIsIncluded(Name: String): LongBool;
    procedure SelectFormula(FName: String);
    procedure ListboxPopup(var LB: TListBoxEx; const pos: TPoint);
    procedure MakeLB11list(text: String);
    function ListBoxIsFull(LB: TListBoxEx): LongBool;
    procedure RefreshPreview;
  public
    { Public-Deklarationen }
    bUserChange: LongBool;
    procedure SetFormulaCBs(s: String);
    procedure LoadFormulaNames;
    procedure UpdateFromHeader(Header: TPMandHeader11);
  end;

var
  FormulaGUIForm: TFormulaGUIForm;
  FGUIFormCreated: LongBool = False;
  FGUIFormFirstShow: LongBool = True;
  FGUIFormDropDownButtonCount: Integer = 10;
  InternFormulasDEfunc: array[0..6] of Integer = (0,0,4,0,11,0,0);
 { InternFormulaNames: array[0..6] of String = ('Integer Power','Real Power',
   'Quaternion','Tricorn','Amazing Box','Bulbox','Folding Int Pow');  }

implementation

uses Mand, CustomFormulas, DivUtils, Math, HeaderTrafos, FileHandling, formulas,
  PostProcessForm, Math3D;

{$R *.dfm}

procedure TFormulaGUIForm.UpdateFromHeader(Header: TPMandHeader11);
begin
    with Header^ do
    begin
      bUserChange := False;
      RBailoutEdit.Text := FloatToStr(RStop);
      TabControl2Change(Self);
      MaxIterEdit.Text := IntToStr(Iterations);
      MaxIterHybridPart2Edit.Text := IntToStr(iMaxItsF2);
      MinIterEdit.Text := IntToStr(MinimumIterations);
      XWEdit.Text := FloatToStr(dXWrot / Pid180);
      YWEdit.Text := FloatToStr(dYWrot / Pid180);
      ZWEdit.Text := FloatToStr(dZWrot / Pid180);
      CheckBox2.Checked := (PTHeaderCustomAddon(PCFAddon).bOptions2 and 1) > 0;
      ComboBox1.ItemIndex := (PTHeaderCustomAddon(PCFAddon).bOptions2 and 6) shr 1;
      DECombineCmb.ItemIndex := PTHeaderCustomAddon(PCFAddon).bOptions3 and 7;
      if DECombineCmb.ItemIndex < 5 then
        Edit23.Text := FloatToStrSingle(Min0MaxCS(sDEcombS, 100))
      else
      begin
        Edit23.Text := IntToStr(DEmixColorOption);
        Edit25.Text := FloatToStrSingle(sNotZero(MinMaxCS(-100, sFmixPow, 100)));
      end;
      bUserChange := True;
    end;
end;

procedure TFormulaGUIForm.HybridStartBtnClick(Sender: TObject; Button: TUDBtnType);
var i: Integer;
begin
    if bUserChange then
    begin
      i := Max(2, Min(6, HybridStartBtn.Position));
      if (Button = btNext) and (i < 6) then Inc(i) else
      if (Button = btPrev) and (i > 2) then Dec(i);
      Label28.Caption := IntToStr(i);
      Mand3DForm.Haddon.bHybOpt2 := (Mand3DForm.Haddon.bHybOpt2 and $70) or (i - 1);
      CheckHybridOptions(@Mand3DForm.Haddon);       // bHybOpt2:    Word;   //start2, end2, repeat2    3x 4bit
    end;
end;

procedure TFormulaGUIForm.MakeLB11list(text: String);
var i, j: Integer;
    LB: TListBoxEx;
begin
    text := UpperCase(Trim(text));
    ListBoxEx11.Clear;
    for j := 1 to FGUIFormDropDownButtonCount do
    begin
      LB := FindComponent('ListBoxEx' + IntToStr(j)) as TListBoxEx;
      if LB <> nil then
      begin
        for i := 0 to LB.Items.Count - 1 do
          if Pos(text, UpperCase(StrLastWords(LB.Items[i]))) > 0 then
            ListBoxEx11.Items.Add(LB.Items[i]);
      end;
    end;
end;

procedure TFormulaGUIForm.AdjustTC1height;
var i: Integer;
begin
    if Panel3.Visible then i := Panel3.Height else i := 0;
    if Panel2.Visible then i := i + Panel2.Height;
    FormulaGUIForm.ClientHeight := TabControl1.Height + TabControl2.Height + Panel1.Height + i;
end;

procedure TFormulaGUIForm.Check4DandInfo;         //check for 4d rotation visible
var p: TPoint;
begin
    Panel2.Visible := Is4Dtype(@Mand3DForm.MHeader);
    AdjustTC1height;
    SpeedButton2.Enabled := DescrOfFName(ComboEdit1.Text) > '';
    RichEdit1.Visible := False;
    Button3.Visible := False;
    p := FNormalPos(Mand3DForm.HAddon.Formulas[TabControl1.TabIndex]);
    Button4.Visible := p.X >= 0;
    if Button4.Visible then Button4.Top := p.Y;
end;

function TFormulaGUIForm.FNormalPos(Formula: THAformula): TPoint;
var i: Integer;
    L: TLabel;
begin
    Result := Point(-1, 0);
    i := 0;
    repeat
      if Formula.iOptionCount <= i then Break;
      L := (FindComponent('Label' + IntToStr(i + 1)) as TLabel);
      if Pos('NORMAL', UpperCase(L.Caption)) > 0 then
      begin
        Result.X := i;
        Result.Y := L.Top;
        Break;
      end;
      Inc(i);
    until i > 12;
end;

function TFormulaGUIForm.ListBoxIsFull(LB: TListBoxEx): LongBool;
begin
    Result := (LB.Items.Count + 1) * LB.ItemHeight >= MaxLBheight;
end;

procedure TFormulaGUIForm.AddFormulaName(FName: String; DEfunc: Integer);
var stat: Integer;
begin
  stat := GetFavouriteStatus(FName);
  if stat > -2 then
  begin
    FName := IntToStr(stat) + ' ' + FName;
    case DEfunc of
      2,11:  ListBoxEx2.Items.Add(FName); // 3Da
         4:  ListBoxEx3.Items.Add(FName); // 4D
       5,6:  ListBoxEx4.Items.Add(FName); // 4Da
     -1,-2:  if not ListBoxIsFull(ListBoxEx5) then ListBoxEx5.Items.Add(FName) else   // Ads
             if not ListBoxIsFull(ListBoxEx6) then ListBoxEx6.Items.Add(FName) else
               ListBoxEx8.Items.Add(FName);
        20:  if not ListBoxIsFull(ListBoxEx9) then ListBoxEx9.Items.Add(FName) else   // dIFS  shapes
               ListBoxEx10.Items.Add(FName);
    21..22:  ListBoxEx12.Items.Add(FName); // dIFS  trafos
      else  // 3D
        if not ListBoxIsFull(ListBoxEx1) then ListBoxEx1.Items.Add(FName) else
          ListBoxEx7.Items.Add(FName);
    end;
  end;
end;

function TFormulaGUIForm.FNameIsIncluded(Name: String): LongBool;
var i, l: Integer;
    LB: TListBoxEx;
begin
    Result := False;
    for l := 1 to FGUIFormDropDownButtonCount do
    begin
      LB := FindComponent('ListBoxEx' + IntToStr(l)) as TListBoxEx;
      if LB <> nil then
      begin
        for i := 0 to LB.Items.Count - 1 do
          if CompareText(Trim(Name), StrLastWords(LB.Items[i])) = 0 then Result := True;
      end;
      if Result then Break;
    end;
end;

procedure TFormulaGUIForm.LoadFormulaNames;
var sdir, s2, se, s3: String;
    i, df: Integer;
    sr: TSearchRec;
    b: LongBool;
    LBE: TListBoxEx;
begin
    for i := 1 to FGUIFormDropDownButtonCount do
    begin
      LBE := (FindComponent('ListBoxEx' + IntToStr(i)) as TListBoxEx);
      LBE.Clear;
      if i = 4 then LBE.Items.Add(' ');
    end;
    for i := 0 to 6 do AddFormulaName(InternFormulaNames[i], InternFormulasDEfunc[i]);
    AddFormulaName('Aexion C', 0);
    //TESTIFS disable if not wanted
 //   AddFormulaName('testIFS', testIFSDEoption);
    s2 := '';
    sdir := IncludeTrailingPathDelimiter(IniDirs[3]);
    if FindFirst(sdir + '*.m3f', 0, sr) = 0 then
    repeat
      se := ChangeFileExt(sr.Name, '');
      s3 := UpperCase(se);
      b := (s3 <> 'TRAFASSELQUAT') or not CanLoadF('CommQuat');
      b := b and ((s3 <> '_FLIPXY') or not CanLoadF('_FlipXYc'));
      b := b and ((s3 <> '_FLIPXZ') or not CanLoadF('_FlipXZc'));
      b := b and ((s3 <> '_FLIPYZ') or not CanLoadF('_FlipYZc'));
      b := b and ((s3 <> 'ABOXMODKALIFIXED') or not CanLoadF('ABoxModKali'));
      b := b and (s3 <> 'SQKOCH') and (s3 <> 'DJD-QUAT') and (s3 <> '_IFS-TESS');
      if b and CanLoadCustomFormula(sdir + sr.Name, df) and
        (not FNameIsIncluded(se)) then AddFormulaName(se, df);
    until FindNext(sr) <> 0;
    FindClose(sr);
    s2 := sdir;
    for i := 1 to FGUIFormDropDownButtonCount do
      SetListBoxWidth(FindComponent('ListBoxEx' + IntToStr(i)) as TListBoxEx);
    SetListBoxWidth(ListBoxEx12);
    Button3.Visible := False;
    RichEdit1.Visible := False;
end;

procedure TFormulaGUIForm.CalcRstop;
var i, j, n: Integer;
    d: Double;
begin
    d := 2;
    if TabControl2.TabIndex <> 1 then n := MAX_FORMULA_COUNT -1  else n := 1;
    for i := 0 to n do with Mand3DForm.HAddon.Formulas[i] do
    begin
      if n = MAX_FORMULA_COUNT -1 then j := Mand3DForm.HAddon.Formulas[i].iItCount
               else j := Ord(Mand3DForm.HAddon.Formulas[i].iFnr > -1);
      if j > 0 then
      begin
        if iFnr in [4, 5, 6] then d := 1024 else
        if iFnr = 7 then d := Max(d, testhybridRstop) else
        if iFnr > 19 then
          d := Max(d, PTCustomFormula(Mand3DForm.MHeader.PHCustomF[i]).dRstop)
        else
          d := Max(d, 16);
        if i = 0 then TabControl1.Tabs[0] := 'Formula1 •'
                 else TabControl1.Tabs[i] := 'Fo.' + IntToStr(i + 1) + ' •';
      end
      else if i = 0 then TabControl1.Tabs[0] := 'Formula1'
                    else TabControl1.Tabs[i] := 'Fo.' + IntToStr(i + 1);
    end;
    RBailoutEdit.Text := FloatToStr(d);
end;

procedure TFormulaGUIForm.SetFormulaCBs(s: String);
var b: LongBool;
begin
    b := bUserChange;
    bUserChange := False;
    ComboEdit1.Text := Trim(s);
    bUserChange := b;
    RefreshPreview;
end;

procedure TFormulaGUIForm.SetTabNames;
var i, t, n, ti: Integer;
    ne: TNotifyEvent;
begin
    ne := TabControl1.OnChange;
    try
    TabControl1.OnChange := nil;
    if (Mand3DForm.HAddon.bOptions1 and 3) = 1 then n := 1 else n := MAX_FORMULA_COUNT - 1 ;
    if TabControl1.Tabs.Count <> n + 1 then
    begin
      ti := TabControl1.TabIndex;
      TabControl1.Tabs.Clear;
      for t := 0 to n do
      begin
        if n = MAX_FORMULA_COUNT - 1 then i := Mand3DForm.HAddon.Formulas[t].iItCount
                 else i := Ord(Mand3DForm.HAddon.Formulas[t].CustomFName[0] > 0);
        if t = 0 then
        begin
          if i < 1 then TabControl1.Tabs.Add('Formula1')
                   else TabControl1.Tabs.Add('Formula1 •');
        end
        else if i < 1 then TabControl1.Tabs.Add('Fo.' + IntToStr(t + 1))
                      else TabControl1.Tabs.Add('Fo.' + IntToStr(t + 1) + ' •');
      end;
      TabControl1.TabIndex := Min(n, ti);
    end else begin
      for t := 0 to n do
      begin
        if n = MAX_FORMULA_COUNT -1 then i := Mand3DForm.HAddon.Formulas[t].iItCount
                 else i := Ord(Mand3DForm.HAddon.Formulas[t].CustomFName[0] > 0);
        if t = 0 then
        begin
          if i < 1 then TabControl1.Tabs[t] := 'Formula1'
                   else TabControl1.Tabs[t] := 'Formula1 •';
        end
        else if i < 1 then TabControl1.Tabs[t] := 'Fo.' + IntToStr(t + 1)
                      else TabControl1.Tabs[t] := 'Fo.' + IntToStr(t + 1) + ' •';
      end;
    end;
    if n = MAX_FORMULA_COUNT -1 then LabelItCount.Caption := 'Iterationcount:' else LabelItCount.Caption := 'Weight:';
    CheckBox1.Visible := n = MAX_FORMULA_COUNT - 1;
    finally
      TabControl1.OnChange := ne;
    end;
end;

procedure TFormulaGUIForm.TabControl1Change(Sender: TObject);
var i, t: Integer;
    E: TJvSpinEdit;
    L: TLabel;
    bAltHybrid: LongBool;
begin
    SetTabNames;
    bAltHybrid := LabelItCount.Caption = 'Iterationcount:';
    t := TabControl1.TabIndex;
    ExchangeFormulaBtn.Enabled := (t = 0) or (bAltHybrid and (t < MAX_FORMULA_COUNT - 1));
    with Mand3DForm.HAddon.Formulas[t] do
    begin
      bUserChange := False;
      if bAltHybrid then
      begin
        if iItCount < 0 then iItCount := 0;
        EditItCount.Text := IntToStr(iItCount);
      end
      else EditItCount.Text := FloatToStrSingle(PSingle(@iItCount)^);
      SetFormulaCBs(Trim(CustomFtoStr(CustomFname)));
      for i := 0 to 15 do
      begin
        E := (FindComponent('Edit' + IntToStr(i + 1)) as TJvSpinEdit);
        E.Visible := iOptionCount > i;
        L := (FindComponent('Label' + IntToStr(i + 1)) as TLabel);
        L.Visible := iOptionCount > i;
        if iOptionCount > i then
        begin
          E.Text := FloatToStr(dOptionValue[i]);
          L.Caption := PTCustomFormula(Mand3DForm.MHeader.PHCustomF[t]).sOptionStrings[i];
        end;
      end;
      Panel3.Visible := TabControl2.TabIndex = 2;
      Check4DandInfo;
      if TabControl2.TabIndex = 2 then
        CheckBox1.Checked := t in [Mand3DForm.HAddon.bHybOpt1 shr 4, Mand3DForm.HAddon.bHybOpt2 shr 8]
      else CheckBox1.Checked := t = (Mand3DForm.HAddon.bHybOpt1 shr 4);
      RichEdit1.Visible := False;
      Button3.Visible := False;
      RadioGroup1Click(Sender);
      bUserChange := True;
    end;
end;

procedure TFormulaGUIForm.FormShow(Sender: TObject);
begin
    if Testing then Showmessage('M3D formulaform show...');
    if not FGUIFormCreated then OpenDialog3.InitialDir := IniDirs[3];
    OldTab2index := 0;
    bUserChange := True;
    TabControl1Change(Sender);
//    FGUIFormCreated := True;
    if FGUIFormFirstShow then
    begin
      FGUIFormFirstShow := False;
      if FormsSticky[0] = 0 then
        SetBounds(StrToIntTry(StrFirstWord(IniVal[26]), 844),
                  StrToIntTry(StrLastWord(IniVal[26]), 100), Width, Height);
      if SupportSSE2 then
      begin
        Bevel1.Width := Bevel1.Width + SpeedButtonEx9.Width * 3;
        SpeedButtonEx9.Visible := True;
        SpeedButtonEx10.Visible := True;
        SpeedButtonEx11.Visible := True;
      //  FGUIFormDropDownButtonCount := 10;
      end;
      MaxLBheight := TabControl1.Height - SpeedButtonEx1.Top - SpeedButtonEx1.Height - 4;
      LoadFormulaNames;
    end;
    if Testing then Showmessage('M3D formulaform show done');
end;

procedure TFormulaGUIForm.SpeedButton11Click(Sender: TObject);  //load a new formula file
begin
    if OpenDialog3.Execute then
      if LoadCustomFormula(OpenDialog3.FileName,
        PTCustomFormula(Mand3DForm.MHeader.PHCustomF[TabControl1.TabIndex])^,
        Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].CustomFname,
        Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].dOptionValue, True, 0) then
      begin
        if not AnsiSameText(IncludeTrailingPathDelimiter(IniDirs[3]),
           IncludeTrailingPathDelimiter(ExtractFileDir(OpenDialog3.FileName))) then
          CopyFile(PChar(OpenDialog3.FileName) , PChar(IncludeTrailingPathDelimiter(IniDirs[3]) +
            ExtractFileName(OpenDialog3.FileName)), True);
        CopyTypeAndOptionFromCFtoHAddon(Mand3DForm.MHeader.PHCustomF[TabControl1.TabIndex],
          @Mand3DForm.HAddon, TabControl1.TabIndex);
        if Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount < 1 then
          Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount := 1;
        LoadFormulaNames;
        SetFormulaCBs(CustomFtoStr(Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].CustomFname));
        Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iFnr := 20;
        TabControl1Change(Sender);
        CalcRstop;
      end;
end;

procedure TFormulaGUIForm.EditItCountChange(Sender: TObject);
begin
    if bUserChange then
    begin
      if TabControl2.TabIndex <> 1 then
        TryStrToInt(Trim(EditItCount.Text), Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount)
      else
        TryStrToFloat(Trim(EditItCount.Text), PSingle(@Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount)^);
      CalcRstop;
    end; 
end;

procedure TFormulaGUIForm.Edit1Change(Sender: TObject);
begin
    if bUserChange then
    begin
      if not StrToFloatKtry((Sender as TJvSpinEdit).Text,
        Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].dOptionValue[(Sender as TJvSpinEdit).Tag]) then
        (Sender as TJvSpinEdit).Font.Color := clMaroon
      else begin
        (Sender as TJvSpinEdit).Font.Color := clWindowText;
        RefreshPreview;
      end;
    end
    else (Sender as TJvSpinEdit).Font.Color := clWindowText;
end;

procedure TFormulaGUIForm.CheckBox1Click(Sender: TObject);
var i: Integer;
begin
    if bUserChange then
    begin
      if CheckBox1.Checked then i := TabControl1.TabIndex else i := 0;
      if (TabControl2.TabIndex = 2) and (TabControl1.TabIndex + 1 >= HybridStartBtn.Position) then
      begin
        if i = 0 then i := HybridStartBtn.Position - 1;
        Mand3DForm.HAddon.bHybOpt2 := (Mand3DForm.HAddon.bHybOpt2 and $77) or (i shl 8);
      end
      else Mand3DForm.HAddon.bHybOpt1 := (Mand3DForm.HAddon.bHybOpt1 and $7) or (i shl 4);  //end1, repeat1            2x 4bit
    end;
end;

procedure TFormulaGUIForm.ExchangeFormulaBtnClick(Sender: TObject);   //exchange with next F
var t, i: Integer;
    HAF: THAformula;
    dOptionValues: array[0..15] of Double;
begin
    t := TabControl1.TabIndex;
    if t < MAX_FORMULA_COUNT -1  then
    begin
      HAF := Mand3DForm.HAddon.Formulas[t];
      Mand3DForm.HAddon.Formulas[t] := Mand3DForm.HAddon.Formulas[t + 1];
      Mand3DForm.HAddon.Formulas[t + 1] := HAF;
      for i := t to t + 1 do
      begin
        if Mand3DForm.HAddon.Formulas[i].iFnr < 20 then
          ParseCFfromOld(Mand3DForm.HAddon.Formulas[i].iFnr, Mand3DForm.MHeader.PHCustomF[i], dOptionValues)
        else
          LoadCustomFormulaFromHeader(Mand3DForm.HAddon.Formulas[i].CustomFname,
              PTCustomFormula(Mand3DForm.MHeader.PHCustomF[i])^, dOptionValues);
      end;
      TabControl1Change(Sender);
    end;
end;

procedure TFormulaGUIForm.TabControl2Change(Sender: TObject);
var i: Integer;
begin
    if not bUserChange then //  bOptions1:   Byte;   //type of hybrid: 0:alt  1:interpolhybrid  2:DEcombinated  3: (K/L?)IFS
      TabControl2.TabIndex := Mand3DForm.HAddon.bOptions1 and 3
    else
    begin
      Mand3DForm.HAddon.bOptions1 := TabControl2.TabIndex;
      CheckHybridOptions(@Mand3DForm.HAddon);
  //    if TabControl2.TabIndex = 2 then
    //    Mand3DForm.HAddon.bHybOpt2 := (Mand3DForm.HAddon.bHybOpt2 and $707) or $50;//bHybOpt2: start2, end2, repeat2    3x 4bit
    end;
    if TabControl2.TabIndex = 2 then MaxIterLabel.Caption := 'Maxits hybrid part1:'
                                else MaxIterLabel.Caption := 'Max. iterations:';

    Label28.Visible := TabControl2.TabIndex = 2;    //show/hide start of 2nd hybrid
    HybridStartBtn.Visible := Label28.Visible;
    HybridStartBtn.Position := Max(1, Mand3DForm.HAddon.bHybOpt2 and 7) + 1;
    Label28.Caption := IntToStr(HybridStartBtn.Position);
 //   if UpDown1.Visible then CheckHybridOptions(@Mand3DForm.Haddon);

    if TabControl2.TabIndex <> 1 then  //Alt hybrid, DEcomb
    begin
      if bUserChange then
      begin
        if OldTab2index = 1 then for i := 0 to 1 do  //put integer counts in, were single vals
        begin
          if Mand3DForm.HAddon.Formulas[i].CustomFName[0] = 0 then Mand3DForm.HAddon.Formulas[i].iItCount := 0 else
          Mand3DForm.HAddon.Formulas[i].iItCount := Round(MinMaxCS(0, PSingle(@Mand3DForm.HAddon.Formulas[i].iItCount)^, 100));
        end;
      end
      else DECombineCmb.ItemIndex := Mand3DForm.HAddon.bOptions3 and 7;
    end
    else  // Interpol hybrid
    begin                    
      if bUserChange then
      if OldTab2index <> 1 then for i := 0 to 1 do
        PSingle(@Mand3DForm.HAddon.Formulas[i].iItCount)^ := Max(1, Mand3DForm.HAddon.Formulas[i].iItCount);
    end;
    OldTab2index := TabControl2.TabIndex;
    SetTabNames;
    TabControl1Change(Sender);
    MaxIterHybridsPartLabel.Visible := TabControl2.TabIndex = 2;
    MaxIterHybridPart2Edit.Visible := MaxIterHybridsPartLabel.Visible;
    AdjustTC1height;
end;

procedure TFormulaGUIForm.TabControl2Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
    OldTab2index := TabControl2.TabIndex;
end;

procedure TFormulaGUIForm.RandomButtonClick(Sender: TObject);
var i, j, t: Integer;
    LB: TListBoxEx;
    ca: array[1..9] of Integer;
    s: String;
    d: Double;
begin
    with Mand3DForm.HAddOn do
    begin
      TabControl2.TabIndex := 0;
      bOptions1 := 0;
      iFCount := Random(5) + 1;
      for i := 0 to MAX_FORMULA_COUNT - 1 do
      begin
        TabControl1.TabIndex := i;
        if i >= iFCount then Formulas[i].iItCount := 0 else
        begin
          Formulas[i].iItCount := Random(10) + 1;
          t := 0;
          for j := 1 to FGUIFormDropDownButtonCount - 1 do
          begin
            LB := FindComponent('ListBoxEx' + IntToStr(j)) as TListBoxEx;
            ca[j] := LB.Items.Count - 1;
            t := t + ca[j];
          end;
          t := Random(t);
          j := 1;
          while (j < FGUIFormDropDownButtonCount) and (t >= ca[j]) do
          begin
            Dec(t, ca[j]);
            Inc(j);
          end;
          LB := FindComponent('ListBoxEx' + IntToStr(j)) as TListBoxEx;
          j := Max(1, Min(LB.Items.Count - 1, t + 1));
          if Pos('CondItcount', LB.Items[j]) > 0 then
            Formulas[i].iItCount := 0
          else
          begin
            SelectFormula(StrLastWords(LB.Items[j]));

            for j := 0 to Formulas[i].iOptionCount - 1 do
            begin
              s := Uppercase(PTCustomFormula(Mand3DForm.MHeader.PHCustomF[i])^.sOptionStrings[j]);
              if Pos('SCALE', s) > 0 then begin d := Random - 0.5; if d < 0 then d := -1 - Sqr(d) * 15 else d := 1 + Sqr(d) * 15; end else
              if Pos(' MUL', s) > 0 then d := (Random - 0.5) * 20 else
              d := Random * 20;
              Formulas[i].dOptionValue[j] := d;
            end;
          end;
        end;
      end;
      TabControl1.TabIndex := 0;
      TabControl1.OnChange(Self);
      Mand3DForm.Button2.OnClick(Self);  //start calc3d
    end;
end;

procedure TFormulaGUIForm.Button3Click(Sender: TObject);
begin
    Button3.Visible := False;
    RichEdit1.Visible := False;
    ListBoxEx15.Visible := False;
end;

procedure TFormulaGUIForm.SpeedButton2Click(Sender: TObject);
begin
    if ListBoxEx15.Visible then ListBoxEx15.Visible := False;
    if RichEdit1.Visible then
    begin
      Button3.Visible := False;
      RichEdit1.Visible := False;
    end else begin
      RichEdit1.Text := DescrOfFName(ComboEdit1.Text);
      Button3.Visible := True;
      RichEdit1.Visible := True;
    end;
end;

procedure TFormulaGUIForm.Button4Click(Sender: TObject);
var i, n, t: Integer;
    d: Double;
begin
    t := TabControl1.TabIndex;
    with Mand3DForm.HAddon do
    begin
      i := FNormalPos(Formulas[t]).X;
      d := Sqrt(Sqr(Formulas[t].dOptionValue[i]) +
                Sqr(Formulas[t].dOptionValue[i + 1]) +
                Sqr(Formulas[t].dOptionValue[i + 2]));
      if d > 0 then d := 1 / d;
      for n := 0 to 2 do
        Formulas[t].dOptionValue[i + n] := Formulas[t].dOptionValue[i + n] * d;
    end;
    TabControl1Change(Sender);
end;

procedure TFormulaGUIForm.SpeedButtonEx1MouseEnter(Sender: TObject);
var SBrx: TSpeedButtonEx;
    MPos: TPoint;
begin
    Timer5.Enabled := False;
    SBrx := Sender as TSpeedButtonEx;
    GetCursorPos(MPos);
    Timer5.Tag := (MPos.Y shl 20) or (SBrx.Tag shl 16) or (GetTickCount and $FFFF);
    Timer5.Interval := 20;
    Timer5.Enabled := True;
end;

function ScreenPosInListBox(const LB: TListBoxEx; const sp: TPoint): Boolean;
var sap: TPoint;
begin
    sap := LB.ClientToScreen(Point(0, 0));
    Result := (sp.X >= sap.X) and (sp.Y >= sap.Y - 2) and (sp.X < sap.X + LB.Width)
                              and (sp.Y < sap.Y + LB.Height);
end;

function ScreenPosInSButton(const SB: TSpeedButtonEx; const sp: TPoint): Boolean;
var sap: TPoint;
begin
    sap := SB.ClientToScreen(Point(0, 0));
    Result := (sp.X >= sap.X) and (sp.Y >= sap.Y - 2) and (sp.X < sap.X + SB.Width)
                              and (sp.Y < sap.Y + SB.Height);
end;

procedure TFormulaGUIForm.SpeedButtonEx1MouseLeave(Sender: TObject);
var mpos: TPoint;
    SB: TSpeedButtonEx;
    LB: TListBoxEx;
begin
    Timer5.Enabled := False;
    GetCursorPos(mpos);
    SB := Sender as TSpeedButtonEx;
    SB.Down := False;
   // SB.Flat := True;  //test
    LB := FindComponent('ListBoxEx' + IntToStr(SB.Tag)) as TListBoxEx;
    if (LB <> nil) and not ScreenPosInListBox(LB, mpos) then
    begin
      LB.Visible := False;
      LB.Enabled := False;
      Timer1.Enabled := False;
    end;
end;

procedure TFormulaGUIForm.HideAllListBoxExPopupsButNot(const n: Integer);
var i: integer;
    LBE: TListBoxEx;
    SB: TSpeedButtonEx;
begin
    for i := 1 to FGUIFormDropDownButtonCount do if i <> n then
    begin
      LBE := FindComponent('ListBoxEx' + IntToStr(i)) as TListBoxEx;
      if (LBE <> nil) and LBE.Visible then
      begin
        LBE.Visible := False;
        LBE.Enabled := False;
        SB := FindComponent('SpeedButtonEx' + IntToStr(i)) as TSpeedButtonEx;
        if (SB <> nil) and SB.Down then SB.Down := False;
      end;
    end;
    if ListBoxEx12.Visible and (n < 11) then
    begin
      ListBoxEx12.Visible := False;
      ListBoxEx12.Enabled := False;
      if SpeedButtonEx11.Down then SpeedButtonEx11.Down := False;
    end;
end;

procedure TFormulaGUIForm.Timer1Timer(Sender: TObject);
var mpos: TPoint;
    i, c: Integer;
    LBE: TListBoxEx;
    SB: TSpeedButtonEx;
begin
    GetCursorPos(mpos);
    c := 0;
    Timer1.Enabled := False;
    for i := 1 to FGUIFormDropDownButtonCount do
    begin
      LBE := FindComponent('ListBoxEx' + IntToStr(i)) as TListBoxEx;
      if (LBE = nil) or not LBE.Visible then Continue;
      Inc(c);
      if not ScreenPosInListBox(LBE, mpos) then
      begin
        SB := FindComponent('SpeedButtonEx' + IntToStr(i)) as TSpeedButtonEx;
        if (SB <> nil) and ScreenPosInSButton(SB, mpos) then Continue;
        Timer1.Tag := Timer1.Tag - 1;
        if Timer1.Tag <= 0 then
        begin
          Timer1.Tag := 5;
          LBE.Visible := False;
          LBE.Enabled := False;
          if (SB <> nil) and SB.Down then SB.Down := False;
          Break;
        end;
      end
      else Timer1.Tag := 5;
    end;
    if c > 0 then Timer1.Enabled := True;
end;

procedure TFormulaGUIForm.Timer4Timer(Sender: TObject);
begin
    HideAllListBoxExPopupsButNot(0);
    Timer4.Enabled := False;
end;

procedure TFormulaGUIForm.SetListBoxWidth(LB: TListBoxEx);
var i, l: Integer;
begin
    for l := 0 to LB.Items.Count - 1 do
      if LB.Items[l][1] <> ' ' then LB.Items[l] := '    ' + LB.Items[l];
    l := SpeedButtonEx1.Top + SpeedButtonEx1.Height;
    if LB.Tag = 11 then l := ComboEdit1.Top + ComboEdit1.Height;
    LB.Height := Min(LB.Items.Count * LB.ItemHeight + 4, TabControl1.Height - l);
    LB.Font.Size := 7;
    LB.Canvas.Font := LB.Font;
    LB.Repaint;
    i := 0;
    for l := 0 to LB.Items.Count - 1 do
      i := Max(i, LB.Canvas.TextWidth(LB.Items[l]));
    if LB.Width <> i + 28 then LB.Width := i + 28;
end;

procedure TFormulaGUIForm.ListboxPopup(var LB: TListBoxEx; const pos: TPoint);
var l: Integer;
begin
    if not LB.Visible then
    begin
      LB.Left := Min(pos.X, TabControl1.Width - LB.Width);
      LB.Top := pos.Y;
      LB.Enabled := True;
      LB.Visible := True;
      for l := 0 to LB.Items.Count - 1 do LB.Selected[l] := False;
      Timer1.Tag := 5;
      Timer1.Enabled := True;
    end;
end;

procedure TFormulaGUIForm.Timer5Timer(Sender: TObject);  //enabled if sbutton entered
var Zeitdif, MPYdif, t, t2: Integer;
    MPos: Tpoint;
    SB: TSpeedButtonEx;
    LB:   TListBoxEx;
begin
    Timer5.Interval := 100;
    Zeitdif := (GetTickCount and $FFFF) - (Timer5.Tag and $FFFF) + 1;
    if Zeitdif < 1 then Inc(Zeitdif, $FFFF);
    GetCursorPos(MPos);
    MPYdif := (Timer5.Tag shr 20) - MPos.Y;
    if abs(MPYdif * 16) div Zeitdif < 1 then   //? horizontal movements to another button popups new listbox fast
    begin
      Timer5.Enabled := False;
      t := (Timer5.Tag shr 16) and $F;
      if t = 12 then t2 := 11 else t2 := t;
      SB := FindComponent('SpeedButtonEx' + IntToStr(t2)) as TSpeedButtonEx;
      if (SB = nil) or not SB.Enabled then Exit;
      LB := FindComponent('ListBoxEx' + IntToStr(t)) as TListBoxEx;
      if ScreenPosInSButton(SB, MPos) then //new check if mouse on button
      begin
        Timer4.Enabled := False;
        HideAllListBoxExPopupsButNot(t);
        if LB <> nil then ListboxPopup(LB, Point(SB.Left - 2, SB.Top + SB.Height));
        SB.Down := True;
      end
      else if (LB <> nil) and (not LB.Visible) then SB.Down := False;
    end;
end;

procedure ClearFormula(nr: Integer);
begin
    with Mand3DForm.HAddon.Formulas[nr] do
    begin
      iFnr := -1;
      CustomFname[0] := 0;
      iItCount := 0;
      iOptionCount := 0;
    end;
end;

procedure TFormulaGUIForm.SelectFormula(FName: String);
var i: Integer;
    s: String;
    success: LongBool;
begin
    if ListBoxEx15.Visible then ListBoxEx15.Visible := False;
    s := Trim(FName);
    success := False;
    if s <> '' then
    begin
      if isInternFormula(s, i) then
      begin
        GetHAddOnFromInternFormula(@Mand3DForm.MHeader, i, TabControl1.TabIndex);
        success := True;
      end else begin
        PutStringInCustomF(Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].CustomFname, s);
        if LoadCustomFormulaFromHeader(Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].CustomFname,
           PTCustomFormula(Mand3DForm.MHeader.PHCustomF[TabControl1.TabIndex])^,    //could be in use by calc thread!
           Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].dOptionValue) then
        begin
          if TabControl2.TabIndex <> 1 then
            if Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount < 1 then
              Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount := 1;
          CopyTypeAndOptionFromCFtoHAddon(Mand3DForm.MHeader.PHCustomF[TabControl1.TabIndex],
            @Mand3DForm.HAddon, TabControl1.TabIndex);
          success := True;
          Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iFnr := 20;    //for backward compatibilty reason
        end;
      end;
    end;
    if not success then  //deselect formula
    begin
      ClearFormula(TabControl1.TabIndex);
      TabControl1Change(Self);
      Check4DandInfo;
    end else begin
      if TabControl2.TabIndex <> 1 then
      if Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount < 1 then
        Mand3DForm.HAddon.Formulas[TabControl1.TabIndex].iItCount := 1;
      TabControl1Change(Self);
      CalcRstop;
      Check4DandInfo;
    end;
end;

procedure TFormulaGUIForm.ListBoxEx1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i: Integer;
    LB: TListBoxEx;
    p: TPoint;
begin
    if Button = mbLeft then
    begin
      LB := Sender as TListBoxEx;
      i := LB.ItemIndex;
      if i >= 0 then SelectFormula(StrLastWords(LB.Items[i]));
      LB.Enabled := False;
      LB.Visible := False;
      SetFocus;
      if LB.Tag <> 11 then
        (FindComponent('SpeedButtonEx' + IntToStr(LB.Tag)) as TSpeedButtonEx).Down := False;
      Timer1.Enabled := False;
    end
    else if Button = mbRight then
    begin
      LB := Sender as TListBoxEx;
      i := LB.ItemIndex;
      if i >= 0 then
      begin
        HighlightedFormula := StrLastWords(LB.Items[i]);
        if HighlightedFormula > '' then
        begin
          Hidethisformula1.Visible := True;
          p := LB.ClientToScreen(Point(X, Y));
          PopupMenu1.Popup(p.X + 3, p.Y);
        end;
      end;
    end;
end;

procedure TFormulaGUIForm.ListBoxEx1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var mpos, rp: TPoint;
    i: Integer;
    LB: TListBoxEx;
begin
    GetCursorPos(mpos);
    LB := Sender as TListBoxEx;
    rp := LB.ScreenToClient(mpos);
    if (rp.X >= 0) and (rp.X < LB.Width) and
       (rp.Y >= 0) and (rp.Y < LB.Height) then
    begin
      i := LB.ItemAtPos(rp, True);
      if (i >= 0) and not LB.Selected[i] then LB.Selected[i] := True;
    end;
end;

procedure TFormulaGUIForm.ListBoxEx1MouseEnter(Sender: TObject);
begin
    Timer4.Enabled := False;
    HideAllListBoxExPopupsButNot((Sender as TListBoxEx).Tag);
end;

procedure TFormulaGUIForm.ListBoxEx1MouseLeave(Sender: TObject); //leave triggers in XE2 also if on vertical scrollbar!
var mpos: TPoint;
    LB: TListBoxEx;
    SB: TSpeedButtonEx;
begin
    GetCursorPos(mpos);
    LB := Sender as TListBoxEx;
    SB := FindComponent('SpeedbuttonEx' + IntToStr(LB.Tag)) as TSpeedButtonEx;
    if (SB <> nil) and (not ScreenPosInSButton(SB, mpos)) and not ScreenPosInListBox(LB, mpos) //new, check if on box included scrollbar
      then Timer4.Enabled := True;
end;

procedure TFormulaGUIForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = 't') and ListBoxEx1.Visible then
    begin
      ListBoxEx1.Items.Add('test');
      RandomButton.Visible := True;
      SetListBoxWidth(ListBoxEx1);
      SpeedButtonEx9.Visible := True;
      AddFormulaName('testIFS', testIFSDEoption);
      Copythevaluesto1.Visible := True;
    end;
end;

procedure TFormulaGUIForm.SpeedButton3Click(Sender: TObject);   //Reset formulas
begin   
    ResetFormulas(@Mand3DForm.HAddon);
  //  Mand3DForm.MHeader.byRepeatFrom := 0;
    Mand3DForm.MHeader.MinimumIterations := 1;  //not displayed...
    Mand3DForm.MHeader.Iterations := 60;
    Mand3DForm.MHeader.RStop := 16;
    TabControl1.TabIndex := 0;
    SelectFormula('Integer Power');
    TabControl2.TabIndex := 0;
    Mand3DForm.HAddon.Formulas[0].iItCount := 1;
    Mand3DForm.HAddon.bOptions1 := 0;
    Mand3DForm.HAddon.bHybOpt1 := 0;     //end1, repeat1            2x 4bit
    Mand3DForm.HAddon.bHybOpt2 := $151;  //start2, end2, repeat2    3x 4bit
    TabControl1.OnChange(Self);
    UpdateFromHeader(@Mand3DForm.MHeader);
end;

procedure TFormulaGUIForm.RadioGroup1Click(Sender: TObject);
begin
    if bUserChange then Mand3DForm.HAddon.bOptions3 := DECombineCmb.ItemIndex;
    Label18.Visible := DECombineCmb.ItemIndex > 2;
    Edit23.Visible := Label18.Visible;
    Edit25.Visible := DECombineCmb.ItemIndex > 4;
    Label27.Visible := Edit25.Visible;
    if Edit23.Visible then if not Edit25.Visible then
    begin
      Label18.Caption := 'Ds:';
      Edit23.Text := FloatToStrSingle(Min0MaxCS(Mand3DForm.MHeader.sDEcombS, 100));
      Edit23.Hint := 'Absolute distance of the smooth combine functions,' + #13#10 +
                     'you can use scientific notation like 3e-5 for small values.' + #13#10 +
                     'Try 1/zoom to get close to a working value.';
    end else begin
      Label18.Caption := 'Co:';
      Edit23.Hint := 'Color Option:' + #13#10 +
                     '0:  Average of both formulas.' + #13#10 +
                     '1:  Color of first formula.' + #13#10 +
                     '2:  Color of second formula.';
      Edit23.Text := IntToStr(Mand3DForm.MHeader.DEmixColorOption); //0..2
    end;
end;

procedure TFormulaGUIForm.Hidethisformula1Click(Sender: TObject);
begin //set formula status
    StoreFavouriteStatus(HighlightedFormula, (Sender as TMenuItem).Tag);
    LoadFormulaNames;
    if ListBoxEx15.Visible then SpeedButton4Click(Sender);
end;

procedure TFormulaGUIForm.SpeedButton4Click(Sender: TObject);
var i, v: Integer;
begin
    if ListBoxEx15.Visible then
    begin
      ListBoxEx15.Visible := False;
      Button3.Visible := False;
    end
    else
    begin
      ListBoxEx15.Clear;
      try
        ListBoxEx15.Items.LoadFromFile(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt');
      except
        ListBoxEx15.Clear;
      end;
      i := 0;
      while i < ListBoxEx15.Items.Count do
      begin
        if (not TryStrToInt(StrFirstWord(ListBoxEx15.Items[i]), v)) or (v > -2) then
        begin
          ListBoxEx15.Selected[i] := True;
          ListBoxEx15.DeleteSelected;
        end
        else
        begin
          ListBoxEx15.Items[i] := StrLastWords(ListBoxEx15.Items[i]);
          Inc(i);
        end;
      end;
      ListBoxEx15.Visible := True;
      Button3.Visible := True;
    end;
end;

procedure TFormulaGUIForm.ListBoxEx15MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
    if Button = mbRight then
    begin
      if ListBoxEx15.ItemIndex >= 0 then
      begin
        HighlightedFormula := Trim(ListBoxEx15.Items[ListBoxEx15.ItemIndex]);
        if HighlightedFormula > '' then
        begin
          Hidethisformula1.Visible := False;
          p := ListBoxEx15.ClientToScreen(Point(X, Y));
          PopupMenu1.Popup(p.X + 3, p.Y);
        end;
      end;
    end;
end;

procedure TFormulaGUIForm.ListBoxEx9DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);  //odSelected
var i: Integer;
    sv: TSVec;
begin
    //paint background on formula status, +vote: green, -vote: red
    with (Control as TListBox).Canvas do  { draw on control canvas, not on the form }
    begin
      if odSelected in State then
        sv := ColToSVecNoScale(ColorToRGB(clHighLight))
      else
        sv := ColToSVecNoScale(ColorToRGB(clWindow));
      if not TryStrToInt(StrFirstWord((Control as TListBox).Items[Index]), i) then i := 1;
      if i <> 1 then
      begin
        if LengthOfSVec(sv) > 127 then
        begin
          if i > 1 then
          begin
            sv[1] := sv[1] - 25;
            sv[2] := sv[2] - 25;
          end else begin
            sv[0] := sv[0] - 25;
            sv[2] := sv[2] - 25;
          end;
        end else begin
          if i > 1 then
            sv[0] := sv[0] + 30
          else
            sv[1] := sv[1] + 30;
        end;
      end;
      Brush.Color := SVecToColNoScale(sv);
      FillRect(Rect);       { clear the rectangle }
      TextOut(Rect.Left + 10, Rect.Top, StrLastWords((Control as TListBox).Items[Index]));  { display the text }
    end;
end;

procedure TFormulaGUIForm.ListBoxEx11MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
      ListBoxEx1MouseDown(Sender, Button, Shift, X, Y);
      ListBoxEx11.Visible := False;
    end;
end;

procedure TFormulaGUIForm.ComboEdit1Change(Sender: TObject);
begin
    if bUserChange then      //update lbex11 for all possible formulanames, including text
    begin
      if Trim(ComboEdit1.Text) > '' then
      begin
        MakeLB11list(ComboEdit1.Text);
        if ListBoxEx11.Items.Count > 0 then
        begin
          SetListBoxWidth(ListBoxEx11);
          ListboxPopup(ListBoxEx11, Point(ComboEdit1.Left, ComboEdit1.Top + ComboEdit1.Height));
        end
        else ListBoxEx11.Visible := False;
      end;
    end;
end;

procedure TFormulaGUIForm.ComboEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case Key of
    13: begin   //return
          if ListBoxEx11.Visible and (ListBoxEx11.ItemIndex >= 0) then
            SelectFormula(StrLastWords(ListBoxEx11.Items[ListBoxEx11.ItemIndex]))
          else SelectFormula(ComboEdit1.Text);
          ListBoxEx11.Visible := False;
        end;
    40: if ListBoxEx11.Visible then  //down
          ListBoxEx11.ItemIndex := Min(ListBoxEx11.Items.Count - 1, ListBoxEx11.ItemIndex + 1);
    38: if ListBoxEx11.Visible then  //up
          ListBoxEx11.ItemIndex := Max(0, ListBoxEx11.ItemIndex - 1);
    end;
end;

procedure TFormulaGUIForm.ComboEdit1Exit(Sender: TObject);
begin
    ListBoxEx11.Visible := False;
end;

procedure TFormulaGUIForm.FormMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
    Mand3DForm.FormMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
end;

procedure TFormulaGUIForm.FormActivate(Sender: TObject);
begin
    Invalidate;
end;

procedure TFormulaGUIForm.FormCreate(Sender: TObject);
begin
    FGUIFormCreated := True;
    DECombineCmb.Hint :=  'Combination Methods:' + #13#10 +
  'Min: Both fractals are visible, minimum combine the DE''s' + #13#10 +
  'Max: Only overlapping parts, maximum combine the DE''s' + #13#10 +
  'Inv max: Invert DE of second Hybrid and combine ''Max''' + #13#10 +
  'Min lin: Minimum combine with a linear overlap function' + #13#10 +
  'Min nlin: Like S1, nonlinear function, more smooth overlap' + #13#10 +
  'Mix: First F1..FendHybrid1 then use FstartHybrid2..F6 (dIFS) with modified vector.';
end;

procedure TFormulaGUIForm.FormHide(Sender: TObject);
begin
    IniVal[26] := IntToStr(Left) + ' ' + IntToStr(Top);
end;

procedure TFormulaGUIForm.TabControl1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var mp: TPoint;
    i: Integer;
begin
    if Button = mbRight then
    begin
      GetCursorPos(mp);
      for i := 0 to 5 do PopupMenu2.Items[i].Enabled := i <> TabControl1.TabIndex;
      Shiftallformulasonetotheright1.Caption := 'Shift formulas ' +
           IntToStr(TabControl1.TabIndex + 1) + ' to 5 a position to the right';
      Shiftallformulasonetotheright1.Visible := TabControl1.TabIndex < 5;
      Shifttotheleft1.Caption := 'Shift formulas ' +
           IntToStr(TabControl1.TabIndex + 1) + ' to 6 a position to the left';
      PopupMenu2.Popup(mp.X, mp.Y);
    end;
end;

procedure TFormulaGUIForm.Copythevaluesto1Click(Sender: TObject);
var SourceNr, DestNr, i: Integer;
begin
    SourceNr := TabControl1.TabIndex;
    if SourceNr = 0 then DestNr := 2 else DestNr := 1;
    DestNr := StrToIntTrim(InputBox('Copy the values', 'to formula nr:', IntToStr(DestNr))) - 1;
    if DestNr <> SourceNr then
    begin
      for i := 0 to Mand3DForm.HAddon.Formulas[SourceNr].iOptionCount - 1 do
        Mand3DForm.HAddon.Formulas[DestNr].dOptionValue[i] := Mand3DForm.HAddon.Formulas[SourceNr].dOptionValue[i];
      TabControl1Change(Sender);
    end;
end;

procedure TFormulaGUIForm.Copythisformulatoformulanr11Click( Sender: TObject);
var SourceNr, DestNr, i, j: Integer;
    dOptionValues: array[0..15] of Double;
begin  //copy formula to...
    DestNr := Min(MAX_FORMULA_COUNT - 1, Max(0, (Sender as TMenuItem).Tag));
    SourceNr := TabControl1.TabIndex;
    if DestNr <> SourceNr then
    begin
      Mand3DForm.HAddon.Formulas[DestNr] := Mand3DForm.HAddon.Formulas[SourceNr];
      for i := 0 to 1 do
      begin
        if i = 0 then j := SourceNr else j := DestNr;
        if Mand3DForm.HAddon.Formulas[j].iFnr < 20 then
          ParseCFfromOld(Mand3DForm.HAddon.Formulas[j].iFnr, Mand3DForm.MHeader.PHCustomF[j], dOptionValues)
        else
          LoadCustomFormulaFromHeader(Mand3DForm.HAddon.Formulas[j].CustomFname,
              PTCustomFormula(Mand3DForm.MHeader.PHCustomF[j])^, dOptionValues);
      end;
      TabControl1Change(Sender);
    end;
end;

procedure TFormulaGUIForm.Shiftallformulasonetotheright1Click( Sender: TObject);
var StartNr, i: Integer;
    dOptionValues: array[0..15] of Double;
begin    // shitf all f's from tabnr one to right
    StartNr := TabControl1.TabIndex;
    for i := MAX_FORMULA_COUNT - 1 downto StartNr + 1 do
    begin
      Mand3DForm.HAddon.Formulas[i] := Mand3DForm.HAddon.Formulas[i - 1];
      if Mand3DForm.HAddon.Formulas[i].iFnr < 20 then
        ParseCFfromOld(Mand3DForm.HAddon.Formulas[i].iFnr, Mand3DForm.MHeader.PHCustomF[i], dOptionValues)
      else
        LoadCustomFormulaFromHeader(Mand3DForm.HAddon.Formulas[i].CustomFname,
            PTCustomFormula(Mand3DForm.MHeader.PHCustomF[i])^, dOptionValues);
    end;
    ClearFormula(StartNr);
    i := Mand3DForm.HAddon.bHybOpt1 shr 4;
    if i >= StartNr then Mand3DForm.HAddon.bHybOpt1 := (Mand3DForm.HAddon.bHybOpt1 and 7) or ((i + 1) shl 4);  //end1, repeat1
    i := Mand3DForm.HAddon.bHybOpt2 shr 8;
    if i >= StartNr then Mand3DForm.HAddon.bHybOpt2 := (Mand3DForm.HAddon.bHybOpt2 and $77) or ((i + 1) shl 8);  //start2, end2, repeat2
    CheckHybridOptions(@Mand3DForm.HAddon);
    TabControl1Change(Sender);
end;

procedure TFormulaGUIForm.Shifttotheleft1Click(Sender: TObject);
var StartNr, i: Integer;
    dOptionValues: array[0..15] of Double;
begin    // shitf all f's from tabnr one to left
    StartNr := Max(0, TabControl1.TabIndex - 1);
    for i := StartNr to 4 do
    begin
      Mand3DForm.HAddon.Formulas[i] := Mand3DForm.HAddon.Formulas[i + 1];
      if Mand3DForm.HAddon.Formulas[i].iFnr < 20 then
        ParseCFfromOld(Mand3DForm.HAddon.Formulas[i].iFnr, Mand3DForm.MHeader.PHCustomF[i], dOptionValues)
      else
        LoadCustomFormulaFromHeader(Mand3DForm.HAddon.Formulas[i].CustomFname,
            PTCustomFormula(Mand3DForm.MHeader.PHCustomF[i])^, dOptionValues);
    end;
    ClearFormula(MAX_FORMULA_COUNT - 1);
    i := Mand3DForm.HAddon.bHybOpt1 shr 4;
    if i >= Max(1, StartNr) then Mand3DForm.HAddon.bHybOpt1 := (Mand3DForm.HAddon.bHybOpt1 and 7) or ((i - 1) shl 4);  //end1, repeat1
    i := Mand3DForm.HAddon.bHybOpt2 shr 8;
    if i >= Max(1, StartNr) then Mand3DForm.HAddon.bHybOpt2 := (Mand3DForm.HAddon.bHybOpt2 and $77) or ((i - 1) shl 8);  //start2, end2, repeat2
    CheckHybridOptions(@Mand3DForm.HAddon);
    TabControl1Change(Sender);
end;

procedure TFormulaGUIForm.RefreshPreview;
begin
  Mand3DForm.RefreshPreview;
end;

end.




