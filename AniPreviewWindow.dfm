object AniPreviewForm: TAniPreviewForm
  Left = 297
  Top = 155
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Animation preview'
  ClientHeight = 338
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 371
    Height = 74
    Align = alBottom
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 152
      Top = 24
      Width = 73
      Height = 25
      Caption = 'AniGif'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C30E0000C30E0000100000001000000000000000FF00
        00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
        4444430000000000003440110311544011044011031154401104401104334440
        1104401120000002110440111111111111044012000000002104401055555555
        0104401055555555010440105555555501044010555555550104400055555555
        0004401055555555010443000000000000344444444444444444}
      Visible = False
      OnClick = SpeedButton1Click
    end
    object Button1: TButton
      Left = 288
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Exit'
      TabOrder = 0
      OnClick = Button1Click
    end
    object ProgressBar1: TProgressBar
      Left = 107
      Top = 25
      Width = 164
      Height = 24
      Smooth = True
      TabOrder = 1
      Visible = False
    end
    object CheckBox1: TCheckBox
      Left = 121
      Top = 2
      Width = 91
      Height = 17
      Caption = 'Show frame nr'
      TabOrder = 2
    end
    object CheckBox2: TCheckBox
      Left = 217
      Top = 2
      Width = 48
      Height = 17
      Caption = 'white'
      TabOrder = 3
    end
    object UpDown1: TUpDown
      Left = 66
      Top = 26
      Width = 18
      Height = 21
      Associate = Edit1
      Min = 1
      Max = 30
      Position = 15
      TabOrder = 4
    end
    object Edit1: TEdit
      Left = 32
      Top = 26
      Width = 34
      Height = 21
      TabOrder = 5
      Text = '15'
    end
    object ScrollBar1: TScrollBar
      Left = 0
      Top = 55
      Width = 371
      Height = 19
      PageSize = 0
      TabOrder = 6
      OnScroll = ScrollBar1Scroll
    end
    object CheckBox3: TCheckBox
      Left = 14
      Top = 4
      Width = 85
      Height = 17
      Caption = 'Frames/sec:'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20
    OnTimer = Timer1Timer
    Left = 280
    Top = 224
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer2Timer
    Left = 312
    Top = 224
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'gif'
    Filter = 'Animated Gif|*.gif'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 56
    Top = 40
  end
end
