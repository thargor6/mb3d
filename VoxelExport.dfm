object FVoxelExport: TFVoxelExport
  Left = 180
  Top = 121
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Voxel export'
  ClientHeight = 465
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 389
    Width = 738
    Height = 76
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 366
    object SpeedButton11: TSpeedButton
      Left = 8
      Top = 44
      Width = 33
      Height = 25
      Hint = 'Open a voxel project'
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
      OnClick = SpeedButton11Click
    end
    object SpeedButton9: TSpeedButton
      Left = 48
      Top = 44
      Width = 51
      Height = 25
      Hint = 'Save this voxel project'
      Caption = 'm3v'
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
      ShowHint = True
      OnClick = SpeedButton9Click
    end
    object Label13: TLabel
      Left = 380
      Top = 48
      Width = 3
      Height = 16
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Edit2: TEdit
      Left = 96
      Top = 10
      Width = 633
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Button3: TButton
      Left = 8
      Top = 8
      Width = 83
      Height = 25
      Hint = 'Click to choose the output folder'
      Caption = 'Output folder:'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 248
      Top = 44
      Width = 115
      Height = 25
      Caption = 'Start rendering slices'
      Enabled = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 624
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 3
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 144
      Top = 38
      Width = 89
      Height = 17
      Hint = 
        'The default output is white for the object and black for the out' +
        'side area.'#13#10'Choose this option to invert the colors.'
      Alignment = taLeftJustify
      Caption = 'White outside'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object CheckBox4: TCheckBox
      Left = 115
      Top = 57
      Width = 118
      Height = 17
      Hint = 
        'Disable this if you do not want leading zeros in the file indize' +
        's.'#13#10'For example:  name000010.png  will become  name10.png'
      Alignment = taLeftJustify
      Caption = 'Index with leading 0'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 5
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 389
    Align = alLeft
    Alignment = taLeftJustify
    TabOrder = 1
    ExplicitHeight = 366
    object Label1: TLabel
      Left = 34
      Top = 99
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'X offset:'
    end
    object Label2: TLabel
      Left = 34
      Top = 126
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Y offset:'
    end
    object Label3: TLabel
      Left = 34
      Top = 153
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z offset:'
    end
    object Label4: TLabel
      Left = 227
      Top = 99
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'X scale:'
    end
    object Label5: TLabel
      Left = 227
      Top = 126
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Y scale:'
    end
    object Label6: TLabel
      Left = 227
      Top = 153
      Width = 38
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z scale:'
    end
    object Label7: TLabel
      Left = 2
      Top = 8
      Width = 388
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Generate PNG-image 2d slices of the object.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 224
      Top = 236
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Max its.:'
    end
    object Label9: TLabel
      Left = 245
      Top = 263
      Width = 18
      Height = 13
      Alignment = taRightJustify
      Caption = 'DE:'
    end
    object Label10: TLabel
      Left = 25
      Top = 358
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z slices:'
    end
    object Label11: TLabel
      Left = 129
      Top = 358
      Width = 65
      Height = 13
      Caption = '-> Image size:'
    end
    object Label12: TLabel
      Left = 201
      Top = 358
      Width = 3
      Height = 13
    end
    object Label14: TLabel
      Left = 217
      Top = 184
      Width = 64
      Height = 13
      Alignment = taRightJustify
      Caption = 'Overall scale:'
    end
    object Label15: TLabel
      Left = 227
      Top = 308
      Width = 36
      Height = 13
      Alignment = taRightJustify
      Caption = 'Min its.:'
      Visible = False
    end
    object Label16: TLabel
      Left = 228
      Top = 308
      Width = 35
      Height = 13
      Alignment = taRightJustify
      Caption = 'MinDE:'
      Visible = False
    end
    object Edit1: TEdit
      Left = 80
      Top = 96
      Width = 88
      Height = 21
      Hint = 'This is a absolute offset in x direction of the rotated bulb.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = '0.0'
      OnChange = Edit1Change
    end
    object Edit3: TEdit
      Left = 80
      Top = 123
      Width = 88
      Height = 21
      Hint = 'This is a absolute offset in x direction of the rotated bulb.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '0.0'
      OnChange = Edit1Change
    end
    object Edit4: TEdit
      Left = 80
      Top = 150
      Width = 88
      Height = 21
      Hint = 'This is a absolute offset in x direction of the rotated bulb.'
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
      OnChange = Edit1Change
    end
    object Edit5: TEdit
      Left = 272
      Top = 96
      Width = 64
      Height = 21
      TabOrder = 3
      Text = '1.0'
      OnChange = Edit1Change
    end
    object Edit6: TEdit
      Left = 272
      Top = 123
      Width = 64
      Height = 21
      TabOrder = 4
      Text = '1.0'
      OnChange = Edit1Change
    end
    object Edit7: TEdit
      Left = 272
      Top = 150
      Width = 64
      Height = 21
      TabOrder = 5
      Text = '1.0'
      OnChange = Edit1Change
    end
    object Button4: TButton
      Left = 32
      Top = 40
      Width = 153
      Height = 25
      Caption = 'Import parameter from main:'
      TabOrder = 6
      OnClick = Button4Click
    end
    object RadioGroup1: TRadioGroup
      Left = 26
      Top = 217
      Width = 192
      Height = 66
      Caption = 'Object determination:'
      ItemIndex = 1
      Items.Strings = (
        'Maximum iteration count'
        'Distance estimation')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = RadioGroup4Click
    end
    object Edit8: TEdit
      Left = 272
      Top = 233
      Width = 64
      Height = 21
      TabOrder = 8
      Text = '10'
      OnChange = Edit1Change
    end
    object Edit9: TEdit
      Left = 272
      Top = 260
      Width = 64
      Height = 21
      TabOrder = 9
      Text = '0.5'
      OnChange = Edit1Change
    end
    object Edit10: TEdit
      Left = 71
      Top = 355
      Width = 49
      Height = 21
      Hint = 'Count of images (object slices) that will be calculated.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      Text = '100'
      OnChange = Edit10Change
    end
    object CheckBox3: TCheckBox
      Left = 48
      Top = 184
      Width = 129
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Use default orientation'
      TabOrder = 11
      OnClick = Edit1Change
    end
    object UpDown1: TUpDown
      Left = 336
      Top = 96
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 12
      OnClick = UpDown1Click
    end
    object UpDown2: TUpDown
      Tag = 1
      Left = 336
      Top = 123
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 13
      OnClick = UpDown1Click
    end
    object UpDown3: TUpDown
      Tag = 2
      Left = 336
      Top = 150
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 14
      OnClick = UpDown1Click
    end
    object UpDown4: TUpDown
      Left = 288
      Top = 179
      Width = 25
      Height = 25
      Min = -32000
      Max = 32000
      TabOrder = 15
      OnClick = UpDown4Click
    end
    object UpDown5: TUpDown
      Left = 168
      Top = 96
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      Orientation = udHorizontal
      TabOrder = 16
      OnClick = UpDown5Click
    end
    object UpDown6: TUpDown
      Left = 168
      Top = 123
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 17
      OnClick = UpDown6Click
    end
    object UpDown7: TUpDown
      Left = 168
      Top = 150
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 18
      OnClick = UpDown7Click
    end
    object UpDown8: TUpDown
      Left = 336
      Top = 233
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 19
      OnClick = UpDown8Click
    end
    object UpDown9: TUpDown
      Left = 336
      Top = 260
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 20
      OnClick = UpDown9Click
    end
    object RadioGroup3: TRadioGroup
      Left = 318
      Top = 172
      Width = 57
      Height = 49
      Hint = 'Scale the values by the selected percentage.'
      ItemIndex = 0
      Items.Strings = (
        '10%'
        '1%')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 21
    end
    object Button6: TButton
      Left = 216
      Top = 64
      Width = 105
      Height = 21
      Caption = 'Reset offset+scale'
      TabOrder = 22
      OnClick = Button6Click
    end
    object Edit11: TEdit
      Left = 272
      Top = 305
      Width = 64
      Height = 21
      TabOrder = 23
      Text = '10'
      Visible = False
      OnChange = Edit1Change
    end
    object UpDown10: TUpDown
      Left = 336
      Top = 305
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 24
      Visible = False
      OnClick = UpDown10Click
    end
    object RadioGroup4: TRadioGroup
      Left = 26
      Top = 289
      Width = 192
      Height = 49
      Hint = 
        'Type of object determination, lowering Max its or increasing DE'#13 +
        #10'(dependend on the choosen option), will make the object thicker' +
        '.'#13#10'Note:  DEcombinate formulas and In+Outside rendering'#13#10'       ' +
        '    works only in the Distance estimation mode!'
      Caption = 'In/out option:'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'Outside'
        'Inside'
        'In+Out')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 25
      OnClick = RadioGroup4Click
    end
    object Edit12: TEdit
      Left = 272
      Top = 305
      Width = 64
      Height = 21
      TabOrder = 26
      Text = '0.5'
      Visible = False
      OnChange = Edit1Change
    end
    object UpDown11: TUpDown
      Left = 336
      Top = 305
      Width = 25
      Height = 21
      Min = -32000
      Max = 32000
      TabOrder = 27
      Visible = False
      OnClick = UpDown11Click
    end
  end
  object Panel4: TPanel
    Left = 393
    Top = 0
    Width = 345
    Height = 389
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitHeight = 366
    object Image1: TImage
      Left = 12
      Top = 42
      Width = 322
      Height = 322
    end
    object Button5: TButton
      Left = 16
      Top = 8
      Width = 105
      Height = 25
      Caption = 'Calculate preview'
      Enabled = False
      TabOrder = 0
      OnClick = Button5Click
    end
    object RadioGroup2: TRadioGroup
      Left = 144
      Top = 2
      Width = 145
      Height = 37
      Caption = 'Preview max size:'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        '64 '#179
        '128 '#179
        '256 '#179)
      TabOrder = 1
    end
    object CheckBox2: TCheckBox
      Left = 17
      Top = 370
      Width = 119
      Height = 17
      Caption = 'Auto update preview'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 120
    Top = 472
  end
  object OpenDialog4: TOpenDialog
    DefaultExt = 'm3v'
    Filter = 'M3D Voxel project (*.m3v)|*.m3v'
    Left = 8
    Top = 400
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'm3v'
    Filter = 'M3D Voxel project (*.m3v)|*.m3v'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 40
    Top = 400
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 208
    Top = 384
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer2Timer
    Left = 352
    Top = 384
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer3Timer
    Left = 400
    Top = 336
  end
end
