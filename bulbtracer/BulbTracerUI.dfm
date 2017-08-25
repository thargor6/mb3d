object BulbTracerFrm: TBulbTracerFrm
  Left = 180
  Top = 121
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bulb Tracer'
  ClientHeight = 636
  ClientWidth = 793
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
    Top = 552
    Width = 793
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
      Width = 777
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
      Width = 777
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 5
      DesignSize = (
        777
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
        Left = 123
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
    Top = 358
    Width = 793
    Height = 194
    ActivePage = TabSheet1
    Align = alBottom
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Mesh properties'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel7: TPanel
        Left = 0
        Top = 138
        Width = 785
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
        Width = 785
        Height = 138
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label7: TLabel
          Left = 4
          Top = 5
          Width = 100
          Height = 13
          AutoSize = False
          Caption = 'Mesh type:'
        end
        object MeshPropertiesNBk: TNotebook
          Left = 0
          Top = 24
          Width = 785
          Height = 114
          Align = alBottom
          TabOrder = 0
          object TPage
            Left = 0
            Top = 0
            Caption = 'Mesh'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Panel6: TPanel
              Left = 0
              Top = 0
              Width = 785
              Height = 114
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Label18: TLabel
                Left = 4
                Top = 5
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
              object Label20: TLabel
                Left = 4
                Top = 30
                Width = 100
                Height = 13
                Alignment = taRightJustify
                AutoSize = False
                Caption = 'Oversampling:'
              end
              object Label23: TLabel
                Left = 22
                Top = 55
                Width = 85
                Height = 13
                Hint = 'Measure of the distance to the object'#39's surface'
                Alignment = taRightJustify
                Caption = 'Surface iso value:'
                ParentShowHint = False
                ShowHint = True
              end
              object MeshVResolutionEdit: TEdit
                Left = 113
                Top = 2
                Width = 88
                Height = 21
                TabOrder = 0
                Text = '256'
                OnChange = MeshVResolutionEditChange
              end
              object MeshVResolutionUpDown: TUpDown
                Left = 201
                Top = 2
                Width = 16
                Height = 21
                Associate = MeshVResolutionEdit
                Min = 16
                Max = 4096
                Position = 256
                TabOrder = 1
              end
              object MeshOversamplingCmb: TComboBox
                Left = 113
                Top = 27
                Width = 104
                Height = 21
                Style = csDropDownList
                DropDownCount = 32
                ItemIndex = 0
                TabOrder = 2
                Text = 'None'
                Items.Strings = (
                  'None'
                  '2 x 2 x 2 = 8'
                  '3 x 3 x 3 = 27')
              end
              object SmoothGBox: TJvGroupBox
                Left = 385
                Top = 9
                Width = 192
                Height = 95
                Caption = 'Taubin Smooth'
                TabOrder = 5
                Checkable = True
                PropagateEnable = True
                object Label11: TLabel
                  Left = 63
                  Top = 20
                  Width = 41
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'Lambda:'
                end
                object Label21: TLabel
                  Left = 86
                  Top = 43
                  Width = 18
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'Mu:'
                end
                object Label22: TLabel
                  Left = 67
                  Top = 67
                  Width = 37
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'Passes:'
                end
                object TaubinSmoothLambaEdit: TEdit
                  Left = 110
                  Top = 17
                  Width = 54
                  Height = 21
                  TabOrder = 6
                  Text = '0'
                end
                object TaubinSmoothLambaUpDown: TUpDown
                  Left = 164
                  Top = 17
                  Width = 17
                  Height = 21
                  Min = -32000
                  Max = 32000
                  TabOrder = 1
                  OnClick = TaubinSmoothLambaUpDownClick
                end
                object TaubinSmoothMuEdit: TEdit
                  Left = 110
                  Top = 40
                  Width = 54
                  Height = 21
                  TabOrder = 2
                  Text = '0'
                end
                object TaubinSmoothMuUpDown: TUpDown
                  Left = 164
                  Top = 40
                  Width = 17
                  Height = 21
                  Min = -32000
                  Max = 32000
                  TabOrder = 3
                  OnClick = TaubinSmoothMuUpDownClick
                end
                object TaubinSmoothPassesEdit: TEdit
                  Left = 110
                  Top = 64
                  Width = 54
                  Height = 21
                  TabOrder = 4
                  Text = '0'
                end
                object TaubinSmoothPassesEditUpDown: TUpDown
                  Left = 164
                  Top = 64
                  Width = 17
                  Height = 21
                  Min = -32000
                  Max = 32000
                  TabOrder = 5
                  OnClick = TaubinSmoothPassesEditUpDownClick
                end
              end
              object MeshISOValueEdit: TEdit
                Left = 113
                Top = 52
                Width = 54
                Height = 21
                TabOrder = 3
                Text = '0.25'
              end
              object MeshISOValueUpDown: TUpDown
                Left = 167
                Top = 52
                Width = 17
                Height = 21
                Max = 32000
                TabOrder = 4
                OnClick = MeshISOValueUpDownClick
              end
              object MeshReductionGBox: TJvGroupBox
                Left = 583
                Top = 9
                Width = 192
                Height = 95
                Caption = 'Quadric Mesh Simplification'
                TabOrder = 6
                Checkable = True
                PropagateEnable = True
                object Label25: TLabel
                  Left = 47
                  Top = 20
                  Width = 57
                  Height = 13
                  Hint = 
                    'Remaining faces (1.0 = no reduction, 0.0 = max reduction = no re' +
                    'mainig faces )'
                  Alignment = taRightJustify
                  Caption = 'Retain ratio:'
                  ParentShowHint = False
                  ShowHint = True
                end
                object Label26: TLabel
                  Left = 33
                  Top = 43
                  Width = 71
                  Height = 13
                  Alignment = taRightJustify
                  Caption = 'Agressiveness:'
                end
                object MeshReductionRetainRatioEdit: TEdit
                  Left = 110
                  Top = 17
                  Width = 54
                  Height = 21
                  TabOrder = 4
                  Text = '0'
                end
                object MeshReductionRetainRatioUpDown: TUpDown
                  Left = 164
                  Top = 17
                  Width = 17
                  Height = 21
                  Min = -32000
                  Max = 32000
                  TabOrder = 1
                  OnClick = MeshReductionRetainRatioUpDownClick
                end
                object MeshReductionAgressivenessEdit: TEdit
                  Left = 110
                  Top = 40
                  Width = 54
                  Height = 21
                  TabOrder = 2
                  Text = '0'
                end
                object MeshReductionAgressivenessUpDown: TUpDown
                  Left = 164
                  Top = 40
                  Width = 17
                  Height = 21
                  Min = -32000
                  Max = 32000
                  TabOrder = 3
                  OnClick = MeshReductionAgressivenessUpDownClick
                end
              end
              object MeshCalcColorsCBx: TCheckBox
                Left = 113
                Top = 73
                Width = 156
                Height = 21
                Hint = 'Does not work fore all types on fractals'
                Caption = 'Approximate object color'
                Checked = True
                ParentShowHint = False
                ShowHint = True
                State = cbChecked
                TabOrder = 7
                WordWrap = True
              end
              object MeshSphericalScanCBx: TCheckBox
                Left = 265
                Top = 70
                Width = 104
                Height = 21
                Caption = 'Spherical scan'
                TabOrder = 8
                WordWrap = True
              end
              object Edit2: TEdit
                Left = 230
                Top = 16
                Width = 46
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
                TabOrder = 9
                Text = '0.0'
                OnChange = Edit1Change
              end
              object Edit10: TEdit
                Left = 282
                Top = 16
                Width = 46
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
                TabOrder = 10
                Text = '0.0'
                OnChange = Edit1Change
              end
              object Edit13: TEdit
                Left = 334
                Top = 16
                Width = 46
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
                TabOrder = 11
                Text = '0.0'
                OnChange = Edit1Change
              end
              object CalculateNormalsCBx: TCheckBox
                Left = 113
                Top = 93
                Width = 156
                Height = 17
                Caption = 'Approximate normals'
                TabOrder = 12
              end
              object Edit14: TEdit
                Left = 230
                Top = 43
                Width = 46
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
                TabOrder = 13
                Text = '0.0'
                OnChange = Edit1Change
              end
              object Edit15: TEdit
                Left = 282
                Top = 43
                Width = 46
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
                TabOrder = 14
                Text = '0.0'
                OnChange = Edit1Change
              end
              object Edit16: TEdit
                Left = 334
                Top = 43
                Width = 46
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
                TabOrder = 15
                Text = '0.0'
                OnChange = Edit1Change
              end
            end
          end
          object TPage
            Left = 0
            Top = 0
            Caption = 'Point Cloud'
            ExplicitWidth = 0
            ExplicitHeight = 0
            object Panel5: TPanel
              Left = 0
              Top = 0
              Width = 785
              Height = 114
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              object Label17: TLabel
                Left = 209
                Top = 21
                Width = 74
                Height = 13
                Alignment = taRightJustify
                Caption = 'U Param Steps:'
              end
              object UStepsEdit: TEdit
                Left = 252
                Top = 18
                Width = 64
                Height = 21
                TabOrder = 0
                Text = '40'
              end
              object UStepsUpDown: TUpDown
                Left = 299
                Top = 18
                Width = 17
                Height = 21
                Min = 16
                Max = 32000
                Position = 90
                TabOrder = 1
              end
            end
          end
        end
        object MeshTypeCmb: TComboBox
          Left = 113
          Top = 0
          Width = 104
          Height = 21
          Style = csDropDownList
          DropDownCount = 32
          ItemIndex = 0
          TabOrder = 1
          Text = 'Mesh'
          OnChange = MeshTypeCmbChange
          Items.Strings = (
            'Mesh'
            'Point Cloud')
        end
        object OpenGLPreviewCBx: TCheckBox
          Left = 385
          Top = 1
          Width = 130
          Height = 19
          Caption = 'OpenGL Preview'
          Checked = True
          State = cbChecked
          TabOrder = 2
          WordWrap = True
        end
        object MeshPreviewBtn: TButton
          Left = 706
          Top = -1
          Width = 75
          Height = 25
          Caption = 'OpenGL >>'
          TabOrder = 3
          OnClick = MeshPreviewBtnClick
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 793
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object PageControl2: TPageControl
      Left = 0
      Top = 0
      Width = 377
      Height = 358
      ActivePage = TabSheet2
      Align = alLeft
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'Fractal to trace'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 369
          Height = 330
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 0
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
          object Label8: TLabel
            Left = 210
            Top = 224
            Width = 39
            Height = 13
            Alignment = taRightJustify
            Caption = 'Max its.:'
          end
          object Label9: TLabel
            Left = 231
            Top = 251
            Width = 18
            Height = 13
            Alignment = taRightJustify
            Caption = 'DE:'
          end
          object Label12: TLabel
            Left = 187
            Top = 346
            Width = 3
            Height = 13
          end
          object Label14: TLabel
            Left = 201
            Top = 140
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'Overall scale:'
          end
          object Label15: TLabel
            Left = 213
            Top = 296
            Width = 36
            Height = 13
            Alignment = taRightJustify
            Caption = 'Min its.:'
            Visible = False
          end
          object Label16: TLabel
            Left = 214
            Top = 296
            Width = 35
            Height = 13
            Alignment = taRightJustify
            Caption = 'MinDE:'
            Visible = False
          end
          object Edit1: TEdit
            Left = 64
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
          object RadioGroup1: TRadioGroup
            Left = 12
            Top = 205
            Width = 192
            Height = 66
            Caption = 'Object determination:'
            ItemIndex = 1
            Items.Strings = (
              'Maximum iteration count'
              'Distance estimation')
            ParentShowHint = False
            ShowHint = True
            TabOrder = 17
            OnClick = RadioGroup4Click
          end
          object Edit8: TEdit
            Left = 258
            Top = 221
            Width = 64
            Height = 21
            TabOrder = 19
            Text = '10'
            OnChange = Edit1Change
          end
          object Edit9: TEdit
            Left = 258
            Top = 248
            Width = 64
            Height = 21
            TabOrder = 21
            Text = '0.5'
            OnChange = Edit1Change
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
          object UpDown8: TUpDown
            Left = 322
            Top = 221
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 20
            OnClick = UpDown8Click
          end
          object UpDown9: TUpDown
            Left = 322
            Top = 248
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 22
            OnClick = UpDown9Click
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
          object Edit11: TEdit
            Left = 258
            Top = 293
            Width = 64
            Height = 21
            TabOrder = 25
            Text = '10'
            Visible = False
            OnChange = Edit1Change
          end
          object UpDown10: TUpDown
            Left = 322
            Top = 293
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 26
            Visible = False
            OnClick = UpDown10Click
          end
          object RadioGroup4: TRadioGroup
            Left = 12
            Top = 277
            Width = 192
            Height = 49
            Hint = 
              'Type of object determination, lowering Max its or increasing DE'#13 +
              #10'(dependend on the choosen option), will make the object thicker' +
              '.'#13#10'Note:  DEcombinate formulas and In+Outside rendering'#13#10'       ' +
              '    works only in the Distance estimation mode!'
            Caption = 'In/out option:'
            Columns = 3
            ItemIndex = 0
            Items.Strings = (
              'Outside'
              'Inside'
              'In+Out')
            ParentShowHint = False
            ShowHint = True
            TabOrder = 18
            OnClick = RadioGroup4Click
          end
          object Edit12: TEdit
            Left = 258
            Top = 293
            Width = 64
            Height = 21
            TabOrder = 23
            Text = '0.5'
            Visible = False
            OnChange = Edit1Change
          end
          object UpDown11: TUpDown
            Left = 322
            Top = 293
            Width = 25
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 24
            Visible = False
            OnClick = UpDown11Click
          end
          object Button2: TButton
            Left = 189
            Top = 13
            Width = 171
            Height = 25
            Caption = 'Load m3p (single file or sequence)'
            TabOrder = 27
            OnClick = Button2Click
          end
        end
      end
    end
    object PageControl3: TPageControl
      Left = 377
      Top = 0
      Width = 416
      Height = 358
      ActivePage = TabSheet3
      Align = alClient
      TabOrder = 1
      object TabSheet3: TTabSheet
        Caption = 'Trace Preview'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 408
          Height = 330
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Image1: TImage
            Left = 8
            Top = 4
            Width = 322
            Height = 322
          end
          object Button5: TButton
            Left = 340
            Top = 272
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
