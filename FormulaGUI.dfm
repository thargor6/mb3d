object FormulaGUIForm: TFormulaGUIForm
  Left = 844
  Top = 100
  BorderStyle = bsDialog
  Caption = 'Formulas'
  ClientHeight = 632
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 522
    Width = 335
    Height = 40
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 3
    object Label22: TLabel
      Left = 8
      Top = 1
      Width = 139
      Height = 13
      Caption = '4D rotation of the whole bulb:'
    end
    object XWLabel: TLabel
      Left = 8
      Top = 19
      Width = 21
      Height = 13
      Caption = 'XW:'
    end
    object YWLabel: TLabel
      Left = 104
      Top = 19
      Width = 21
      Height = 13
      Caption = 'YW:'
    end
    object ZWLabel: TLabel
      Left = 200
      Top = 19
      Width = 21
      Height = 13
      Caption = 'ZW:'
    end
    object XWEdit: TEdit
      Left = 40
      Top = 16
      Width = 49
      Height = 21
      Hint = 
        'The rotations are performed in a row, first the XW, last the ZW-' +
        'plane.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0.0'
    end
    object YWEdit: TEdit
      Left = 136
      Top = 16
      Width = 49
      Height = 21
      Hint = 
        'The rotations are performed in a row, first the XW, last the ZW-' +
        'plane.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '0.0'
    end
    object ZWEdit: TEdit
      Left = 232
      Top = 16
      Width = 49
      Height = 21
      Hint = 
        'The rotations are performed in a row, first the XW, last the ZW-' +
        'plane.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '0.0'
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 19
    Width = 335
    Height = 477
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Tabs.Strings = (
      'F01 '#8226
      'F02 '#8226
      'F03'
      'F04'
      'F05'
      'F06'
      'F07'
      'F08'
      'F09'
      'F10'
      'F11'
      'F12'
      'F13'
      'F14'
      'F15'
      'F16'
      'F17'
      'F18'
      'F19'
      'F20'
      'F21'
      'F22'
      'F23'
      'F24'
      'F25'
      'F26'
      'F27'
      'F28'
      'F29'
      'F30'
      'F31'
      'F32')
    TabIndex = 0
    OnChange = TabControl1Change
    OnMouseDown = TabControl1MouseDown
    object Bevel1: TBevel
      Left = 2
      Top = 21
      Width = 226
      Height = 23
      Style = bsRaised
    end
    object LabelItCount: TLabel
      Left = 7
      Top = 451
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Iterationcount:'
    end
    object SpeedButton11: TSpeedButton
      Left = 266
      Top = 48
      Width = 28
      Height = 20
      Hint = 'Load a new formula file'
      Flat = True
      Glyph.Data = {
        E6000000424DE6000000000000007600000028000000100000000E0000000100
        04000000000070000000C30E0000C30E00001000000010000000000000008484
        8400C6C6C60000FFFF0080FFFF0019E7F900FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222200000000000022200555555555550220405555555555022040555555555
        5502044055555555550204405555555555500444000005555550044444444000
        0002044444444444022204444444444402220444440000002222200000222222
        22222222222222222222}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton11Click
    end
    object SpeedButton2: TSpeedButton
      Left = 174
      Top = 51
      Width = 22
      Height = 20
      Hint = 'Displays some formula descriptions, if available.'
      Caption = 'i'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object Bevel2: TBevel
      Left = 7
      Top = 73
      Width = 290
      Height = 369
    end
    object ExchangeFormulaBtn: TSpeedButton
      Left = 261
      Top = 443
      Width = 37
      Height = 22
      Hint = 'Exchange this formula with the next one'
      Glyph.Data = {
        36010000424D3601000000000000760000002800000012000000100000000100
        040000000000C0000000C30E0000C30E0000100000001000000000000000C6C6
        C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00111111111111
        1111110000001111111111111111110000001111111111111111110000001111
        1100000011111100000011111011111101111100000011010111111110101100
        0000110001111111100011000000110000111111000011000000110001111111
        1000110000001100111111111100110000001101111111111110110000001111
        1111111111111100000000000111111110000000000002220111111110222000
        0000022201111111102220000000000001111111100000000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = ExchangeFormulaBtnClick
    end
    object SpeedButton4: TSpeedButton
      Left = 218
      Top = 48
      Width = 40
      Height = 20
      Hint = 
        'Shows hidden formulas.'#13#10'Rightclick on a formula to change its st' +
        'atus.'
      Caption = 'hidden'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton4Click
    end
    object SpeedButtonEx1: TSpeedButtonEx
      Tag = 1
      Left = 3
      Top = 22
      Width = 28
      Height = 21
      Hint = 'escapetime 3D formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = '3D'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx7: TSpeedButtonEx
      Tag = 7
      Left = 31
      Top = 22
      Width = 28
      Height = 21
      Hint = 'escapetime 3D formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = '3D'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx2: TSpeedButtonEx
      Tag = 2
      Left = 59
      Top = 22
      Width = 28
      Height = 21
      Hint = 'escapetime 3D formulas with analytic (faster) DE calculation'
      AllowAllUp = True
      GroupIndex = 5
      Caption = '3Da'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx3: TSpeedButtonEx
      Tag = 3
      Left = 87
      Top = 22
      Width = 28
      Height = 21
      Hint = 'escapetime 4D formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = '4D'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx4: TSpeedButtonEx
      Tag = 4
      Left = 115
      Top = 22
      Width = 28
      Height = 21
      Hint = 'escapetime 4D formulas with analytic (faster) DE calculation'
      AllowAllUp = True
      GroupIndex = 5
      Caption = '4Da'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx5: TSpeedButtonEx
      Tag = 5
      Left = 143
      Top = 22
      Width = 28
      Height = 21
      Hint = 
        'escapetime transformations only,'#13#10'use in combination with escape' +
        'time formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'Ads'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx6: TSpeedButtonEx
      Tag = 6
      Left = 171
      Top = 22
      Width = 28
      Height = 21
      Hint = 
        'escapetime transformations only,'#13#10'use in combination with escape' +
        'time formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'Ads'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx8: TSpeedButtonEx
      Tag = 8
      Left = 199
      Top = 22
      Width = 28
      Height = 21
      Hint = 
        'escapetime transformations only,'#13#10'use in combination with escape' +
        'time formulas'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'Ads'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx9: TSpeedButtonEx
      Tag = 9
      Left = 227
      Top = 22
      Width = 28
      Height = 21
      Hint = 'dIFS shapes'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'dIFS'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx10: TSpeedButtonEx
      Tag = 10
      Left = 255
      Top = 22
      Width = 28
      Height = 21
      Hint = 'dIFS shapes'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'dIFS'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object SpeedButtonEx11: TSpeedButtonEx
      Tag = 12
      Left = 283
      Top = 22
      Width = 28
      Height = 21
      Hint = 'dIFS transformations'
      AllowAllUp = True
      GroupIndex = 5
      Caption = 'dIFS'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnMouseEnter = SpeedButtonEx1MouseEnter
      OnMouseLeave = SpeedButtonEx1MouseLeave
    end
    object ComboEdit1: TEdit
      Left = 7
      Top = 51
      Width = 164
      Height = 21
      Hint = 'You can also type in the formula directly'
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      OnChange = ComboEdit1Change
      OnExit = ComboEdit1Exit
      OnKeyDown = ComboEdit1KeyDown
    end
    object Button4: TButton
      Left = 10
      Top = 123
      Width = 25
      Height = 25
      Hint = 'Push to normalise the 3d vector length to 1. '
      Caption = 'N'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Visible = False
      OnClick = Button4Click
    end
    object EditItCount: TEdit
      Left = 83
      Top = 448
      Width = 49
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '1'
      OnChange = EditItCountChange
    end
    object CheckBox1: TCheckBox
      Left = 144
      Top = 450
      Width = 103
      Height = 17
      Hint = 
        'Defines where the iteration starts again,'#13#10'when the last formula' +
        ' was done and no'#13#10'stop condition occured by then.'
      Alignment = taLeftJustify
      Caption = 'Repeat from here'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckBox1Click
    end
    object Button3: TButton
      Left = 241
      Top = 420
      Width = 57
      Height = 20
      Caption = 'Close'
      TabOrder = 3
      Visible = False
      OnClick = Button3Click
    end
    object ScrollBox1: TScrollBox
      Left = 7
      Top = 73
      Width = 319
      Height = 368
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 19
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 302
        Height = 800
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow
        ParentBackground = False
        TabOrder = 0
        object Label1: TLabel
          Left = 131
          Top = 8
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label10: TLabel
          Left = 131
          Top = 206
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label11: TLabel
          Left = 131
          Top = 228
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label12: TLabel
          Left = 131
          Top = 250
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label13: TLabel
          Left = 131
          Top = 272
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label14: TLabel
          Left = 131
          Top = 294
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label15: TLabel
          Left = 134
          Top = 316
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label16: TLabel
          Left = 134
          Top = 338
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label2: TLabel
          Left = 131
          Top = 30
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label3: TLabel
          Left = 131
          Top = 52
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label4: TLabel
          Left = 131
          Top = 74
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label5: TLabel
          Left = 131
          Top = 96
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label6: TLabel
          Left = 131
          Top = 118
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label7: TLabel
          Left = 131
          Top = 140
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label8: TLabel
          Left = 131
          Top = 162
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label9: TLabel
          Left = 131
          Top = 184
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Label17: TLabel
          Left = 134
          Top = 360
          Width = 3
          Height = 13
          Alignment = taRightJustify
          Visible = False
        end
        object Edit1: TJvSpinEdit
          Left = 148
          Top = 5
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Visible = False
          OnChange = Edit1Change
        end
        object Edit10: TJvSpinEdit
          Tag = 9
          Left = 148
          Top = 203
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Visible = False
          OnChange = Edit1Change
        end
        object Edit11: TJvSpinEdit
          Tag = 10
          Left = 148
          Top = 225
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
          OnChange = Edit1Change
        end
        object Edit12: TJvSpinEdit
          Tag = 11
          Left = 148
          Top = 247
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Visible = False
          OnChange = Edit1Change
        end
        object Edit13: TJvSpinEdit
          Tag = 12
          Left = 148
          Top = 269
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Visible = False
          OnChange = Edit1Change
        end
        object Edit14: TJvSpinEdit
          Tag = 13
          Left = 148
          Top = 291
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Visible = False
          OnChange = Edit1Change
        end
        object Edit15: TJvSpinEdit
          Tag = 14
          Left = 148
          Top = 313
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          Visible = False
          OnChange = Edit1Change
        end
        object Edit16: TJvSpinEdit
          Tag = 15
          Left = 148
          Top = 335
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          Visible = False
          OnChange = Edit1Change
        end
        object Edit2: TJvSpinEdit
          Tag = 1
          Left = 148
          Top = 27
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          Visible = False
          OnChange = Edit1Change
        end
        object Edit3: TJvSpinEdit
          Tag = 2
          Left = 148
          Top = 49
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          Visible = False
          OnChange = Edit1Change
        end
        object Edit4: TJvSpinEdit
          Tag = 3
          Left = 148
          Top = 71
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          Visible = False
          OnChange = Edit1Change
        end
        object Edit5: TJvSpinEdit
          Tag = 4
          Left = 148
          Top = 93
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          Visible = False
          OnChange = Edit1Change
        end
        object Edit6: TJvSpinEdit
          Tag = 5
          Left = 148
          Top = 115
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          Visible = False
          OnChange = Edit1Change
        end
        object Edit7: TJvSpinEdit
          Tag = 6
          Left = 148
          Top = 137
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          Visible = False
          OnChange = Edit1Change
        end
        object Edit8: TJvSpinEdit
          Tag = 7
          Left = 148
          Top = 159
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          Visible = False
          OnChange = Edit1Change
        end
        object Edit9: TJvSpinEdit
          Tag = 8
          Left = 148
          Top = 181
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 15
          Visible = False
          OnChange = Edit1Change
        end
        object Edit17: TJvSpinEdit
          Tag = 16
          Left = 148
          Top = 357
          Width = 137
          Height = 21
          Increment = 0.100000000000000000
          ValueType = vtFloat
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
          Visible = False
          OnChange = Edit1Change
        end
      end
    end
    object ListBoxEx10: TListBoxEx
      Tag = 10
      Left = 88
      Top = 157
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 16
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx1: TListBoxEx
      Tag = 1
      Left = 17
      Top = 78
      Width = 121
      Height = 96
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 5
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx11: TListBoxEx
      Tag = 11
      Left = 8
      Top = 75
      Width = 185
      Height = 25
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 15
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx11MouseDown
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx12: TListBoxEx
      Tag = 11
      Left = 96
      Top = 165
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 18
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx15: TListBoxEx
      Tag = 9
      Left = 207
      Top = 73
      Width = 293
      Height = 369
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 14
      Visible = False
      OnMouseDown = ListBoxEx15MouseDown
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx2: TListBoxEx
      Tag = 2
      Left = 24
      Top = 91
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 6
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx3: TListBoxEx
      Tag = 3
      Left = 32
      Top = 99
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 7
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx4: TListBoxEx
      Tag = 4
      Left = 40
      Top = 107
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      ItemHeight = 13
      Sorted = True
      TabOrder = 8
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx5: TListBoxEx
      Tag = 5
      Left = 48
      Top = 115
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 9
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx6: TListBoxEx
      Tag = 6
      Left = 56
      Top = 123
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 10
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx7: TListBoxEx
      Tag = 7
      Left = 64
      Top = 131
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 11
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx8: TListBoxEx
      Tag = 8
      Left = 72
      Top = 139
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 12
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object ListBoxEx9: TListBoxEx
      Tag = 9
      Left = 80
      Top = 149
      Width = 121
      Height = 97
      Style = lbOwnerDrawFixed
      AutoComplete = False
      BevelInner = bvSpace
      BevelKind = bkFlat
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemHeight = 12
      ParentFont = False
      Sorted = True
      TabOrder = 13
      Visible = False
      OnDrawItem = ListBoxEx9DrawItem
      OnMouseDown = ListBoxEx1MouseDown
      OnMouseEnter = ListBoxEx1MouseEnter
      OnMouseLeave = ListBoxEx1MouseLeave
      OnMouseMove = ListBoxEx1MouseMove
    end
    object RichEdit1: TRichEdit
      Left = 207
      Top = 73
      Width = 293
      Height = 369
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
      Visible = False
      Zoom = 100
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 562
    Width = 335
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object RBailoutLabel: TLabel
      Left = 197
      Top = 4
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'R bailout:'
    end
    object MaxIterLabel: TLabel
      Left = 26
      Top = 27
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = 'Max. iterations:'
    end
    object MinIterLabel: TLabel
      Left = 29
      Top = 4
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Min. iterations:'
    end
    object MaxIterHybridsPartLabel: TLabel
      Left = 6
      Top = 50
      Width = 91
      Height = 13
      Alignment = taRightJustify
      Caption = 'Maxits hybrid part2:'
      Visible = False
    end
    object RBailoutEdit: TEdit
      Left = 250
      Top = 1
      Width = 49
      Height = 21
      Hint = 
        'The bailout value for escapetime formulas.'#13#10'If the 3d value exce' +
        'eds this value while iterating,'#13#10'the current point does not belo' +
        'ng to the object.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '16'
    end
    object MaxIterEdit: TEdit
      Left = 105
      Top = 24
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '60'
    end
    object MinIterEdit: TEdit
      Left = 105
      Top = 1
      Width = 49
      Height = 21
      Hint = 
        'To reduce noise around objects in hybrids with bad distance esti' +
        'mates,'#13#10'use some iterations below the average iteration count in' +
        ' the image.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '1'
    end
    object CheckBox2: TCheckBox
      Left = 178
      Top = 26
      Width = 121
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Disable analytical DE'
      TabOrder = 3
    end
    object ComboBox1: TComboBox
      Left = 191
      Top = 47
      Width = 109
      Height = 21
      Hint = 
        'Outside render:  default mode'#13#10'Inside render:    slow raymarchin' +
        'g on the inside with max. its.'#13#10'In and outside:   render both si' +
        'des'
      Style = csDropDownList
      Ctl3D = False
      ItemIndex = 0
      ParentCtl3D = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = 'Outside render'
      Items.Strings = (
        'Outside render'
        'Inside render'
        'In and outside')
    end
    object MaxIterHybridPart2Edit: TEdit
      Left = 105
      Top = 47
      Width = 49
      Height = 21
      Hint = 
        'Maximal iterations for the second hybrid part, beginning with fo' +
        'rmula nr specified on top of this window.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '60'
      Visible = False
    end
  end
  object TabControl2: TTabControl
    Left = 0
    Top = 0
    Width = 335
    Height = 19
    Hint = 
      ' Type of hybrid:'#13#10'Alternate:  formulas 1 to 6 alternated.'#13#10'Inter' +
      'polate:  formula 1 interpolated in each iteration with formula 2' +
      '.'#13#10'DE combinate:  formula 1 is DE combinated with alternated hyb' +
      'rid of formulas 2 to 6.'
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    Style = tsButtons
    TabOrder = 2
    Tabs.Strings = (
      'Alternate'
      'Interpolate'
      'DEcombinate')
    TabIndex = 0
    OnChange = TabControl2Change
    OnChanging = TabControl2Changing
    object SpeedButton3: TSpeedButton
      Left = 276
      Top = 0
      Width = 38
      Height = 18
      Hint = 'Resets the formulas to the default P8 bulb.'
      Caption = 'Reset'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton3Click
    end
    object Label28: TLabel
      Left = 212
      Top = 4
      Width = 18
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '1'
      Visible = False
    end
    object RandomButton: TButton
      Left = 258
      Top = 0
      Width = 18
      Height = 18
      Caption = 'R'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = RandomButtonClick
    end
    object HybridStartBtn: TUpDown
      Left = 232
      Top = 1
      Width = 23
      Height = 18
      Hint = 'Formula nr where the 2nd part of the hybrid starts'
      Min = 2
      Max = 6
      Position = 2
      TabOrder = 1
      Visible = False
      OnClick = HybridStartBtnClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 494
    Width = 335
    Height = 28
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 4
    Visible = False
    object Label18: TLabel
      Left = 154
      Top = 7
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ds:'
      Visible = False
    end
    object Label25: TLabel
      Left = 10
      Top = 8
      Width = 50
      Height = 13
      Alignment = taRightJustify
      Caption = 'DE comb.:'
    end
    object Label27: TLabel
      Left = 228
      Top = 7
      Width = 29
      Height = 13
      Alignment = taRightJustify
      Caption = 'Fpow:'
      Visible = False
    end
    object Edit23: TEdit
      Left = 174
      Top = 4
      Width = 41
      Height = 21
      Hint = 
        'Absolute distance of the smooth combine functions,'#13#10'you can use ' +
        'scientific notation like 3e-5 for small values.'#13#10'Try 1/zoom to g' +
        'et close to a working value.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0.5'
      Visible = False
    end
    object DECombineCmb: TComboBox
      Left = 64
      Top = 4
      Width = 66
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'Min'
      OnChange = RadioGroup1Click
      Items.Strings = (
        'Min'
        'Max'
        'Inv max'
        'Min lin'
        'Min nlin'
        'Mix')
    end
    object Edit25: TEdit
      Left = 261
      Top = 4
      Width = 41
      Height = 21
      Hint = 'Scale value of the beginning formula, affects the DE accuracy'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '2.0'
      Visible = False
    end
  end
  object OpenDialog3: TOpenDialog
    DefaultExt = 'm3f'
    Filter = 'Mandel3D Formula (*.m3f)|*.m3f'
    Left = 256
    Top = 96
  end
  object Timer4: TTimer
    Enabled = False
    Interval = 800
    OnTimer = Timer4Timer
    Left = 8
    Top = 96
  end
  object Timer5: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer5Timer
    Left = 40
    Top = 96
  end
  object PopupMenu1: TPopupMenu
    Left = 120
    Top = 176
    object Ratethisformulaasnormal1: TMenuItem
      Tag = 1
      Caption = 'Normal status for this formula'
      OnClick = Hidethisformula1Click
    end
    object Ilikethisformula1: TMenuItem
      Caption = '+ vote formula'
      OnClick = Hidethisformula1Click
    end
    object voteformula1: TMenuItem
      Tag = 2
      Caption = '- vote formula'
      OnClick = Hidethisformula1Click
    end
    object Hidethisformula1: TMenuItem
      Tag = -2
      Caption = 'Hide this formula'
      OnClick = Hidethisformula1Click
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Deletethisformulapermanently1: TMenuItem
      Caption = 'Remove this formula from the local appdata folder'
      Visible = False
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 88
    Top = 72
    object Copythisformulatoformulanr11: TMenuItem
      Caption = 'Copy this formula to formula 1'
      OnClick = Copythisformulatoformulanr11Click
    end
    object Copythisformulatoformula21: TMenuItem
      Tag = 1
      Caption = 'Copy this formula to formula 2'
      OnClick = Copythisformulatoformulanr11Click
    end
    object Copythisformulatoformula31: TMenuItem
      Tag = 2
      Caption = 'Copy this formula to formula 3'
      OnClick = Copythisformulatoformulanr11Click
    end
    object Copythisformulatoformula41: TMenuItem
      Tag = 3
      Caption = 'Copy this formula to formula 4'
      OnClick = Copythisformulatoformulanr11Click
    end
    object Copythisformulatoformula51: TMenuItem
      Tag = 4
      Caption = 'Copy this formula to formula 5'
      OnClick = Copythisformulatoformulanr11Click
    end
    object Copythisformulatoformula61: TMenuItem
      Tag = 5
      Caption = 'Copy this formula to formula 6'
      OnClick = Copythisformulatoformulanr11Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Shiftallformulasonetotheright1: TMenuItem
      Caption = 'Shift to the right'
      OnClick = Shiftallformulasonetotheright1Click
    end
    object Shifttotheleft1: TMenuItem
      Caption = 'Shift to the left'
      OnClick = Shifttotheleft1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Copythevaluesto1: TMenuItem
      Caption = 'Copy the values to..'
      OnClick = Copythevaluesto1Click
    end
  end
  object Timer1: TTimer
    Tag = 5
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 8
    Top = 144
  end
end
