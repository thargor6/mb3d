object HeightMapGenFrm: THeightMapGenFrm
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
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 636
    Top = 0
    Width = 158
    Height = 570
    Align = alRight
    TabOrder = 0
    object Label15: TLabel
      Left = 1
      Top = 543
      Width = 156
      Height = 13
      Align = alBottom
      Caption = 'LMB: move           RMB: rotate'
      ExplicitLeft = 7
      ExplicitTop = 425
      ExplicitWidth = 143
    end
    object Label16: TLabel
      Left = 1
      Top = 556
      Width = 156
      Height = 13
      Align = alBottom
      Caption = 'MMB/Wheel: zoom'
      ExplicitLeft = 7
      ExplicitTop = 441
      ExplicitWidth = 88
    end
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
    object LoadMeshBtn: TButton
      Left = 11
      Top = 13
      Width = 134
      Height = 25
      Caption = 'Load mesh'
      TabOrder = 0
      OnClick = LoadMeshBtnClick
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
      OnClick = SaveMapBtnClick
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
      OnClick = SaveImgBtnClick
    end
  end
  object SaveImgDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 688
    Top = 400
  end
end
