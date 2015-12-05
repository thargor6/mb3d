object MapSequencesFrm: TMapSequencesFrm
  Left = 148
  Top = 170
  BorderStyle = bsToolWindow
  Caption = 'Edit Map Sequences'
  ClientHeight = 312
  ClientWidth = 743
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 190
    Height = 312
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    ExplicitLeft = -16
    ExplicitTop = 65
    ExplicitWidth = 217
    ExplicitHeight = 305
    object MapSequencesList: TListBox
      Left = 8
      Top = 8
      Width = 174
      Height = 296
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = MapSequencesListClick
      ExplicitLeft = 24
      ExplicitTop = 56
      ExplicitWidth = 121
      ExplicitHeight = 97
    end
  end
  object Panel3: TPanel
    Left = 190
    Top = 0
    Width = 553
    Height = 312
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 200
    ExplicitHeight = 356
    object Label1: TLabel
      Left = 6
      Top = 50
      Width = 42
      Height = 13
      Caption = 'Filename'
    end
    object SpeedButton11: TSpeedButton
      Left = 93
      Top = 382
      Width = 27
      Height = 25
      Hint = 'Open an animation parameter file'
      Glyph.Data = {
        E6000000424DE6000000000000007600000028000000100000000E0000000100
        04000000000070000000C30E0000C30E00001000000010000000000000008484
        8400C6C6C60000FFFF0080FFFF0019E7F900FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00222222222222
        2222200000000000022200555555555550220405555555555022040555555555
        5502044055555555550204405555555555500444000005555550044444444000
        0002044444444444022204444444444402220444440000002222200000222222
        22222222222222222222}
      ParentShowHint = False
      ShowHint = True
    end
    object SpeedButton9: TSpeedButton
      Left = -2
      Top = 382
      Width = 50
      Height = 25
      Hint = 'Save the animation parameters'
      Caption = 'm3a'
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C30E0000C30E0000100000001000000000000000FF00
        00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
        4444430000000000003440110311544011044011031154401104401104334440
        1104401120000002110440111111111111044012000000002104401055555555
        0104401055555555010440105555555501044010555555550104400055555555
        0004401055555555010443000000000000344444444444444444}
      ParentShowHint = False
      ShowHint = True
    end
    object Image3: TImage
      Left = 254
      Top = 75
      Width = 291
      Height = 198
    end
    object Label2: TLabel
      Left = 6
      Top = 77
      Width = 32
      Height = 13
      Caption = 'Range'
    end
    object Label3: TLabel
      Left = 6
      Top = 181
      Width = 76
      Height = 13
      Caption = 'Target Map Slot'
    end
    object DestChannelEdit: TEdit
      Left = 88
      Top = 178
      Width = 60
      Height = 21
      Hint = 'Map number'
      MaxLength = 5
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '1'
      OnExit = DestChannelEditExit
    end
    object DestChannelUpDown: TUpDown
      Left = 150
      Top = 178
      Width = 30
      Height = 21
      Associate = DestChannelEdit
      Min = -100000
      Max = 100000
      Position = 1
      TabOrder = 1
      Thousands = False
      OnClick = DestChannelUpDownClick
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 553
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      ExplicitTop = 8
      ExplicitWidth = 833
      object Bevel1: TBevel
        Left = 0
        Top = 31
        Width = 553
        Height = 2
        Align = alBottom
        Shape = bsBottomLine
        ExplicitLeft = 128
        ExplicitTop = 16
        ExplicitWidth = 50
      end
      object NewBtn: TSpeedButton
        Left = 0
        Top = 0
        Width = 120
        Height = 31
        Hint = 'Add new image sequence'
        Align = alLeft
        Caption = 'New Sequence'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000C30E0000C30E0000100000001000000000000000C6C6
          C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00111111111111
          1111111111111111111111000000000001111102222222220111110222222222
          0111110222222222011111022222222201111102222222220111110222222222
          0111110222222222011111022222222201111102222220000111110222222020
          1111110222222001111111000000001111111111111111111111}
        ParentShowHint = False
        ShowHint = True
        OnClick = NewBtnClick
      end
      object DeleteBtn: TSpeedButton
        Left = 128
        Top = 0
        Width = 120
        Height = 31
        Hint = 'Delete this keyframe'
        Align = alLeft
        Caption = 'Delete Sequence'
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000F0000000D0000000100
          04000000000068000000120B0000120B00001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3330391133333911133039111333911113303391113911113330333911111113
          3330333391111133333033333911133333313333911111333330333911191113
          3330339111339111333033911333391113303339333333911330333333333333
          3330}
        ParentShowHint = False
        ShowHint = True
        OnClick = DeleteBtnClick
        ExplicitLeft = 296
        ExplicitTop = 15
        ExplicitHeight = 18
      end
      object Panel5: TPanel
        Left = 120
        Top = 0
        Width = 8
        Height = 31
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 112
        ExplicitTop = 1
      end
    end
    object Panel4: TPanel
      Left = 0
      Top = 271
      Width = 553
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 8
      TabOrder = 3
      ExplicitTop = 522
      ExplicitWidth = 833
      object CancelAndExitBtn: TButton
        Left = 8
        Top = 8
        Width = 195
        Height = 25
        Align = alLeft
        Caption = 'Cancel + exit'
        TabOrder = 0
        OnClick = CancelAndExitBtnClick
        ExplicitLeft = 32
        ExplicitTop = 16
      end
      object SaveAndExitBtn: TButton
        Left = 350
        Top = 8
        Width = 195
        Height = 25
        Align = alRight
        Caption = 'Save + exit'
        TabOrder = 1
        OnClick = SaveAndExitBtnClick
        ExplicitLeft = 272
        ExplicitTop = 16
      end
    end
    object ImageFilenameEdit: TEdit
      Left = 62
      Top = 48
      Width = 483
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = False
      TabOrder = 4
    end
    object FirstImageEdit: TEdit
      Left = 62
      Top = 75
      Width = 60
      Height = 21
      Hint = 'Map number'
      MaxLength = 5
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnExit = FirstImageEditExit
    end
    object LastImageEdit: TEdit
      Left = 128
      Top = 75
      Width = 60
      Height = 21
      Hint = 'Map number'
      MaxLength = 5
      NumbersOnly = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnExit = LastImageEditExit
    end
    object LoopCheckBox: TCheckBox
      Left = 194
      Top = 79
      Width = 82
      Height = 15
      Caption = 'Loop'
      Checked = True
      ParentShowHint = False
      ShowHint = False
      State = cbChecked
      TabOrder = 7
      OnExit = LoopCheckBoxExit
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'All (*.png;*.bmp)|*.png;*.bmp|Portable Network Graphics (*.png)|' +
      '*.png|Bitmaps (*.bmp)|*.bmp'
    Left = 232
    Top = 224
  end
end
