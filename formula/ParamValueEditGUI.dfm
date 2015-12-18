object ParamValueEditFrm: TParamValueEditFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enter named parameter'
  ClientHeight = 144
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 103
    Width = 356
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 1
    object CancelAndExitBtn: TButton
      Left = 8
      Top = 8
      Width = 81
      Height = 25
      Align = alLeft
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = CancelAndExitBtnClick
    end
    object SaveAndExitBtn: TButton
      Left = 267
      Top = 8
      Width = 81
      Height = 25
      Align = alRight
      Caption = 'OK'
      Default = True
      TabOrder = 1
      OnClick = SaveAndExitBtnClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 356
    Height = 103
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label27: TLabel
      Left = 52
      Top = 75
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Value:'
    end
    object Label1: TLabel
      Left = 54
      Top = 47
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type:'
    end
    object Label2: TLabel
      Left = 51
      Top = 19
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'Name:'
    end
    object ValueEdit: TEdit
      Left = 88
      Top = 70
      Width = 183
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object TypeCmb: TComboBox
      Left = 88
      Top = 44
      Width = 183
      Height = 21
      Style = csDropDownList
      DropDownCount = 32
      TabOrder = 1
      Items.Strings = (
        'Double'
        'Single'
        'Integer'
        'Int64')
    end
    object ParamnameEdit: TEdit
      Left = 88
      Top = 16
      Width = 183
      Height = 21
      MaxLength = 32
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
end
