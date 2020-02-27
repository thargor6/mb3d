object ZBuf16BitGenFrm: TZBuf16BitGenFrm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = '16Bit ZBuffer Generator'
  ClientHeight = 445
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object NavigatePnl: TPanel
    Left = 503
    Top = 0
    Width = 167
    Height = 445
    Align = alRight
    TabOrder = 0
    ExplicitLeft = 502
    object Label2: TLabel
      Left = 8
      Top = 86
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z offset:'
    end
    object Label3: TLabel
      Left = 13
      Top = 114
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z scale:'
    end
    object RefreshPreviewBtn: TButton
      Left = 6
      Top = 10
      Width = 156
      Height = 47
      Caption = 'Refresh'
      TabOrder = 0
      OnClick = RefreshPreviewBtnClick
    end
    object SaveImgBtn: TButton
      Left = 6
      Top = 192
      Width = 156
      Height = 25
      Caption = 'Save As Image'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = SaveImgBtnClick
    end
    object ZOffsetEdit: TEdit
      Left = 56
      Top = 83
      Width = 88
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = '0.0'
      OnChange = ZOffsetEditChange
    end
    object ZOffsetEditUpDown: TUpDown
      Left = 145
      Top = 83
      Width = 17
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 3
      OnClick = ZOffsetEditUpDownClick
    end
    object ZScaleEdit: TEdit
      Left = 56
      Top = 110
      Width = 88
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Text = '1.0'
      OnChange = ZScaleEditChange
    end
    object ZScaleEditUpDown: TUpDown
      Left = 145
      Top = 110
      Width = 17
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 5
      OnClick = ZScaleEditUpDownClick
    end
    object InfoMemo: TMemo
      Left = 1
      Top = 223
      Width = 165
      Height = 221
      Hint = 'Shows messages'
      Align = alBottom
      BorderStyle = bsNone
      Color = clSilver
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clTeal
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
      ExplicitTop = 348
      ExplicitWidth = 163
    end
    object InvertZBufferCBx: TCheckBox
      Left = 56
      Top = 137
      Width = 105
      Height = 19
      Caption = 'Invert ZBuffer'
      Checked = True
      State = cbChecked
      TabOrder = 7
      WordWrap = True
      OnClick = InvertZBufferCBxClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 503
    Height = 445
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 1
    ExplicitLeft = 2
    ExplicitWidth = 629
    ExplicitHeight = 570
    object MainPreviewImg: TImage
      Left = 0
      Top = 0
      Width = 480
      Height = 400
      AutoSize = True
    end
  end
  object SaveImgDialog: TSaveDialog
    DefaultExt = 'pgm'
    Filter = 'Portable Graymap|*.pgm|Portable Network Graphic 16bit|*.png'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 521
    Top = 135
  end
end
