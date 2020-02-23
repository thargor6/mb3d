object ZBuf16BitGenFrm: TZBuf16BitGenFrm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'HeightMap Generator'
  ClientHeight = 570
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NavigatePnl: TPanel
    Left = 181
    Top = 0
    Width = 613
    Height = 570
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 182
    ExplicitTop = -1
    object Label19: TLabel
      Left = 11
      Top = 166
      Width = 60
      Height = 13
      AutoSize = False
      Caption = 'Map Type:'
    end
    object Label1: TLabel
      Left = 11
      Top = 237
      Width = 60
      Height = 13
      AutoSize = False
      Caption = 'Map Number:'
    end
    object Label2: TLabel
      Left = 167
      Top = 92
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z offset:'
    end
    object Label3: TLabel
      Left = 172
      Top = 119
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'X scale:'
    end
    object LoadMeshBtn: TButton
      Left = 11
      Top = 13
      Width = 134
      Height = 25
      Caption = 'Load mesh'
      TabOrder = 0
    end
    object SaveMapBtn: TButton
      Left = 11
      Top = 261
      Width = 134
      Height = 25
      Hint = 'Save as heightmap inside the MB3D-maps-folder'
      Caption = 'Save As HeightMap'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object MapNumberUpDown: TUpDown
      Left = 126
      Top = 234
      Width = 16
      Height = 21
      Associate = MapNumberEdit
      Min = 1
      Max = 32000
      Position = 1
      TabOrder = 2
      Thousands = False
    end
    object MapNumberEdit: TEdit
      Left = 89
      Top = 234
      Width = 37
      Height = 21
      Hint = 'Map number'
      MaxLength = 5
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Text = '1'
    end
    object MapTypeCmb: TComboBox
      Left = 11
      Top = 185
      Width = 134
      Height = 21
      Style = csDropDownList
      DropDownCount = 32
      TabOrder = 4
      Items.Strings = (
        'Cancel and show result'
        'Cancel immediately')
    end
    object SaveImgBtn: TButton
      Left = 11
      Top = 341
      Width = 134
      Height = 25
      Hint = 'Save as image at the location you specify'
      Caption = 'Save As Image'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
    end
    object ResetBtn: TButton
      Left = 12
      Top = 477
      Width = 134
      Height = 25
      Caption = 'Reset position'
      TabOrder = 6
    end
    object ZOffsetEdit: TEdit
      Left = 215
      Top = 89
      Width = 88
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '0.0'
    end
    object XOffsetUpDown: TUpDown
      Left = 304
      Top = 89
      Width = 17
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 8
    end
    object ZScaleEdit: TEdit
      Left = 215
      Top = 116
      Width = 88
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '0.05'
    end
    object UpDown1: TUpDown
      Left = 304
      Top = 116
      Width = 17
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 10
      OnClick = UpDown1Click
    end
  end
  object SaveImgDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 688
    Top = 400
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'obj'
    Filter = 'Wavefront OBJ (*.obj)|*.obj'
    Left = 656
    Top = 80
  end
end
