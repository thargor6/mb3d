object TilingForm: TTilingForm
  Left = 200
  Top = 138
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Big renders'
  ClientHeight = 529
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton11: TSpeedButton
      Left = 14
      Top = 8
      Width = 99
      Height = 25
      Caption = 'Open project'
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
      ShowHint = False
      OnClick = SpeedButton11Click
    end
    object SpeedButton9: TSpeedButton
      Left = 123
      Top = 8
      Width = 102
      Height = 25
      Caption = 'Save project'
      Enabled = False
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
      ShowHint = False
      OnClick = SpeedButton9Click
    end
    object SpeedButton1: TSpeedButton
      Left = 278
      Top = 5
      Width = 123
      Height = 25
      Hint = 'Import parameters from a file to make a big render out of them'
      Caption = 'Import parameter'
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
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 416
      Top = 5
      Width = 113
      Height = 25
      Hint = 'Import the current parameters from main program'
      Caption = 'Import actual paras'
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton2Click
    end
    object CheckBox5: TCheckBox
      Left = 288
      Top = 37
      Width = 233
      Height = 17
      Hint = 
        'You have to render the original parameters first and store them ' +
        'as M3I file.'#13#10'Make that render not to small.'
      Caption = 'Use ambient shadows from original M3I file'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Visible = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 557
    Height = 436
    Align = alClient
    Enabled = False
    TabOrder = 1
    object Image1: TImage
      Left = 228
      Top = 136
      Width = 324
      Height = 280
      Hint = 'Rightclick on a tile for options'
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = Image1MouseDown
    end
    object Label2: TLabel
      Left = 13
      Top = 40
      Width = 178
      Height = 13
      Alignment = taRightJustify
      Caption = 'Original parameter size (width, height):'
    end
    object Label3: TLabel
      Left = 16
      Top = 136
      Width = 28
      Height = 13
      Caption = 'Tiling:'
    end
    object Label4: TLabel
      Left = 138
      Top = 93
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Size factor:'
    end
    object Label5: TLabel
      Left = 16
      Top = 248
      Width = 36
      Height = 13
      Caption = 'Saving:'
    end
    object Label6: TLabel
      Left = 34
      Top = 272
      Width = 135
      Height = 13
      Caption = 'Tile downscale, anti aliasing:'
    end
    object Label7: TLabel
      Left = 63
      Top = 163
      Width = 104
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tile count,  horizontal:'
    end
    object Label8: TLabel
      Left = 130
      Top = 187
      Width = 37
      Height = 13
      Alignment = taRightJustify
      Caption = 'vertical:'
    end
    object Label9: TLabel
      Left = 39
      Top = 211
      Width = 104
      Height = 13
      Alignment = taRightJustify
      Caption = 'Tilesize (including aa):'
    end
    object Label10: TLabel
      Left = 200
      Top = 40
      Width = 23
      Height = 13
      Caption = '0 x 0'
    end
    object Label11: TLabel
      Left = 152
      Top = 211
      Width = 23
      Height = 13
      Caption = '0 x 0'
    end
    object Label1: TLabel
      Left = 43
      Top = 64
      Width = 148
      Height = 13
      Alignment = taRightJustify
      Caption = 'Big size (including anti aliasing):'
    end
    object Label12: TLabel
      Left = 200
      Top = 64
      Width = 23
      Height = 13
      Caption = '0 x 0'
    end
    object Label13: TLabel
      Left = 32
      Top = 12
      Width = 84
      Height = 13
      Caption = 'Project:  (new)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Left = 103
      Top = 371
      Width = 59
      Height = 13
      Alignment = taRightJustify
      Caption = 'Jpeg quality:'
    end
    object Label24: TLabel
      Left = 141
      Top = 302
      Width = 29
      Height = 13
      Caption = 'sharp:'
    end
    object Edit1: TEdit
      Left = 200
      Top = 88
      Width = 57
      Height = 21
      TabOrder = 0
      Text = '3.0'
      OnChange = SpinEdit2Change
    end
    object CheckBox1: TCheckBox
      Left = 271
      Top = 93
      Width = 214
      Height = 17
      Hint = 
        'Check this option to get less color changes in the image.'#13#10'To ge' +
        't more details even when checked, do the coloring on the origina' +
        'l'#13#10'parameters with a lowered DEstop value, divided by the '#39'Size ' +
        'factor'#39'.'
      Caption = 'Scale DEstop to keep color && detail level'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
      OnClick = SpinEdit1Change
    end
    object RadioGroup1: TRadioGroup
      Left = 32
      Top = 320
      Width = 185
      Height = 41
      Caption = 'Output image type:'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'Png'
        'Jpeg'
        'Bmp')
      TabOrder = 2
    end
    object CheckBox2: TCheckBox
      Left = 32
      Top = 392
      Width = 121
      Height = 17
      Caption = 'Save Z buffer (png)'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object CheckBox3: TCheckBox
      Left = 32
      Top = 412
      Width = 113
      Height = 17
      Hint = 
        'You can save also m3i files for each tile, keep in mind that you' +
        ' got enough'#13#10'memory on the disc and that reflections are not sto' +
        'red in the m3i file.'#13#10#13#10'Note that you cannot open these m3i tile' +
        's in earlier program versions than 1.7.9!'
      Caption = 'Save m3i files'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object Button3: TButton
      Left = 328
      Top = 32
      Width = 201
      Height = 25
      Hint = 'Send this projects original parameter to the main program. '
      Caption = 'Send original parameter to main window'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = Button3Click
    end
    object Edit21: TEdit
      Tag = 3
      Left = 176
      Top = 160
      Width = 24
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 6
      Text = '4'
      OnChange = SpinEdit2Change
    end
    object UpDown3: TUpDown
      Left = 200
      Top = 160
      Width = 18
      Height = 21
      Associate = Edit21
      Min = 2
      Max = 99
      Position = 4
      TabOrder = 7
    end
    object Edit4: TEdit
      Left = 176
      Top = 299
      Width = 24
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 8
      Text = '0'
      OnChange = SpinEdit2Change
    end
    object UpDownSharp: TUpDown
      Left = 200
      Top = 299
      Width = 18
      Height = 21
      Associate = Edit4
      Max = 3
      TabOrder = 9
    end
    object Edit5: TEdit
      Left = 176
      Top = 269
      Width = 24
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 10
      Text = '1'
      OnChange = SpinEdit2Change
    end
    object UpDown1: TUpDown
      Left = 200
      Top = 269
      Width = 18
      Height = 21
      Associate = Edit5
      Min = 1
      Max = 3
      ParentShowHint = False
      Position = 1
      ShowHint = True
      TabOrder = 11
    end
    object Edit6: TEdit
      Tag = 2
      Left = 176
      Top = 184
      Width = 24
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 12
      Text = '4'
      OnChange = SpinEdit2Change
    end
    object UpDown2: TUpDown
      Left = 200
      Top = 184
      Width = 18
      Height = 21
      Associate = Edit6
      Min = 2
      Max = 99
      Position = 4
      TabOrder = 13
    end
    object Edit7: TEdit
      Left = 176
      Top = 368
      Width = 24
      Height = 21
      Hint = 'A higher value means a better quality, even 100% is lossy.'
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 14
      Text = '95'
      OnChange = SpinEdit2Change
    end
    object UpDown4: TUpDown
      Left = 200
      Top = 368
      Width = 18
      Height = 21
      Associate = Edit7
      Min = 75
      Position = 95
      TabOrder = 15
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 477
    Width = 557
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object Label16: TLabel
      Left = 360
      Top = 31
      Width = 27
      Height = 13
      Caption = 'up to:'
    end
    object Button1: TButton
      Left = 472
      Top = 14
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 14
      Width = 97
      Height = 25
      Caption = 'Render next tile'
      Enabled = False
      TabOrder = 1
      OnClick = Button2Click
    end
    object CheckBox4: TCheckBox
      Left = 129
      Top = 12
      Width = 155
      Height = 17
      Caption = 'Auto render all following tiles'
      TabOrder = 2
      OnClick = CheckBox4Click
    end
    object Edit2: TEdit
      Left = 322
      Top = 27
      Width = 31
      Height = 21
      TabOrder = 3
      Text = '1'
    end
    object CheckBox6: TCheckBox
      Left = 129
      Top = 30
      Width = 188
      Height = 17
      Caption = 'Render all tiles included in the lines:'
      TabOrder = 4
      OnClick = CheckBox6Click
    end
    object Edit3: TEdit
      Left = 393
      Top = 27
      Width = 32
      Height = 21
      Hint = 
        'Bigger values than existing (horizontal) lines will be cropped t' +
        'o the last line.'#13#10'No problem with that.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '999'
    end
    object CheckBox7: TCheckBox
      Left = 322
      Top = 4
      Width = 119
      Height = 17
      Hint = 
        'The default numbering includes 2 numbers, seperated in X and Y.'#13 +
        #10'If you choose this option, the numbering is only one number,'#13#10'i' +
        'ncreasing in each column and follows on the next row.'
      Caption = 'Single filenumbering'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = SpinEdit2Change
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'big'
    Filter = 'M3D big renders (*.big)|*.big'
    Left = 80
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'big'
    Filter = 'M3D big renders (*.big)|*.big'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 192
    Top = 8
  end
  object OpenDialog2: TOpenDialog
    Filter = 'M3D parameter (m3i, m3p)|*.m3i;*.m3p'
    Left = 464
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 352
    Top = 184
    object ileXY1: TMenuItem
      Caption = 'Tile: X= Y='
      Enabled = False
    end
    object Renderthistile1: TMenuItem
      Caption = 'Render this tile'
      OnClick = Renderthistile1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Deletethistilesfiles1: TMenuItem
      Caption = 'Delete this tiles files'
      OnClick = Deletethistilesfiles1Click
    end
  end
end
