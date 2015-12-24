object MutaGenFrm: TMutaGenFrm
  Left = 0
  Top = 0
  Caption = 
    'MutaGen [DblClick on Image or Click on "Mutate!"-button to Mutat' +
    'e, RightClick for Menu]'
  ClientHeight = 663
  ClientWidth = 1081
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 848
    Top = 0
    Width = 233
    Height = 663
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GenerationsGrp: TJvGroupBox
      Left = 0
      Top = 563
      Width = 233
      Height = 100
      Align = alBottom
      Caption = 'Generations'
      TabOrder = 0
      PropagateEnable = True
      object Panel9: TPanel
        Left = 2
        Top = 15
        Width = 229
        Height = 83
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 0
        DesignSize = (
          229
          83)
        object GenerationBtn: TUpDown
          Left = 176
          Top = 8
          Width = 47
          Height = 25
          Min = -1000000
          Max = 1000000
          Orientation = udHorizontal
          TabOrder = 0
          OnClick = GenerationBtnClick
        end
        object ClearPrevGenerations: TButton
          Left = 53
          Top = 39
          Width = 129
          Height = 33
          Hint = 'Clear all generations before the selected one'
          Anchors = []
          Caption = 'Clear all previous'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = ClearPrevGenerationsClick
        end
        object GenerationEdit: TEdit
          Left = 24
          Top = 10
          Width = 148
          Height = 21
          Alignment = taRightJustify
          Color = clBtnFace
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 2
          Text = 'Generation n of N'
        end
      end
    end
    object MutateGrp: TJvGroupBox
      Left = 0
      Top = 434
      Width = 233
      Height = 129
      Align = alBottom
      Caption = 'Mutate'
      TabOrder = 1
      PropagateEnable = True
      object Panel8: TPanel
        Left = 2
        Top = 15
        Width = 229
        Height = 112
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 0
        object ProgressBar: TProgressBar
          Left = 4
          Top = 91
          Width = 221
          Height = 17
          Align = alBottom
          Max = 15
          Position = 10
          Smooth = True
          SmoothReverse = True
          Step = 1
          TabOrder = 0
        end
        object MutateBtn: TButton
          Left = 4
          Top = 4
          Width = 221
          Height = 38
          Align = alTop
          Caption = 'Mutate!'
          TabOrder = 1
          OnClick = MutateBtnClick
        end
      end
    end
    object OptionsGrp: TJvGroupBox
      Left = 0
      Top = 0
      Width = 233
      Height = 434
      Align = alClient
      Caption = 'Options'
      TabOrder = 2
      PropagateEnable = True
      object Panel7: TPanel
        Left = 2
        Top = 15
        Width = 229
        Height = 417
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 0
        object Panel5: TPanel
          Left = 4
          Top = 372
          Width = 221
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          DesignSize = (
            221
            41)
          object DisableAllBtn: TButton
            Left = 53
            Top = 3
            Width = 129
            Height = 33
            Anchors = []
            Caption = 'Disable all'
            TabOrder = 0
            OnClick = DisableAllBtnClick
          end
        end
        object GridPanel2: TGridPanel
          Left = 4
          Top = 4
          Width = 221
          Height = 368
          Align = alClient
          BevelKind = bkSoft
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 40.000000000000000000
            end
            item
              Value = 30.000000000000000000
            end
            item
              Value = 30.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = MinIterLabel
              Row = 0
            end
            item
              Column = 1
              Control = ModifyFormulaWeightTBar
              Row = 1
            end
            item
              Column = 1
              Control = Label2
              Row = 0
            end
            item
              Column = 2
              Control = Label3
              Row = 0
            end
            item
              Column = 0
              Control = Panel2
              Row = 1
            end
            item
              Column = 0
              Control = Panel3
              Row = 2
            end
            item
              Column = 1
              Control = ModifyParamsWeightTBar
              Row = 2
            end
            item
              Column = 2
              Control = ModifyParamsStrengthTBar
              Row = 2
            end
            item
              Column = 2
              Control = Label9
              Row = 1
            end
            item
              Column = 0
              Control = Panel4
              Row = 3
            end
            item
              Column = 1
              Control = ModifyJuliaModeWeightTBar
              Row = 3
            end
            item
              Column = 2
              Control = ModifyJuliaModeStrengthTBar
              Row = 3
            end
            item
              Column = 0
              Control = Panel6
              Row = 4
            end
            item
              Column = 1
              Control = ModifyIterationCountWeightTBar
              Row = 4
            end
            item
              Column = 2
              Control = ModifyIterationCountStrengthTBar
              Row = 4
            end>
          RowCollection = <
            item
              Value = 10.000000000000000000
            end
            item
              Value = 20.000000000000000000
            end
            item
              Value = 20.000000000000000000
            end
            item
              Value = 20.000000000000000000
            end
            item
              Value = 20.000000000000000000
            end
            item
              Value = 10.000000000000000000
            end>
          TabOrder = 1
          DesignSize = (
            217
            364)
          object MinIterLabel: TLabel
            Left = 3
            Top = 11
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Anchors = []
            Caption = 'Mutation type'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitTop = 47
          end
          object ModifyFormulaWeightTBar: TTrackBarEx
            Tag = 10
            Left = 86
            Top = 61
            Width = 65
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 0
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object Label2: TLabel
            Left = 88
            Top = 11
            Width = 61
            Height = 13
            Alignment = taRightJustify
            Anchors = []
            Caption = 'Probability'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitLeft = 93
            ExplicitTop = 47
          end
          object Label3: TLabel
            Left = 159
            Top = 11
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Anchors = []
            Caption = 'Strength'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            ExplicitLeft = 169
            ExplicitTop = 47
          end
          object Panel2: TPanel
            Left = 0
            Top = 36
            Width = 86
            Height = 52
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              86
              52)
            object Label1: TLabel
              Left = 4
              Top = 4
              Width = 72
              Height = 13
              Anchors = []
              Caption = 'Exchange, add'
            end
            object Label4: TLabel
              Left = 4
              Top = 32
              Width = 43
              Height = 13
              Anchors = []
              Caption = 'Formulas'
            end
            object Label5: TLabel
              Left = 4
              Top = 18
              Width = 57
              Height = 13
              Anchors = []
              Caption = 'and remove'
            end
          end
          object Panel3: TPanel
            Left = 0
            Top = 108
            Width = 86
            Height = 42
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            DesignSize = (
              86
              42)
            object Label6: TLabel
              Left = 4
              Top = 4
              Width = 75
              Height = 13
              Anchors = []
              Caption = 'Change Params'
            end
            object Label8: TLabel
              Left = 4
              Top = 18
              Width = 56
              Height = 13
              Anchors = []
              Caption = 'of Formulas'
            end
          end
          object ModifyParamsWeightTBar: TTrackBarEx
            Tag = 10
            Left = 86
            Top = 133
            Width = 65
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 3
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object ModifyParamsStrengthTBar: TTrackBarEx
            Tag = 10
            Left = 151
            Top = 133
            Width = 66
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 2000
            ParentCtl3D = False
            TabOrder = 4
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object Label9: TLabel
            Left = 182
            Top = 65
            Width = 4
            Height = 13
            Alignment = taRightJustify
            Anchors = []
            Caption = '-'
            ExplicitLeft = 211
            ExplicitTop = 64
          end
          object Panel4: TPanel
            Left = 0
            Top = 180
            Width = 86
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 5
            DesignSize = (
              86
              41)
            object Label7: TLabel
              Left = 4
              Top = 4
              Width = 37
              Height = 13
              Anchors = []
              Caption = 'Change'
            end
            object Label10: TLabel
              Left = 4
              Top = 18
              Width = 50
              Height = 13
              Anchors = []
              Caption = 'Julia Mode'
            end
          end
          object ModifyJuliaModeWeightTBar: TTrackBarEx
            Tag = 10
            Left = 86
            Top = 205
            Width = 65
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 6
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object ModifyJuliaModeStrengthTBar: TTrackBarEx
            Tag = 10
            Left = 151
            Top = 205
            Width = 66
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 2000
            ParentCtl3D = False
            TabOrder = 7
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object Panel6: TPanel
            Left = 0
            Top = 252
            Width = 86
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 8
            DesignSize = (
              86
              41)
            object Label11: TLabel
              Left = 4
              Top = 4
              Width = 37
              Height = 13
              Anchors = []
              Caption = 'Change'
            end
            object Label12: TLabel
              Left = 4
              Top = 18
              Width = 74
              Height = 13
              Anchors = []
              Caption = 'Iteration Count'
            end
          end
          object ModifyIterationCountWeightTBar: TTrackBarEx
            Tag = 10
            Left = 86
            Top = 277
            Width = 65
            Height = 21
            Anchors = []
            Ctl3D = True
            DoubleBuffered = False
            Max = 1000
            ParentCtl3D = False
            ParentDoubleBuffered = False
            TabOrder = 9
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object ModifyIterationCountStrengthTBar: TTrackBarEx
            Tag = 10
            Left = 151
            Top = 277
            Width = 66
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 2000
            ParentCtl3D = False
            TabOrder = 10
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
        end
      end
    end
  end
  object MainPnl: TPanel
    Left = 0
    Top = 0
    Width = 848
    Height = 663
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = MainPnlResize
    object Panel_1: TPanel
      Left = 247
      Top = 189
      Width = 50
      Height = 50
      Caption = '1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 0
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2: TPanel
      Left = 277
      Top = 133
      Width = 50
      Height = 50
      Caption = '1.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 1
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1: TPanel
      Left = 221
      Top = 133
      Width = 50
      Height = 50
      Caption = '1.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 2
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2_2: TPanel
      Left = 341
      Top = 101
      Width = 50
      Height = 50
      Caption = '1.2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 3
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2_1: TPanel
      Left = 341
      Top = 165
      Width = 50
      Height = 50
      Caption = '1.2.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 4
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1_2: TPanel
      Left = 165
      Top = 101
      Width = 50
      Height = 50
      Caption = '1.1.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 5
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 10
        ExplicitTop = 2
      end
    end
    object Panel_1_1_1: TPanel
      Left = 165
      Top = 165
      Width = 50
      Height = 50
      Caption = '1.1.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 6
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2_2_2: TPanel
      Left = 372
      Top = 45
      Width = 50
      Height = 50
      Caption = '1.2.2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 7
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_2_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = -3
        ExplicitTop = 10
      end
    end
    object Panel_1_2_2_1: TPanel
      Left = 311
      Top = 45
      Width = 50
      Height = 50
      Caption = '1.2.2.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 8
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_2_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1_2_2: TPanel
      Left = 205
      Top = 45
      Width = 50
      Height = 50
      Caption = '1.1.2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 9
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_2_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1_2_1: TPanel
      Left = 138
      Top = 45
      Width = 50
      Height = 50
      Caption = '1.1.2.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 10
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_2_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1_1_1: TPanel
      Left = 132
      Top = 221
      Width = 50
      Height = 50
      Caption = '1.1.1.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 11
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_1_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_1_1_2: TPanel
      Left = 195
      Top = 221
      Width = 50
      Height = 50
      Caption = '1.1.1.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 12
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_1_1_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2_1_2: TPanel
      Left = 372
      Top = 221
      Width = 50
      Height = 50
      Caption = '1.2.1.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 13
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_1_2: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object Panel_1_2_1_1: TPanel
      Left = 316
      Top = 221
      Width = 50
      Height = 50
      Caption = '1.2.1.1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      PopupMenu = MainPopupMenu
      TabOrder = 14
      VerticalAlignment = taAlignBottom
      OnDblClick = Panel_1DblClick
      object Image_1_2_1_1: TImage
        AlignWithMargins = True
        Left = 6
        Top = 6
        Width = 38
        Height = 33
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 10
        Align = alClient
        AutoSize = True
        PopupMenu = MainPopupMenu
        Transparent = True
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
    object WarningPnl: TPanel
      Left = 0
      Top = 0
      Width = 848
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      object Label13: TLabel
        Left = 4
        Top = 4
        Width = 840
        Height = 33
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'WARNING: some rare "evil" formula-combinations may SILENTLY cras' +
          'h the program, so please save important work before using the Mu' +
          'taGen-module! Save often! We will work on this to improve it!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
        ExplicitLeft = 12
        ExplicitTop = 12
        ExplicitWidth = 664
        ExplicitHeight = 13
      end
    end
  end
  object MainPopupMenu: TPopupMenu
    Left = 496
    Top = 144
    object SendtoMainItm: TMenuItem
      Caption = 'Send to Main Editor'
      OnClick = SendtoMainItmClick
    end
    object ToClipboardItm: TMenuItem
      Caption = 'Copy Params to Clipboard'
      OnClick = ToClipboardItmClick
    end
  end
  object PreviewRenderTimer: TTimer
    Enabled = False
    Interval = 50
    Left = 592
    Top = 296
  end
end
