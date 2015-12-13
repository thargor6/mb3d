object JITFormulaEditorForm: TJITFormulaEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'JIT-compiled formula'
  ClientHeight = 592
  ClientWidth = 975
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 551
    Width = 975
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object CancelAndExitBtn: TButton
      Left = 8
      Top = 8
      Width = 195
      Height = 25
      Align = alLeft
      Caption = 'Cancel + exit'
      TabOrder = 0
      OnClick = CancelAndExitBtnClick
    end
    object SaveAndExitBtn: TButton
      Left = 772
      Top = 8
      Width = 195
      Height = 25
      Align = alRight
      Caption = 'Save + exit'
      TabOrder = 1
      OnClick = SaveAndExitBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 8
    Width = 975
    Height = 543
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 543
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 80
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 11
          Width = 73
          Height = 13
          AutoSize = False
          Caption = 'Formula name:'
        end
        object FormulanameEdit: TEdit
          Left = 8
          Top = 30
          Width = 171
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = True
          ParentFont = False
          ParentShowHint = False
          ReadOnly = True
          ShowHint = False
          TabOrder = 0
        end
      end
      object OptionsPnl: TPanel
        Left = 0
        Top = 445
        Width = 185
        Height = 98
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Panel9: TPanel
          Left = 0
          Top = 0
          Width = 185
          Height = 14
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label2: TLabel
            Left = 8
            Top = 0
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Options:'
          end
        end
        object Panel10: TPanel
          Left = 0
          Top = 14
          Width = 185
          Height = 84
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel11: TPanel
            Left = 144
            Top = 0
            Width = 41
            Height = 84
            Align = alRight
            BevelOuter = bvNone
            BorderWidth = 8
            TabOrder = 0
            object OptionDeleteBtn: TSpeedButton
              Left = 8
              Top = 48
              Width = 25
              Height = 20
              Hint = 'Delete selected option'
              Align = alTop
              Caption = 'Del'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = OptionDeleteBtnClick
              ExplicitLeft = -1
              ExplicitWidth = 28
            end
            object OptionAddBtn: TSpeedButton
              Left = 8
              Top = 8
              Width = 25
              Height = 20
              Hint = 'Add new option'
              Align = alTop
              Caption = 'Add'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = OptionAddBtnClick
              ExplicitLeft = 0
              ExplicitTop = 16
              ExplicitWidth = 27
            end
            object OptionEditBtn: TSpeedButton
              Left = 8
              Top = 28
              Width = 25
              Height = 20
              Hint = 'Edit selected option'
              Align = alTop
              Caption = 'Edit'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = OptionEditBtnClick
              ExplicitLeft = -1
              ExplicitTop = 48
              ExplicitWidth = 28
            end
          end
          object Panel12: TPanel
            Left = 0
            Top = 0
            Width = 144
            Height = 84
            Align = alClient
            BevelOuter = bvNone
            Padding.Left = 8
            Padding.Top = 8
            Padding.Bottom = 8
            TabOrder = 1
            object OptionsList: TListBox
              Left = 8
              Top = 8
              Width = 136
              Height = 68
              Align = alClient
              ItemHeight = 13
              TabOrder = 0
              OnClick = OptionsListClick
            end
          end
        end
      end
      object ConstantsPnl: TPanel
        Left = 0
        Top = 347
        Width = 185
        Height = 98
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
        object Panel13: TPanel
          Left = 0
          Top = 0
          Width = 185
          Height = 14
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label3: TLabel
            Left = 8
            Top = 0
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Constants:'
          end
        end
        object Panel14: TPanel
          Left = 0
          Top = 14
          Width = 185
          Height = 84
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel15: TPanel
            Left = 144
            Top = 0
            Width = 41
            Height = 84
            Align = alRight
            BevelOuter = bvNone
            BorderWidth = 8
            TabOrder = 0
            object ConstantDeleteBtn: TSpeedButton
              Left = 8
              Top = 48
              Width = 25
              Height = 20
              Hint = 'Delete selected constant value'
              Align = alTop
              Caption = 'Del'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ConstantDeleteBtnClick
              ExplicitLeft = -1
              ExplicitWidth = 28
            end
            object ConstantsAddBtn: TSpeedButton
              Left = 8
              Top = 8
              Width = 25
              Height = 20
              Hint = 'Add new constant value'
              Align = alTop
              Caption = 'Add'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ConstantsAddBtnClick
              ExplicitLeft = 0
              ExplicitTop = 16
              ExplicitWidth = 27
            end
            object ConstantEditBtn: TSpeedButton
              Left = 8
              Top = 28
              Width = 25
              Height = 20
              Hint = 'Edit selected constant value'
              Align = alTop
              Caption = 'Edit'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ConstantEditBtnClick
              ExplicitLeft = -1
              ExplicitTop = 48
              ExplicitWidth = 28
            end
          end
          object Panel16: TPanel
            Left = 0
            Top = 0
            Width = 144
            Height = 84
            Align = alClient
            BevelOuter = bvNone
            Padding.Left = 8
            Padding.Top = 8
            Padding.Bottom = 8
            TabOrder = 1
            object ConstantsList: TListBox
              Left = 8
              Top = 8
              Width = 136
              Height = 68
              Align = alClient
              ItemHeight = 13
              TabOrder = 0
              OnClick = ConstantsListClick
            end
          end
        end
      end
      object ParamsPnl: TPanel
        Left = 0
        Top = 80
        Width = 185
        Height = 267
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 3
        object Panel17: TPanel
          Left = 0
          Top = 0
          Width = 185
          Height = 14
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label4: TLabel
            Left = 8
            Top = 0
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'Named Params:'
          end
        end
        object Panel18: TPanel
          Left = 0
          Top = 14
          Width = 185
          Height = 253
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object Panel19: TPanel
            Left = 144
            Top = 0
            Width = 41
            Height = 253
            Align = alRight
            BevelOuter = bvNone
            BorderWidth = 8
            TabOrder = 0
            object ParamDeleteBtn: TSpeedButton
              Left = 8
              Top = 48
              Width = 25
              Height = 20
              Hint = 'Delete selected named parameter'
              Align = alTop
              Caption = 'Del'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ParamDeleteBtnClick
              ExplicitLeft = -1
              ExplicitWidth = 28
            end
            object ParamAddBtn: TSpeedButton
              Left = 8
              Top = 8
              Width = 25
              Height = 20
              Hint = 'Add new named parameter'
              Align = alTop
              Caption = 'Add'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ParamAddBtnClick
              ExplicitLeft = 0
              ExplicitTop = 16
              ExplicitWidth = 27
            end
            object ParamEditBtn: TSpeedButton
              Left = 8
              Top = 28
              Width = 25
              Height = 20
              Hint = 'Edit selected named parameter'
              Align = alTop
              Caption = 'Edit'
              Flat = True
              ParentShowHint = False
              ShowHint = True
              OnClick = ParamEditBtnClick
              ExplicitLeft = -1
              ExplicitTop = 48
              ExplicitWidth = 28
            end
          end
          object Panel20: TPanel
            Left = 0
            Top = 0
            Width = 144
            Height = 253
            Align = alClient
            BevelOuter = bvNone
            Padding.Left = 8
            Padding.Top = 8
            Padding.Bottom = 8
            TabOrder = 1
            object ParamsList: TListBox
              Left = 8
              Top = 8
              Width = 136
              Height = 237
              Align = alClient
              ItemHeight = 13
              TabOrder = 0
              OnClick = ParamsListClick
            end
          end
        end
      end
    end
    object Panel6: TPanel
      Left = 928
      Top = 0
      Width = 47
      Height = 543
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
    end
    object PageControl1: TPageControl
      Left = 185
      Top = 0
      Width = 743
      Height = 543
      ActivePage = CodeSheet
      Align = alClient
      TabOrder = 2
      object CodeSheet: TTabSheet
        Caption = 'Code'
        object CodePnl: TPanel
          Left = 0
          Top = 0
          Width = 735
          Height = 515
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 8
          TabOrder = 0
          object CodeEdit: TRichEdit
            Left = 8
            Top = 8
            Width = 719
            Height = 499
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clActiveCaption
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            Zoom = 100
          end
        end
      end
      object DescriptionSheet: TTabSheet
        Caption = 'Description'
        ImageIndex = 1
        object Panel7: TPanel
          Left = 0
          Top = 0
          Width = 735
          Height = 515
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 8
          TabOrder = 0
          object DescriptionEdit: TRichEdit
            Left = 8
            Top = 8
            Width = 719
            Height = 499
            Align = alClient
            Font.Charset = ANSI_CHARSET
            Font.Color = clActiveCaption
            Font.Height = -11
            Font.Name = 'Courier New'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            Zoom = 100
          end
        end
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 975
    Height = 8
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
  end
end
