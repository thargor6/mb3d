object BulbTracer2Frm: TBulbTracer2Frm
  Left = 180
  Top = 121
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bulb Tracer2'
  ClientHeight = 602
  ClientWidth = 796
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 518
    Width = 796
    Height = 84
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object Label13: TLabel
      Left = 86
      Top = 58
      Width = 217
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label19: TLabel
      Left = 520
      Top = 60
      Width = 60
      Height = 13
      AutoSize = False
      Caption = 'Cancel type:'
    end
    object Button1: TButton
      Left = 7
      Top = 55
      Width = 65
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object CalculateBtn: TButton
      Left = 305
      Top = 55
      Width = 128
      Height = 25
      Caption = 'Generate Mesh'
      TabOrder = 1
      OnClick = CalculateBtnClick
    end
    object ProgressBar: TProgressBar
      Left = 8
      Top = 32
      Width = 780
      Height = 17
      Align = alTop
      Max = 15
      Smooth = True
      SmoothReverse = True
      Step = 1
      TabOrder = 2
    end
    object CancelBtn: TButton
      Left = 721
      Top = 55
      Width = 65
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = CancelBtnClick
    end
    object CancelTypeCmb: TComboBox
      Left = 583
      Top = 57
      Width = 136
      Height = 21
      Style = csDropDownList
      DropDownCount = 32
      TabOrder = 4
      OnChange = CancelTypeCmbChange
      Items.Strings = (
        'Cancel and show result'
        'Cancel immediately')
    end
    object Panel9: TPanel
      Left = 8
      Top = 8
      Width = 780
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      DesignSize = (
        780
        24)
      object Label24: TLabel
        Left = 0
        Top = 5
        Width = 32
        Height = 13
        Alignment = taRightJustify
        Caption = 'Frame:'
      end
      object FrameEdit: TEdit
        Left = 46
        Top = 0
        Width = 54
        Height = 21
        TabOrder = 0
        Text = '0'
        OnExit = FrameEditExit
      end
      object FrameUpDown: TUpDown
        Left = 100
        Top = 0
        Width = 17
        Height = 21
        Min = -32000
        Max = 32000
        TabOrder = 1
        OnClick = FrameUpDownClick
      end
      object FrameTBar: TTrackBarEx
        Tag = 10
        Left = 125
        Top = 0
        Width = 654
        Height = 21
        Anchors = []
        Ctl3D = True
        Max = 1000
        ParentCtl3D = False
        TabOrder = 2
        ThumbLength = 18
        TickMarks = tmBoth
        TickStyle = tsNone
        OnMouseUp = FrameTBarMouseUp
      end
    end
    object GenCurrMeshBtn: TButton
      Left = 433
      Top = 55
      Width = 81
      Height = 25
      Caption = 'Gen Curr Mesh'
      TabOrder = 6
      OnClick = CalculateBtnClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 378
    Width = 796
    Height = 140
    ActivePage = TabSheet1
    Align = alBottom
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Mesh properties'
      object Panel7: TPanel
        Left = 0
        Top = 84
        Width = 788
        Height = 28
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object Label10: TLabel
          Left = 503
          Top = 6
          Width = 54
          Height = 13
          AutoSize = False
          Caption = 'Save type:'
        end
        object FilenameREd: TEdit
          Left = 89
          Top = 2
          Width = 408
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object Button3: TButton
          Left = 4
          Top = 0
          Width = 83
          Height = 25
          Hint = 'Click to choose the output file'
          Caption = 'Output file:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = Button3Click
        end
        object SaveTypeCmb: TComboBox
          Left = 563
          Top = 2
          Width = 218
          Height = 21
          Style = csDropDownList
          DropDownCount = 32
          TabOrder = 2
          OnChange = SaveTypeCmbChange
          Items.Strings = (
            'Mesh as OBJ'
            'Mesh as Lightwave3d Object'
            'Unprocessed raw mesh (for huge meshes) '
            'Don'#39't save, only preview')
        end
      end
      object Panel8: TPanel
        Left = 0
        Top = 0
        Width = 788
        Height = 84
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label18: TLabel
          Left = 7
          Top = 8
          Width = 100
          Height = 13
          Alignment = taRightJustify
          Caption = 'Volumetric resolution:'
        end
        object MeshVResolutionLbl: TLabel
          Left = 220
          Top = 5
          Width = 93
          Height = 13
          AutoSize = False
          Caption = 'x 40 x 40'
        end
        object Label23: TLabel
          Left = 16
          Top = 35
          Width = 91
          Height = 13
          Hint = 'Measure of the sharpness/smoothness of the object'#39's surface'
          Alignment = taRightJustify
          Caption = 'Surface sharpness:'
          ParentShowHint = False
          ShowHint = True
        end
        object OpenGLPreviewCBx: TCheckBox
          Left = 563
          Top = 41
          Width = 130
          Height = 19
          Caption = 'OpenGL Preview'
          Checked = True
          State = cbChecked
          TabOrder = 0
          WordWrap = True
        end
        object MeshPreviewBtn: TButton
          Left = 706
          Top = -1
          Width = 75
          Height = 25
          Caption = 'OpenGL >>'
          TabOrder = 1
          OnClick = MeshPreviewBtnClick
        end
        object MeshVResolutionEdit: TEdit
          Left = 113
          Top = 2
          Width = 88
          Height = 21
          TabOrder = 2
          Text = '256'
          OnChange = MeshVResolutionEditChange
        end
        object SurfaceSharpnessEdit: TEdit
          Left = 113
          Top = 29
          Width = 54
          Height = 21
          TabOrder = 3
          Text = '1.25'
        end
        object SurfaceSharpnessUpDown: TUpDown
          Left = 166
          Top = 29
          Width = 17
          Height = 21
          Max = 32000
          TabOrder = 4
          OnClick = SurfaceSharpnessUpDownClick
        end
        object MeshVResolutionUpDown: TUpDown
          Left = 201
          Top = 2
          Width = 17
          Height = 21
          Min = 16
          Max = 4096
          Position = 256
          TabOrder = 5
        end
        object CalculateColorsCBx: TCheckBox
          Left = 113
          Top = 54
          Width = 130
          Height = 19
          Caption = 'Calculate Colors'
          Checked = True
          State = cbChecked
          TabOrder = 6
          WordWrap = True
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 378
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PageControl2: TPageControl
      Left = 0
      Top = 0
      Width = 377
      Height = 378
      ActivePage = TabSheet2
      Align = alLeft
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'Fractal to trace'
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 369
          Height = 350
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = -2
          object Label1: TLabel
            Left = 18
            Top = 55
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = 'X offset:'
          end
          object Label2: TLabel
            Left = 18
            Top = 82
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = 'Y offset:'
          end
          object Label3: TLabel
            Left = 18
            Top = 109
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = 'Z offset:'
          end
          object Label4: TLabel
            Left = 211
            Top = 55
            Width = 38
            Height = 13
            Alignment = taRightJustify
            Caption = 'X scale:'
          end
          object Label5: TLabel
            Left = 211
            Top = 82
            Width = 38
            Height = 13
            Alignment = taRightJustify
            Caption = 'Y scale:'
          end
          object Label6: TLabel
            Left = 211
            Top = 109
            Width = 38
            Height = 13
            Alignment = taRightJustify
            Caption = 'Z scale:'
          end
          object Label14: TLabel
            Left = 201
            Top = 140
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'Overall scale:'
          end
          object Edit1: TEdit
            Left = 63
            Top = 52
            Width = 88
            Height = 21
            Hint = 'This is a absolute offset in x direction of the rotated bulb.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            Text = '0.0'
            OnChange = Edit1Change
          end
          object Edit3: TEdit
            Left = 64
            Top = 79
            Width = 88
            Height = 21
            Hint = 'This is a absolute offset in x direction of the rotated bulb.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Text = '0.0'
            OnChange = Edit1Change
          end
          object Edit4: TEdit
            Left = 64
            Top = 106
            Width = 88
            Height = 21
            Hint = 'This is a absolute offset in x direction of the rotated bulb.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            Text = '0.0'
            OnChange = Edit1Change
          end
          object Edit5: TEdit
            Left = 256
            Top = 52
            Width = 64
            Height = 21
            TabOrder = 7
            Text = '1.0'
            OnChange = Edit1Change
          end
          object Edit6: TEdit
            Left = 256
            Top = 79
            Width = 64
            Height = 21
            TabOrder = 9
            Text = '1.0'
            OnChange = Edit1Change
          end
          object Edit7: TEdit
            Left = 256
            Top = 106
            Width = 64
            Height = 21
            TabOrder = 11
            Text = '1.0'
            OnChange = Edit1Change
          end
          object ImportParamsFromMainBtn: TButton
            Left = 12
            Top = 13
            Width = 171
            Height = 25
            Caption = 'Import parameter from main:'
            TabOrder = 0
            OnClick = ImportParamsFromMainBtnClick
          end
          object CheckBox3: TCheckBox
            Left = 32
            Top = 140
            Width = 129
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Use default orientation'
            Checked = True
            State = cbChecked
            TabOrder = 13
            OnClick = Edit1Change
          end
          object UpDown1: TUpDown
            Left = 320
            Top = 52
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 8
            OnClick = UpDown1Click
          end
          object UpDown2: TUpDown
            Tag = 1
            Left = 320
            Top = 79
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 10
            OnClick = UpDown1Click
          end
          object UpDown3: TUpDown
            Tag = 2
            Left = 320
            Top = 106
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 12
            OnClick = UpDown1Click
          end
          object UpDown4: TUpDown
            Left = 272
            Top = 135
            Width = 25
            Height = 25
            Min = -32000
            Max = 32000
            TabOrder = 15
            OnClick = UpDown4Click
          end
          object UpDown5: TUpDown
            Left = 152
            Top = 52
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            Orientation = udHorizontal
            TabOrder = 2
            OnClick = UpDown5Click
          end
          object UpDown6: TUpDown
            Left = 152
            Top = 79
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 4
            OnClick = UpDown6Click
          end
          object UpDown7: TUpDown
            Left = 152
            Top = 106
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 6
            OnClick = UpDown7Click
          end
          object RadioGroup3: TRadioGroup
            Left = 302
            Top = 128
            Width = 57
            Height = 49
            Hint = 'Scale the values by the selected percentage.'
            ItemIndex = 0
            Items.Strings = (
              '10%'
              '1%')
            ParentShowHint = False
            ShowHint = True
            TabOrder = 16
          end
          object Button6: TButton
            Left = 64
            Top = 163
            Width = 113
            Height = 21
            Caption = 'Reset offset+scale'
            TabOrder = 14
            OnClick = Button6Click
          end
          object Button2: TButton
            Left = 189
            Top = 13
            Width = 171
            Height = 25
            Caption = 'Load m3p (single file or sequence)'
            TabOrder = 17
            OnClick = Button2Click
          end
        end
      end
    end
    object PageControl3: TPageControl
      Left = 377
      Top = 0
      Width = 419
      Height = 378
      ActivePage = TabSheet3
      Align = alClient
      TabOrder = 1
      object TabSheet3: TTabSheet
        Caption = 'Trace Preview'
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 411
          Height = 350
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Image1: TImage
            Left = 12
            Top = 6
            Width = 322
            Height = 322
          end
          object Button5: TButton
            Left = 340
            Top = 292
            Width = 61
            Height = 54
            Caption = 'Calculate preview'
            Enabled = False
            TabOrder = 0
            WordWrap = True
            OnClick = Button5Click
          end
          object RadioGroup2: TRadioGroup
            Left = 340
            Top = 4
            Width = 61
            Height = 145
            Caption = 'Size:'
            ItemIndex = 2
            Items.Strings = (
              '16 '#179
              '32 '#179
              '64 '#179
              '128 '#179
              '256 '#179)
            TabOrder = 1
            OnClick = RadioGroup2Click
          end
          object CheckBox2: TCheckBox
            Left = 340
            Top = 184
            Width = 67
            Height = 39
            Caption = 'Auto update preview'
            Checked = True
            State = cbChecked
            TabOrder = 2
            WordWrap = True
          end
          object PreviewProgressBar: TProgressBar
            Left = 12
            Top = 334
            Width = 322
            Height = 12
            Max = 15
            Smooth = True
            SmoothReverse = True
            Step = 1
            TabOrder = 3
          end
        end
      end
    end
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 1032
    Top = 104
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 1032
    Top = 240
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer2Timer
    Left = 1048
    Top = 288
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer3Timer
    Left = 400
    Top = 336
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'm3p'
    Filter = 'M3D parameter (*.m3p)|*.m3p'
    Left = 104
    Top = 72
  end
end
