object AniProcessForm: TAniProcessForm
  Left = 153
  Top = 256
  BorderStyle = bsDialog
  Caption = 'Animation processing'
  ClientHeight = 423
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 104
    Width = 185
    Height = 172
    Shape = bsFrame
  end
  object Bevel2: TBevel
    Left = 8
    Top = 28
    Width = 185
    Height = 71
    Shape = bsFrame
  end
  object Bevel4: TBevel
    Left = 8
    Top = 281
    Width = 185
    Height = 64
    Shape = bsFrame
  end
  object Label16: TLabel
    Left = 12
    Top = 229
    Width = 80
    Height = 13
    Alignment = taRightJustify
    Caption = 'Smooth Normals:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label18: TLabel
    Left = 46
    Top = 115
    Width = 41
    Height = 13
    Alignment = taRightJustify
    Caption = 'DE stop:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 24
    Top = 194
    Width = 67
    Height = 26
    Alignment = taRightJustify
    Caption = 'Stepcount for '#13#10'binary search:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 37
    Top = 8
    Width = 143
    Height = 13
    Caption = 'Check to change the value [x]'
  end
  object Label15: TLabel
    Left = 13
    Top = 32
    Width = 77
    Height = 26
    Alignment = taRightJustify
    Caption = 'Subframes to  '#13#10'render between:'
  end
  object Bevel3: TBevel
    Left = 200
    Top = 141
    Width = 177
    Height = 204
    Shape = bsFrame
  end
  object Label5: TLabel
    Left = 31
    Top = 292
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = 'Max. Iterat.:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 34
    Top = 318
    Width = 53
    Height = 13
    Alignment = taRightJustify
    Caption = 'Min. Iterat.:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 15
    Top = 62
    Width = 75
    Height = 26
    Alignment = taRightJustify
    Caption = 'Subframe count'#13#10'multiplicator:'
  end
  object Label22: TLabel
    Left = 10
    Top = 143
    Width = 85
    Height = 13
    Alignment = taRightJustify
    Caption = 'Raystep multiplier:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 172
    Width = 79
    Height = 13
    Alignment = taRightJustify
    Caption = 'Stepwidth limiter:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel5: TBevel
    Left = 8
    Top = 352
    Width = 185
    Height = 33
    Shape = bsFrame
  end
  object Button1: TButton
    Left = 302
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Tag = 1
    Left = 200
    Top = 8
    Width = 177
    Height = 25
    Caption = 'Put the values to all keyframes'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Tag = 2
    Left = 200
    Top = 40
    Width = 177
    Height = 25
    Caption = 'To this keyframe and the following'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button4: TButton
    Tag = 3
    Left = 200
    Top = 72
    Width = 177
    Height = 25
    Caption = 'To this keyframe and all before'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Edit25: TEdit
    Left = 100
    Top = 112
    Width = 49
    Height = 21
    TabOrder = 4
    Text = '0.8'
  end
  object CheckBox1: TCheckBox
    Left = 168
    Top = 227
    Width = 17
    Height = 17
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 168
    Top = 114
    Width = 17
    Height = 17
    TabOrder = 6
  end
  object CheckBox4: TCheckBox
    Left = 168
    Top = 142
    Width = 17
    Height = 17
    TabOrder = 7
  end
  object CheckBox5: TCheckBox
    Left = 168
    Top = 199
    Width = 17
    Height = 17
    TabOrder = 8
  end
  object Button5: TButton
    Left = 8
    Top = 392
    Width = 201
    Height = 25
    Caption = 'Rerender all keyframe preview images'
    TabOrder = 9
    OnClick = Button5Click
  end
  object CheckBox6: TCheckBox
    Left = 168
    Top = 38
    Width = 17
    Height = 17
    TabOrder = 10
  end
  object Edit1: TEdit
    Left = 100
    Top = 36
    Width = 49
    Height = 21
    TabOrder = 11
    Text = '30'
  end
  object Button6: TButton
    Tag = 4
    Left = 200
    Top = 104
    Width = 177
    Height = 25
    Caption = 'Only to the actual keyframe'
    TabOrder = 12
    OnClick = Button2Click
  end
  object CheckBox8: TCheckBox
    Left = 208
    Top = 149
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'All the light + color settings'
    TabOrder = 13
  end
  object Edit4: TEdit
    Left = 100
    Top = 289
    Width = 49
    Height = 21
    TabOrder = 14
    Text = '60'
  end
  object CheckBox11: TCheckBox
    Left = 168
    Top = 292
    Width = 17
    Height = 17
    TabOrder = 15
  end
  object Edit5: TEdit
    Left = 100
    Top = 315
    Width = 49
    Height = 21
    TabOrder = 16
    Text = '1'
  end
  object CheckBox12: TCheckBox
    Left = 168
    Top = 318
    Width = 17
    Height = 17
    TabOrder = 17
  end
  object Edit6: TEdit
    Left = 100
    Top = 66
    Width = 49
    Height = 21
    TabOrder = 18
    Text = '2.0'
  end
  object CheckBox13: TCheckBox
    Left = 168
    Top = 68
    Width = 17
    Height = 17
    TabOrder = 19
  end
  object Button7: TButton
    Left = 200
    Top = 352
    Width = 177
    Height = 25
    Caption = 'Reverse the order of all keyframes'
    TabOrder = 20
    OnClick = Button7Click
  end
  object CheckBox14: TCheckBox
    Left = 208
    Top = 173
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual hard shadow setting'
    TabOrder = 21
  end
  object CheckBox16: TCheckBox
    Left = 208
    Top = 245
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual DOF parameters'
    TabOrder = 22
  end
  object Edit7: TEdit
    Left = 100
    Top = 140
    Width = 49
    Height = 21
    Hint = 
      'The distance estimates are downscaled by this factor to avoid ov' +
      'erstepping.'#13#10'Reduce the value if overstepping occurs (black pixe' +
      'ls, noisy image).'#13#10'Too low values slows the rendering down .'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    Text = '0.4'
  end
  object CheckBox3: TCheckBox
    Left = 208
    Top = 197
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual ambient shadow par.'
    TabOrder = 24
  end
  object CheckBox15: TCheckBox
    Left = 168
    Top = 251
    Width = 17
    Height = 17
    TabOrder = 25
  end
  object CheckBox17: TCheckBox
    Left = 32
    Top = 251
    Width = 117
    Height = 17
    Alignment = taLeftJustify
    Caption = 'First step random:'
    TabOrder = 26
  end
  object CheckBox18: TCheckBox
    Left = 208
    Top = 269
    Width = 153
    Height = 17
    Hint = 'including dFog on its or Vol.light options'
    Alignment = taLeftJustify
    Caption = 'Actual '#39'Coloring'#39' tab  options'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 27
  end
  object CheckBox19: TCheckBox
    Left = 208
    Top = 293
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual stereo parameters'
    TabOrder = 28
  end
  object CheckBox20: TCheckBox
    Left = 208
    Top = 317
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual camera settings'
    TabOrder = 29
  end
  object CheckBox7: TCheckBox
    Left = 168
    Top = 171
    Width = 17
    Height = 17
    TabOrder = 30
  end
  object Edit2: TEdit
    Left = 100
    Top = 169
    Width = 49
    Height = 21
    Hint = 
      'The distance estimates are downscaled by this factor to avoid ov' +
      'erstepping.'#13#10'Reduce the value if overstepping occurs (black pixe' +
      'ls, noisy image).'#13#10'Too low values slows the rendering down .'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 31
    Text = '1.0'
  end
  object CheckBox9: TCheckBox
    Left = 208
    Top = 221
    Width = 153
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Actual reflections settings'
    TabOrder = 32
  end
  object CheckBox10: TCheckBox
    Left = 32
    Top = 360
    Width = 117
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Normals on ZBuffer:'
    TabOrder = 33
  end
  object CheckBox21: TCheckBox
    Left = 168
    Top = 360
    Width = 17
    Height = 17
    TabOrder = 34
  end
  object Edit21: TEdit
    Left = 100
    Top = 197
    Width = 30
    Height = 21
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 35
    Text = '8'
  end
  object UpDown3: TUpDown
    Left = 130
    Top = 197
    Width = 19
    Height = 21
    Associate = Edit21
    Max = 31
    Position = 8
    TabOrder = 36
  end
  object UpDown1: TUpDown
    Left = 130
    Top = 226
    Width = 19
    Height = 21
    Associate = Edit3
    Max = 8
    Position = 2
    TabOrder = 37
  end
  object Edit3: TEdit
    Left = 100
    Top = 226
    Width = 30
    Height = 21
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 38
    Text = '2'
  end
end
