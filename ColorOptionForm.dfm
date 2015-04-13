object FColorOptions: TFColorOptions
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Color scaling options'
  ClientHeight = 169
  ClientWidth = 317
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 242
    Top = 13
    Width = 64
    Height = 13
  end
  object Image2: TImage
    Left = 242
    Top = 27
    Width = 64
    Height = 13
  end
  object Image3: TImage
    Left = 242
    Top = 49
    Width = 64
    Height = 13
  end
  object Image4: TImage
    Left = 242
    Top = 63
    Width = 64
    Height = 13
  end
  object Image5: TImage
    Left = 242
    Top = 85
    Width = 64
    Height = 13
  end
  object Image6: TImage
    Left = 242
    Top = 99
    Width = 64
    Height = 13
  end
  object Button1: TButton
    Tag = 1
    Left = 13
    Top = 15
    Width = 212
    Height = 25
    Caption = 'Downscale diffuse, keep reflections'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Tag = 2
    Left = 13
    Top = 51
    Width = 212
    Height = 25
    Caption = 'Downscale both'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button3: TButton
    Tag = 3
    Left = 13
    Top = 87
    Width = 212
    Height = 25
    Caption = 'Downscale specular'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button4: TButton
    Tag = 4
    Left = 89
    Top = 134
    Width = 136
    Height = 25
    Caption = 'Dunno, do nothing'
    TabOrder = 3
    OnClick = Button1Click
  end
end
