object HeightMapGenFrm: THeightMapGenFrm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'HeightMap Generator'
  ClientHeight = 464
  ClientWidth = 657
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
    Left = 499
    Top = 0
    Width = 158
    Height = 464
    Align = alRight
    TabOrder = 0
    object Label15: TLabel
      Left = 7
      Top = 425
      Width = 143
      Height = 13
      Caption = 'LMB: move           RMB: rotate'
    end
    object Label16: TLabel
      Left = 7
      Top = 441
      Width = 88
      Height = 13
      Caption = 'MMB/Wheel: zoom'
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
    object Button1: TButton
      Left = 11
      Top = 205
      Width = 134
      Height = 25
      Caption = 'Save HeightMap'
      TabOrder = 1
      OnClick = Button1Click
    end
  end
end
