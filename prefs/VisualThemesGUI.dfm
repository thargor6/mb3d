object VisualThemesFrm: TVisualThemesFrm
  Left = 148
  Top = 170
  BorderStyle = bsToolWindow
  Caption = 'Setting the Visual Theme'
  ClientHeight = 117
  ClientWidth = 390
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
    Left = 72
    Top = 19
    Width = 73
    Height = 13
    AutoSize = False
    Caption = 'Chose Theme:'
  end
  object SaveAndExitBtn: TButton
    Left = 151
    Top = 84
    Width = 231
    Height = 25
    Caption = 'Save + exit'
    TabOrder = 0
    OnClick = SaveAndExitBtnClick
  end
  object StylesCmb: TComboBox
    Left = 151
    Top = 16
    Width = 231
    Height = 21
    Style = csDropDownList
    DropDownCount = 32
    TabOrder = 1
    OnChange = StylesCmbChange
  end
  object DefaultThemeBtn: TButton
    Left = 8
    Top = 84
    Width = 137
    Height = 25
    Hint = 'Switch back to the default theme'
    Caption = 'Default Theme'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = DefaultThemeBtnClick
  end
  object ThemesOffBtn: TButton
    Left = 8
    Top = 53
    Width = 137
    Height = 25
    Hint = 'Use the default visual settings without a theme'
    Caption = 'Disable Themes'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = ThemesOffBtnClick
  end
end
