object VisualThemesFrm: TVisualThemesFrm
  Left = 148
  Top = 170
  BorderStyle = bsToolWindow
  Caption = 'Setting the Visual Theme'
  ClientHeight = 93
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 19
    Width = 33
    Height = 13
    Caption = 'Theme'
  end
  object SaveAndExitBtn: TButton
    Left = 118
    Top = 60
    Width = 195
    Height = 25
    Caption = 'Save + exit'
    TabOrder = 0
    OnClick = SaveAndExitBtnClick
  end
  object StylesCmb: TComboBox
    Left = 64
    Top = 16
    Width = 249
    Height = 21
    Style = csDropDownList
    DropDownCount = 32
    TabOrder = 1
    OnChange = StylesCmbChange
  end
  object DefaultBtn: TButton
    Left = 8
    Top = 60
    Width = 73
    Height = 25
    Caption = 'Default'
    TabOrder = 2
    OnClick = DefaultBtnClick
  end
end
