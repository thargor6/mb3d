object ConstantValueEditFrm: TConstantValueEditFrm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enter constant value'
  ClientHeight = 112
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 71
    Width = 279
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
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
      Left = 190
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
    Width = 279
    Height = 71
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Label27: TLabel
      Left = 52
      Top = 47
      Width = 30
      Height = 13
      Alignment = taRightJustify
      Caption = 'Value:'
    end
    object Label1: TLabel
      Left = 54
      Top = 19
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Type:'
    end
    object ValueEdit: TEdit
      Left = 88
      Top = 44
      Width = 183
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object TypeCmb: TComboBox
      Left = 88
      Top = 16
      Width = 183
      Height = 21
      Style = csDropDownList
      DropDownCount = 32
      TabOrder = 1
      Items.Strings = (
        'Double'
        'Int64')
    end
  end
end
