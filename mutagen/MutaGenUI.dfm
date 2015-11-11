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
    object CategoryPanelGroup1: TCategoryPanelGroup
      Left = 0
      Top = 0
      Width = 233
      Height = 663
      VertScrollBar.Tracking = True
      VertScrollBar.Visible = False
      Align = alClient
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -12
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      HeaderHeight = 20
      TabOrder = 0
      object CategoryPanel2: TCategoryPanel
        Top = 201
        Height = 181
        Caption = 'Mutate'
        TabOrder = 0
        object MutateBtn: TButton
          Left = 4
          Top = 9
          Width = 221
          Height = 38
          Anchors = []
          Caption = 'Mutate!'
          TabOrder = 0
          OnClick = MutateBtnClick
        end
        object ProgressBar: TProgressBar
          Left = 4
          Top = 134
          Width = 221
          Height = 17
          Max = 15
          Position = 10
          Smooth = True
          SmoothReverse = True
          Step = 1
          TabOrder = 1
        end
      end
      object CategoryPanel1: TCategoryPanel
        Top = 0
        Height = 201
        Caption = 'Options'
        TabOrder = 1
        object GridPanel2: TGridPanel
          Left = 0
          Top = 0
          Width = 229
          Height = 179
          Align = alClient
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
            end>
          RowCollection = <
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end>
          TabOrder = 0
          DesignSize = (
            229
            179)
          object MinIterLabel: TLabel
            Left = 5
            Top = 15
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
            ExplicitLeft = 3
            ExplicitTop = 47
          end
          object ModifyFormulaWeightTBar: TTrackBarEx
            Tag = 10
            Left = 91
            Top = 55
            Width = 67
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
            Left = 94
            Top = 15
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
            Left = 169
            Top = 15
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
            ExplicitTop = 47
          end
          object Panel2: TPanel
            Left = 0
            Top = 44
            Width = 91
            Height = 42
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              91
              42)
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
            Top = 88
            Width = 91
            Height = 42
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
            DesignSize = (
              91
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
            Left = 91
            Top = 99
            Width = 68
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
            Left = 159
            Top = 99
            Width = 70
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 4
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
          end
          object Label9: TLabel
            Left = 192
            Top = 59
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
            Top = 132
            Width = 91
            Height = 41
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 5
            ExplicitTop = 135
            DesignSize = (
              91
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
            Left = 91
            Top = 145
            Width = 68
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 6
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
            ExplicitTop = 133
          end
          object ModifyJuliaModeStrengthTBar: TTrackBarEx
            Tag = 10
            Left = 159
            Top = 145
            Width = 70
            Height = 21
            Anchors = []
            Ctl3D = True
            Max = 1000
            ParentCtl3D = False
            TabOrder = 7
            ThumbLength = 18
            TickMarks = tmBoth
            TickStyle = tsNone
            ExplicitTop = 133
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
        OnDblClick = Panel_1DblClick
        ExplicitLeft = 35
        ExplicitTop = 11
        ExplicitWidth = 28
        ExplicitHeight = 28
      end
    end
  end
  object MainPopupMenu: TPopupMenu
    Left = 496
    Top = 144
    object SendtoMainItm: TMenuItem
      Caption = 'Send to Main'
      OnClick = SendtoMainItmClick
    end
  end
end
