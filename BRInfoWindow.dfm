object BRInfoForm: TBRInfoForm
  Left = 192
  Top = 127
  BorderStyle = bsDialog
  Caption = 'Big render'
  ClientHeight = 82
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 395
    Height = 16
    Caption = 
      'Extracting ambient information from the original M3I file, pleas' +
      'e wait:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 48
    Width = 393
    Height = 19
    TabOrder = 0
  end
end
