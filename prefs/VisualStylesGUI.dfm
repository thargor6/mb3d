object VisualStylesForm: TVisualStylesForm
  Left = 148
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Setting the Visual Style'
  ClientHeight = 425
  ClientWidth = 678
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 33
    Top = 79
    Width = 23
    Height = 13
    Caption = 'Style'
  end
  object SaveAndExitBtn: TButton
    Left = 571
    Top = 391
    Width = 91
    Height = 25
    Caption = 'Save + exit'
    TabOrder = 0
    OnClick = SaveAndExitBtnClick
  end
  object StylesCmb: TComboBox
    Left = 312
    Top = 80
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object ApplyBtn: TButton
    Left = 515
    Top = 74
    Width = 91
    Height = 25
    Caption = 'Apply'
    TabOrder = 2
    OnClick = ApplyBtnClick
  end
end
