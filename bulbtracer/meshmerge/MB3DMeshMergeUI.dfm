object MB3DMeshMergeFrm: TMB3DMeshMergeFrm
  Left = 0
  Top = 0
  Caption = 'MB3DMeshMerge (Win64)'
  ClientHeight = 301
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 241
    Width = 793
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object Label13: TLabel
      Left = 89
      Top = 34
      Width = 213
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
    object Button1: TButton
      Left = 8
      Top = 31
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object CalculateBtn: TButton
      Left = 308
      Top = 31
      Width = 177
      Height = 25
      Caption = 'Generate Mesh'
      TabOrder = 1
      OnClick = CalculateBtnClick
    end
    object ProgressBar: TProgressBar
      Left = 8
      Top = 8
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
      Left = 691
      Top = 31
      Width = 94
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = CancelBtnClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 793
    Height = 241
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object SmoothGBox: TJvGroupBox
      Left = 593
      Top = 13
      Width = 192
      Height = 100
      Caption = 'Taubin Smooth'
      TabOrder = 0
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
        Top = 70
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
        Top = 67
        Width = 54
        Height = 21
        TabOrder = 4
        Text = '0'
      end
      object TaubinSmoothPassesEditUpDown: TUpDown
        Left = 164
        Top = 67
        Width = 17
        Height = 21
        Min = -32000
        Max = 32000
        TabOrder = 5
        OnClick = TaubinSmoothPassesEditUpDownClick
      end
    end
    object LoadPartsBtn: TButton
      Left = 12
      Top = 13
      Width = 575
      Height = 25
      Caption = 'Select parts...'
      TabOrder = 1
      OnClick = LoadPartsBtnClick
    end
    object PartsMemo: TMemo
      Left = 12
      Top = 44
      Width = 575
      Height = 191
      ReadOnly = True
      TabOrder = 2
    end
    object MeshReductionGBox: TJvGroupBox
      Left = 593
      Top = 143
      Width = 192
      Height = 95
      Caption = 'Quadric Mesh Simplification'
      TabOrder = 3
      Checkable = True
      PropagateEnable = True
      object Label25: TLabel
        Left = 44
        Top = 20
        Width = 60
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
        Left = 31
        Top = 43
        Width = 73
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
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = '*.lwo'
    Left = 672
    Top = 176
  end
end
