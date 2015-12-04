object PostProForm: TPostProForm
  Left = 844
  Top = 100
  BorderStyle = bsDialog
  Caption = 'Post processing'
  ClientHeight = 1247
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnHide = FormHide
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object NormalsOnZBufferBtn: TSpeedButton
    Left = 0
    Top = 122
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 2
    Caption = ' Normals on Z-buffer'
    ParentShowHint = False
    ShowHint = True
    OnClick = NormalsOnZBufferBtnClick
    ExplicitTop = 8
  end
  object HardShadowsBtn: TSpeedButton
    Left = 0
    Top = 208
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 3
    Caption = ' Hard Shadows'
    ParentShowHint = False
    ShowHint = True
    OnClick = HardShadowsBtnClick
    ExplicitLeft = 8
  end
  object AmbientShadowsBtn: TSpeedButton
    Left = 0
    Top = 422
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 4
    Caption = ' Ambient Shadows'
    ParentShowHint = False
    ShowHint = True
    OnClick = AmbientShadowsBtnClick
    ExplicitLeft = 21
    ExplicitTop = 431
  end
  object ReflTransparencyBtn: TSpeedButton
    Left = 0
    Top = 658
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 5
    Caption = ' Reflections + Transparency'
    ParentShowHint = False
    ShowHint = True
    OnClick = ReflTransparencyBtnClick
    ExplicitLeft = 8
    ExplicitTop = 679
  end
  object DepthOfFieldBtn: TSpeedButton
    Left = 0
    Top = 891
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 6
    Caption = ' Depth of Field'
    ParentShowHint = False
    ShowHint = True
    OnClick = DepthOfFieldBtnClick
    ExplicitLeft = 8
    ExplicitTop = 897
  end
  object RecalcSectionBtn: TSpeedButton
    Left = 0
    Top = 0
    Width = 255
    Height = 21
    Hint = 'Click to hide/show'
    Align = alTop
    AllowAllUp = True
    GroupIndex = 1
    Caption = ' Recalculate a Selection'
    ParentShowHint = False
    ShowHint = True
    OnClick = RecalcSectionBtnClick
    ExplicitLeft = -8
    ExplicitTop = -1
  end
  object PostProcessHintPnl: TPanel
    Left = 0
    Top = 613
    Width = 255
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 255
      Height = 45
      Margins.Left = 2
      Margins.Top = 1
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alClient
      Caption = 
        'Caution:  The processings below must be calculated'#13#10'from top to ' +
        'bottom and light changes will reset'#13#10'these calculations!'
      ExplicitWidth = 246
      ExplicitHeight = 39
    end
    object Button16: TButton
      Left = 180
      Top = 27
      Width = 67
      Height = 17
      Hint = 'Resets the DoF effect and the reflections.'
      Caption = 'Reset now'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button16Click
    end
  end
  object RecalcSectionPnl: TPanel
    Left = 0
    Top = 21
    Width = 255
    Height = 101
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    Visible = False
    object Label4: TLabel
      Left = 65
      Top = 49
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = 'Raystep divisor:'
    end
    object Button13: TButton
      Left = 83
      Top = 76
      Width = 67
      Height = 21
      Hint = 
        'Make an image selection with the mouse then recalculate this sel' +
        'ection'#13#10'with the current parameters.'#13#10'The hardshadows and the DE' +
        'AO will also be calculated if selected, but'#13#10'other ambient shado' +
        'ws must be recalculated again for the whole image.'#13#10'Also "normal' +
        's on Zbuffer" has to be recalculated, if calculated before.'
      Caption = 'Calculate'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button13Click
    end
    object CheckBox19: TCheckBox
      Left = 31
      Top = 7
      Width = 131
      Height = 17
      Hint = 'To reduce overstepping'
      Alignment = taLeftJustify
      Caption = 'Keep only nearer parts:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
    end
    object CheckBox21: TCheckBox
      Tag = 1
      Left = 12
      Top = 78
      Width = 58
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Enable'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = CheckBox21Click
    end
    object CheckBox30: TCheckBox
      Left = 6
      Top = 26
      Width = 156
      Height = 17
      Hint = 'Helpful if you want to redo an unwanted drawing for example.'
      Alignment = taLeftJustify
      Caption = 'Don'#39't change AmbSh+dFog:'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object Edit12: TEdit
      Left = 149
      Top = 46
      Width = 30
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 4
      Text = '1'
    end
    object UpDown4: TUpDown
      Left = 179
      Top = 46
      Width = 16
      Height = 21
      Associate = Edit12
      Min = 1
      Max = 99
      Position = 1
      TabOrder = 5
    end
  end
  object NormalsOnZBufferPnl: TPanel
    Left = 0
    Top = 143
    Width = 255
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    Visible = False
    object Label7: TLabel
      Left = 106
      Top = 34
      Width = 133
      Height = 26
      AutoSize = False
      Caption = 'Warning: Must recalculate the whole image to undo it!'
      WordWrap = True
    end
    object Button14: TButton
      Left = 12
      Top = 37
      Width = 83
      Height = 21
      Hint = 
        'Use only as second option if the normals (the surface direction ' +
        'for lighting) seems to be crappy.'
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button14Click
    end
    object CheckBox23: TCheckBox
      Tag = 2
      Left = 27
      Top = 9
      Width = 191
      Height = 17
      Caption = 'Do this function automatically'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = CheckBox23Click
    end
  end
  object HardShadowsPnl: TPanel
    Left = 0
    Top = 229
    Width = 255
    Height = 193
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    Visible = False
    object Label6: TLabel
      Left = 29
      Top = 117
      Width = 36
      Height = 13
      Caption = 'Radius:'
    end
    object Label8: TLabel
      Left = 11
      Top = 37
      Width = 84
      Height = 13
      Caption = 'Max. length calc.:'
    end
    object Button3: TButton
      Left = 12
      Top = 170
      Width = 83
      Height = 21
      Hint = 
        'Push the button to calculate the hardshadows from the selected l' +
        'ights.'#13#10'Once calculated, the hardshadow must not be calculated a' +
        'gain,'#13#10'unless the angle or the position of the light was changed' +
        '.'
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Tag = 1
      Left = 185
      Top = 34
      Width = 41
      Height = 16
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button5: TButton
      Tag = 2
      Left = 185
      Top = 57
      Width = 41
      Height = 17
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button6: TButton
      Tag = 3
      Left = 185
      Top = 80
      Width = 41
      Height = 17
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button7: TButton
      Tag = 4
      Left = 185
      Top = 103
      Width = 41
      Height = 17
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = Button4Click
    end
    object Button8: TButton
      Tag = 5
      Left = 185
      Top = 126
      Width = 41
      Height = 17
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = Button4Click
    end
    object Button9: TButton
      Tag = 6
      Left = 185
      Top = 149
      Width = 41
      Height = 17
      Hint = 'Resets a previous calculation of this lights hard shadow.'
      Caption = 'reset'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = Button4Click
    end
    object CheckBox10: TCheckBox
      Left = 125
      Top = 174
      Width = 122
      Height = 17
      Hint = 
        'Sets automatically the correspondending light function to cosine' +
        ','#13#10'when the shadow is calculated.'#13#10'The cosine and the quadratic ' +
        'cosine function works well with the shadow.'
      Caption = 'Set lightfunc to cosine'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 7
    end
    object CheckBox2: TCheckBox
      Left = 125
      Top = 34
      Width = 54
      Height = 17
      Caption = 'Light 1'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = CheckBox2Click
    end
    object CheckBox29: TCheckBox
      Left = 12
      Top = 94
      Width = 72
      Height = 17
      Hint = 'To calculate a better hard shadow, only if 1 HS selected!'
      Caption = 'Softer H.S.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object CheckBox3: TCheckBox
      Left = 125
      Top = 57
      Width = 54
      Height = 17
      Caption = 'Light 2'
      TabOrder = 10
      OnClick = CheckBox2Click
    end
    object CheckBox4: TCheckBox
      Left = 125
      Top = 80
      Width = 54
      Height = 17
      Caption = 'Light 3'
      TabOrder = 11
      OnClick = CheckBox2Click
    end
    object CheckBox5: TCheckBox
      Left = 125
      Top = 103
      Width = 54
      Height = 17
      Caption = 'Light 4'
      TabOrder = 12
      OnClick = CheckBox2Click
    end
    object CheckBox6: TCheckBox
      Left = 125
      Top = 126
      Width = 54
      Height = 17
      Caption = 'Light 5'
      TabOrder = 13
      OnClick = CheckBox2Click
    end
    object CheckBox7: TCheckBox
      Left = 125
      Top = 149
      Width = 54
      Height = 17
      Caption = 'Light 6'
      TabOrder = 14
      OnClick = CheckBox2Click
    end
    object CheckBox9: TCheckBox
      Tag = 3
      Left = 26
      Top = 6
      Width = 182
      Height = 17
      Hint = 
        'If enabled, the choosen hard shadows will be calculated'#13#10'automat' +
        'ically after the main rendering.'#13#10'Choose the options before.'
      Caption = 'Calculate H.S. automatically'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      OnClick = CheckBox9Click
    end
    object Edit5: TEdit
      Left = 29
      Top = 56
      Width = 31
      Height = 21
      Hint = 
        'A multiplier that defines the miximal length of the hard shadow ' +
        'calculation,'#13#10'relative to some image size parameters (default = ' +
        '1).'#13#10'Increase the value if shadows of far objects are missing.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Text = '1.0'
    end
    object Edit7: TEdit
      Left = 29
      Top = 133
      Width = 31
      Height = 21
      Hint = 'Bigger radius means softer shadows'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      Text = '1.0'
    end
  end
  object AmbientShadowsPnl: TPanel
    Left = 0
    Top = 443
    Width = 255
    Height = 170
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    Visible = False
    object Label24: TLabel
      Left = 215
      Top = 15
      Width = 20
      Height = 20
      Hint = 
        'SSAO15:    Ambient shadow based on the ZBuffer.'#13#10'SSAO24:    Uses' +
        ' 24 bits of the ZBuffer.'#13#10'SSAO24r:   Uses random distributions f' +
        'or less artifacts.'#13#10'DEAO:        Ambient shadow based on distanc' +
        'e estimates'#13#10'(advanced in animations)'
      Alignment = taCenter
      AutoSize = False
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object Button10: TButton
      Left = 11
      Top = 142
      Width = 83
      Height = 21
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = Button10Click
    end
    object CheckBox11: TCheckBox
      Tag = 4
      Left = 27
      Top = 9
      Width = 182
      Height = 17
      Hint = 
        'If enabled, the ambient shadows will be calculated'#13#10'automaticall' +
        'y after the main rendering.'#13#10'Choose the options before.'
      Caption = 'Calculate A.S. automatically'
      Checked = True
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
      OnClick = CheckBox11Click
    end
    object TabControl1: TTabControl
      Left = 1
      Top = 32
      Width = 245
      Height = 106
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Tabs.Strings = (
        'SSAO15'
        'SSAO24'
        'SSAO24r'
        'DEAO')
      TabIndex = 1
      OnChange = RadioGroup3Click
      object Label14: TLabel
        Left = 10
        Top = 76
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = 'Calculation count:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object Label15: TLabel
        Left = 25
        Top = 74
        Width = 29
        Height = 13
        Caption = 'MaxL:'
        Visible = False
      end
      object Label16: TLabel
        Left = 97
        Top = 71
        Width = 27
        Height = 13
        Caption = 'Rays:'
        Visible = False
      end
      object Label17: TLabel
        Left = 127
        Top = 71
        Width = 6
        Height = 13
        Alignment = taCenter
        Caption = '7'
        Visible = False
      end
      object Label20: TLabel
        Left = 38
        Top = 31
        Width = 55
        Height = 13
        Alignment = taRightJustify
        Caption = 'Border size:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label50: TLabel
        Left = 20
        Top = 53
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Z/R Threshold:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CheckBox12: TCheckBox
        Left = 142
        Top = 51
        Width = 90
        Height = 17
        Hint = 
          'Let the threshold decrease the ambient shadow down to 0.'#13#10'Far st' +
          'ructures are less affected by nearer structures.'
        Alignment = taLeftJustify
        Caption = 'Threshold to 0:'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object CheckBox22: TCheckBox
        Left = 154
        Top = 30
        Width = 68
        Height = 33
        Hint = 
          'First step random:'#13#10'To avoid spotty artifacts on fomulas with ba' +
          'd DE'#39's.'#13#10'For lower noise, use it with image downscaling and/or h' +
          'igher raycounts.'#13#10'Can be used also together with dithering.'
        Alignment = taLeftJustify
        Caption = 'First Step Random:'
        Color = clBtnFace
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Visible = False
        WordWrap = True
      end
      object Edit21: TEdit
        Left = 99
        Top = 73
        Width = 36
        Height = 21
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        Text = '1'
        Visible = False
      end
      object Edit34: TEdit
        Left = 99
        Top = 50
        Width = 36
        Height = 21
        Hint = 
          'Defines up to which angle the shadowing will be calculated.'#13#10'Low' +
          'er values: Far structures are less affected by near structures,'#13 +
          #10'this is advanced when the structures got lots of holes.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = '2.00'
      end
      object Edit8: TEdit
        Left = 59
        Top = 67
        Width = 29
        Height = 21
        Hint = 
          'Scales the maximum length of the ambient rays to be calculated.'#13 +
          #10'Use a value bigger than 1 to give more depth to the shadows,'#13#10'v' +
          'alues below 1 gives more local shadows.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = '1.0'
        Visible = False
      end
      object Edit9: TEdit
        Left = 99
        Top = 28
        Width = 36
        Height = 21
        Hint = 
          'The calculation will be extended towards the outside the image w' +
          'ith reflected objects.'#13#10'This might lead to less artifacts in ani' +
          'mations, but stills can profit from it too.'#13#10'Value should be in ' +
          'the range of 0 to 0.5 (max 0.9), it is the size relative to the ' +
          'image'#13#10'width and height that is maximal calculated on the outsid' +
          'e.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Text = '0.0'
      end
      object RadioGroup5: TRadioGroup
        Left = 12
        Top = 27
        Width = 127
        Height = 33
        Hint = 
          'Option to dither the angle of rays for an image scaling of 1:2 o' +
          'r 1:3.'#13#10'This leads to more precision and less spotty artifacts.'#13 +
          #10'Caution: use only on the same image scaling, else you get dithe' +
          'r artifacts.'
        Caption = 'Dithering for scale:'
        Color = clBtnFace
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          'no'
          '1:2'
          '1:3')
        ParentBackground = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Visible = False
      end
      object UpDown1: TUpDown
        Left = 143
        Top = 66
        Width = 18
        Height = 24
        Hint = 
          'Number of rays that will be calculated.'#13#10'The more the better but' +
          ' slower, of course.'
        Max = 3
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 7
        Visible = False
        OnChangingEx = UpDown1ChangingEx
      end
      object UpDown3: TUpDown
        Left = 135
        Top = 73
        Width = 16
        Height = 21
        Hint = 'Calculate n times to reduce noise by averaging'
        Associate = Edit21
        Min = 1
        Max = 9
        ParentShowHint = False
        Position = 1
        ShowHint = True
        TabOrder = 8
        Visible = False
      end
    end
  end
  object ReflTransparencyPnl: TPanel
    Left = 0
    Top = 679
    Width = 255
    Height = 212
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    Visible = False
    object Label11: TLabel
      Left = 134
      Top = 39
      Width = 32
      Height = 13
      Alignment = taRightJustify
      Caption = 'Depth:'
    end
    object Label12: TLabel
      Left = 29
      Top = 39
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'Amount:'
    end
    object Label21: TLabel
      Left = 113
      Top = 91
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Absorption:'
    end
    object Label22: TLabel
      Left = 86
      Top = 115
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'Refractive index:'
    end
    object Label23: TLabel
      Left = 91
      Top = 139
      Width = 75
      Height = 13
      Alignment = taRightJustify
      Caption = 'Light scattering:'
    end
    object Button15: TButton
      Tag = 1
      Left = 11
      Top = 182
      Width = 83
      Height = 21
      Hint = 
        'Make sure that the '#39'Calc... automatic.'#39' options for the hard'#13#10'an' +
        'd ambient shadows are set, if you wish to consider them.'
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button11Click
    end
    object CheckBox24: TCheckBox
      Tag = 5
      Left = 27
      Top = 9
      Width = 204
      Height = 17
      Hint = 
        'If enabled, the reflections will be calculated automatically aft' +
        'er the'#13#10'previous calculations.'#13#10'Keep in mind that light changing' +
        's afterwards will reset this calculation!'
      Caption = 'Calculate R. (+ T.) automatically'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckBox24Click
    end
    object CheckBox25: TCheckBox
      Left = 12
      Top = 162
      Width = 207
      Height = 17
      Hint = 
        'Option to calculate only a part of the image for a faster previe' +
        'w.'#13#10'Make a selection in the image with the mouse before calculat' +
        'ing.'
      Caption = 'Calculate only a selection in the image'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = CheckBox25Click
    end
    object CheckBox27: TCheckBox
      Left = 12
      Top = 66
      Width = 135
      Height = 17
      Hint = 
        'If enabled the specular amount is split into inside going ray an' +
        'd reflection.'
      Caption = 'Calculate transparency:'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
    object CheckBox28: TCheckBox
      Left = 12
      Top = 89
      Width = 66
      Height = 17
      Hint = 
        'Calculate transparency only on dIFS formulas (for DE combination' +
        's with escapetimes)'
      Caption = 'Only dIFS'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object Edit11: TEdit
      Left = 171
      Top = 36
      Width = 30
      Height = 21
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 5
      Text = '2'
    end
    object Edit13: TEdit
      Left = 171
      Top = 88
      Width = 52
      Height = 21
      Hint = 
        'Absolute absorption amount inside the material (high zooms need ' +
        'big values). The diffuse object color is also for inside.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = '0.2'
    end
    object Edit14: TEdit
      Left = 171
      Top = 112
      Width = 52
      Height = 21
      Hint = 
        'Refractive index of the material, air~1 water~1.33 glass~1.5 dia' +
        'mond~2.4'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '1.5'
    end
    object Edit17: TEdit
      Left = 171
      Top = 136
      Width = 52
      Height = 21
      Hint = 'Light scattering inside the material'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Text = '1.0'
    end
    object Edit6: TEdit
      Left = 73
      Top = 36
      Width = 37
      Height = 21
      Hint = 
        'Total amount of reflectivity + transparency, it will be multipli' +
        'ed with the local object specular color + transparency amount.'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      Text = '1.0'
    end
    object UpDown2: TUpDown
      Left = 201
      Top = 36
      Width = 16
      Height = 21
      Associate = Edit11
      Min = 1
      Max = 30
      Position = 2
      TabOrder = 10
    end
  end
  object DepthOfFieldPnl: TPanel
    Left = 0
    Top = 912
    Width = 255
    Height = 203
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 9
    Visible = False
    object Label1: TLabel
      Left = 30
      Top = 37
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z1 sharp:'
    end
    object Label18: TLabel
      Left = 106
      Top = 157
      Width = 115
      Height = 39
      Caption = 'The effect accumulates, reset for a new calculation.'
      WordWrap = True
    end
    object Label19: TLabel
      Left = 29
      Top = 62
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Z2 sharp:'
    end
    object Label2: TLabel
      Left = 138
      Top = 91
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'ClippingR:'
    end
    object Label5: TLabel
      Left = 33
      Top = 91
      Width = 43
      Height = 13
      Alignment = taRightJustify
      Caption = 'Aperture:'
    end
    object Button1: TButton
      Left = 11
      Top = 160
      Width = 83
      Height = 21
      Hint = 
        'This effect is accumulated on each button press, you can reset b' +
        'y pressing'#13#10'the '#39'Reset'#39' button - but reflections would also be u' +
        'ndone!'
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button18: TButton
      Tag = 10
      Left = 154
      Top = 59
      Width = 85
      Height = 21
      Hint = 
        'Press button and afterwards the object part'#13#10'in the image, that ' +
        'should be sharp.'
      Caption = 'Get Z2'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button19: TButton
      Left = 4
      Top = 60
      Width = 18
      Height = 17
      Hint = 'Copy Z1 to Z2 to get a focus point'
      Caption = '->'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = Button19Click
    end
    object Button2: TButton
      Tag = 1
      Left = 154
      Top = 34
      Width = 85
      Height = 21
      Hint = 
        'Press button and afterwards the object part'#13#10'in the image, that ' +
        'should be sharp.'
      Caption = 'Get Z1'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = Button2Click
    end
    object CheckBox1: TCheckBox
      Tag = 6
      Left = 27
      Top = 9
      Width = 182
      Height = 17
      Hint = 
        'If enabled, the DoF effect will be calculated'#13#10'automatically aft' +
        'er the previous calculations.'#13#10'Choose the options before.'
      Caption = 'Calculate DoF automatically'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      OnClick = CheckBox1Click
    end
    object Edit1: TEdit
      Left = 81
      Top = 34
      Width = 62
      Height = 21
      Hint = 
        'The (first) focus point.'#13#10'The value is relative to the viewers Z' +
        'start value,'#13#10'normalized to the imagewidth.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '0.0'
    end
    object Edit10: TEdit
      Left = 81
      Top = 59
      Width = 62
      Height = 21
      Hint = 
        'Second focus point, if different from the first one'#13#10'you get a f' +
        'ocus line instead of a focus point.'#13#10'(physically not very realis' +
        'tic, but good to have) '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Text = '0.0'
    end
    object Edit2: TEdit
      Left = 190
      Top = 88
      Width = 49
      Height = 21
      Hint = 
        'The blur radius will be limited at this value.'#13#10'Can speedup rend' +
        'ering when the radius becomes very huge in some image parts.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Text = '25.0'
    end
    object Edit3: TEdit
      Left = 81
      Top = 88
      Width = 50
      Height = 21
      Hint = 
        'The aperture on the Zsharp point, it is not the aperture from th' +
        'e camera!'#13#10'Multply this value with the (free choosen) distance f' +
        'rom the Zsharp point'#13#10'to the camera and divide it by the focal l' +
        'ength of the cameras lense to get'#13#10'the cameras aperture.'#13#10'So dow' +
        'nscale this value if you don'#39't expect the cameras size that big.' +
        #13#10'Larger values means more blur.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Text = '0.02'
    end
    object RadioGroup1: TRadioGroup
      Left = 141
      Top = 114
      Width = 101
      Height = 37
      Hint = 
        '2 or 3 passes gives a better strong bluring in front of the focu' +
        's point.'#13#10'1 pass leads to a disc bokey, more passes yields to a ' +
        'gaussian like bokey.'
      Caption = 'Passes'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        '1'
        '2'
        '3')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
    end
    object RadioGroup2: TRadioGroup
      Left = 7
      Top = 114
      Width = 129
      Height = 37
      Hint = 
        'Sorted calculation gives better results.'#13#10'Forward may be an opti' +
        'on if Sorted is failing because of memory problems or so.'
      Caption = 'Calculation'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Sorted'
        'Forward')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
    end
  end
  object GroupBox4: TGroupBox
    Left = 125
    Top = 1139
    Width = 449
    Height = 65
    Caption = 'LIGHT STROKES'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    object CheckBox13: TCheckBox
      Left = 106
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light1'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox14: TCheckBox
      Left = 162
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light2'
      TabOrder = 1
    end
    object CheckBox15: TCheckBox
      Left = 218
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light3'
      TabOrder = 2
    end
    object CheckBox16: TCheckBox
      Left = 274
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light4'
      TabOrder = 3
    end
    object CheckBox17: TCheckBox
      Left = 330
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light5'
      TabOrder = 4
    end
    object CheckBox18: TCheckBox
      Left = 386
      Top = 39
      Width = 49
      Height = 17
      Caption = 'Light6'
      TabOrder = 5
    end
    object Button17: TButton
      Left = 12
      Top = 16
      Width = 83
      Height = 21
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 6
      OnClick = Button17Click
    end
    object CheckBox20: TCheckBox
      Left = 121
      Top = 11
      Width = 272
      Height = 17
      Caption = 'Calculate random light strokes automatically'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 7
      OnClick = CheckBox9Click
    end
    object Edit4: TEdit
      Left = 8
      Top = 41
      Width = 89
      Height = 21
      TabOrder = 8
      Text = '3765724374'
    end
  end
  object GroupBox10: TGroupBox
    Left = 56
    Top = 1150
    Width = 449
    Height = 42
    Caption = 'Ambient light'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    object Shape6: TShape
      Left = 148
      Top = 11
      Width = 142
      Height = 18
      Brush.Style = bsClear
      Pen.Style = psClear
      Pen.Width = 0
    end
    object Button20: TButton
      Tag = 1
      Left = 12
      Top = 16
      Width = 83
      Height = 21
      Caption = 'Calculate now'
      TabOrder = 0
      OnClick = Button20Click
    end
    object CheckBox26: TCheckBox
      Tag = 6
      Left = 154
      Top = 11
      Width = 131
      Height = 17
      Hint = 
        'If enabled, the reflections will be calculated automatically aft' +
        'er the'#13#10'previous calculations.'#13#10'Keep in mind that light changing' +
        's afterwards will reset this calculation!'
      Caption = 'Calc. R. automatic.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckBox9Click
    end
  end
  object GroupBox6: TGroupBox
    Left = 21
    Top = 1150
    Width = 351
    Height = 42
    Caption = 'DOUBLE IMAGESIZE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Visible = False
    object Button12: TButton
      Left = 12
      Top = 16
      Width = 83
      Height = 21
      Caption = 'Calculate now'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = Button12Click
    end
    object CheckBox8: TCheckBox
      Left = 121
      Top = 15
      Width = 222
      Height = 17
      Caption = 'Double the imagesize automatically'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = CheckBox9Click
    end
  end
  object ImageList1: TImageList
    Masked = False
    Width = 32
    Left = 8
    Top = 40
    Bitmap = {
      494C010108000E00140020001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000003000000001002000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001F9A1D000C9B0A000F990C00299527000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001F9A1D000C9B0A000F990C00299527000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001AA3180007AB050007AC050007AA050007A6050007A10400079B
      0400349332000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001AA3180007AB050007AC050007AA050007A6050007A10400079B
      0400349332000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001BAA190007B9050008BD050008BD050007BA050007B4050007AD050007A5
      0500079D04003E933C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001BAA190007B9050008BD050008BD050007BA050007B4050007AD050007A5
      0500079D04003E933C0000000000000000000000000000000000000000000000
      0000808080008080800000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008C3050008CC060008CE060008CD060008C9060008C2060007BA050007B0
      050007A60500079C050000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008C3050008CC060008CE060008CD060008C9060008C2060007BA050007B0
      050007A60500079C050000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000808080000000
      00000000000000000000000000000000000000000000000000000000000022B9
      200008D5060009DD070009DF070009DC070009D7060008D0060008C6060008BB
      050007AF050007A304004A934900000000000000000000000000000000000000
      0000000000000000000080808000808080000000000080808000808080000000
      00000000000000000000000000000000000000000000000000000000000022B9
      200008D5060009DD070009DF070009DC070009D7060008D0060008C6060008BB
      050007AF050007A304004A934900000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000CCE
      0A0009E4070009EB070009ED070009EA070009E5070009DC070008D2060008C5
      060007B8050007A9050035973300000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000CCE
      0A0009E4070009EB070009ED070009EA070009E5070009DC070008D2060008C5
      060007B8050007A9050035973300000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000008080800000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000ED7
      0C0009EF07000AF708000AF908000AF6080009F0070009E7070009DC070008CE
      060008BF050007AE050036983500000000000000000000000000000000000000
      0000000000008080800000000000000000008080800000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000ED7
      0C0009EF07000AF708000AF908000AF6080009F0070009E7070009DC070008CE
      060008BF050007AE050036983500000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000000000000808080008080
      80000000000000000000000000000000000000000000000000000000000028CD
      26000AF708000AFE08000AFE08000AFE08000AF9080009F0070009E3070008D5
      060008C4060007B105004F964E00000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      00000000000000000000000000000000000000000000000000000000000028CD
      26000AF708000AFE08000AFE08000AFE08000AF9080009F0070009E3070008D5
      060008C4060007B105004F964E00000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000009F707000AFF08000BFF08000AFF08000AFE08000AF5080009E8070009D8
      060008C606000AAF080000000000000000000000000000000000000000000000
      0000000000000000000080808000808080000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      000009F707000AFF08000BFF08000AFF08000AFE08000AF5080009E8070009D8
      060008C606000AAF080000000000000000000000000000000000000000000000
      0000808080008080800000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000026D925000AFE08000AFF08000AFF08000AFE08000AF6080009E8070008D7
      060008C205004B9D4A0000000000000000000000000000000000000000000000
      0000000000008080800080808000000000000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      000026D925000AFE08000AFF08000AFF08000AFE08000AF6080009E8070008D7
      060008C205004B9D4A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000029D927000AFB07000AFD08000AFA080009F0070009E1070009CD
      070046A445000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000029D927000AFB07000AFD08000AFA080009F0070009E1070009CD
      070046A445000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000032CE310020D81E0022CE20003CB63B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000032CE310020D81E0022CE20003CB63B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001F9A1D000C9B0A000F990C00299527000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000001F9A1D000C9B0A000F990C00299527000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001AA3180007AB050007AC050007AA050007A6050007A10400079B
      0400349332000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000001AA3180007AB050007AC050007AA050007A6050007A10400079B
      0400349332000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001BAA190007B9050008BD050008BD050007BA050007B4050007AD050007A5
      0500079D04003E933C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00001BAA190007B9050008BD050008BD050007BA050007B4050007AD050007A5
      0500079D04003E933C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008C3050008CC060008CE060008CD060008C9060008C2060007BA050007B0
      050007A60500079C050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000008C3050008CC060008CE060008CD060008C9060008C2060007BA050007B0
      050007A60500079C050000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000022B9
      200008D5060009DD070009DF070009DC070009D7060008D0060008C6060008BB
      050007AF050007A304004A934900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000022B9
      200008D5060009DD070009DF070009DC070009D7060008D0060008C6060008BB
      050007AF050007A304004A934900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000CCE
      0A0009E4070009EB070009ED070009EA070009E5070009DC070008D2060008C5
      060007B8050007A9050035973300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000CCE
      0A0009E4070009EB070009ED070009EA070009E5070009DC070008D2060008C5
      060007B8050007A9050035973300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000ED7
      0C0009EF07000AF708000AF908000AF6080009F0070009E7070009DC070008CE
      060008BF050007AE050036983500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000ED7
      0C0009EF07000AF708000AF908000AF6080009F0070009E7070009DC070008CE
      060008BF050007AE050036983500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000028CD
      26000AF708000AFE08000AFE08000AFE08000AF9080009F0070009E3070008D5
      060008C4060007B105004F964E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000028CD
      26000AF708000AFE08000AFE08000AFE08000AF9080009F0070009E3070008D5
      060008C4060007B105004F964E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000009F707000AFF08000BFF08000AFF08000AFE08000AF5080009E8070009D8
      060008C606000AAF080000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000009F707000AFF08000BFF08000AFF08000AFE08000AF5080009E8070009D8
      060008C606000AAF080000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000026D925000AFE08000AFF08000AFF08000AFE08000AF6080009E8070008D7
      060008C205004B9D4A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000026D925000AFE08000AFF08000AFF08000AFE08000AF6080009E8070008D7
      060008C205004B9D4A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000029D927000AFB07000AFD08000AFA080009F0070009E1070009CD
      070046A445000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000029D927000AFB07000AFD08000AFA080009F0070009E1070009CD
      070046A445000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000032CE310020D81E0022CE20003CB63B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000032CE310020D81E0022CE20003CB63B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000300000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFE1FFFFFFE1FFFFFFFFFFFFFFFFFFFFFF807FFFFF807
      FFFFFFFFFF7FFFFFFFFFF003FF7FF003F33FFFFFFE3FFFFFF33FF003FE3FF003
      F99FFFFFFC9FFFFFF99FE001FC9FE001FCCFFFFFF9CFFFFFFCCFE001F9CFE001
      FE67FFFFFB6FFFFFFE67E001FB6FE001FCCFFFFFFE3FFFFFFCCFE001FE3FE001
      F99FFFFFFC9FFFFFF99FF003FC9FF003F33FFFFFF9CFFFFFF33FF003F9CFF003
      FFFFFFFFFBEFFFFFFFFFF807FBEFF807FFFFFFFFFFFFFFFFFFFFFE1FFFFFFE1F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFE1FFFFFFE1FFFFFFFFFFFFFFFFFFFFFF807FFFFF807
      FFFFFFFFFF7FFFFFFFFFF003FF7FF003F33FFFFFFE3FFFFFF33FF003FE3FF003
      F99FFFFFFC9FFFFFF99FE001FC9FE001FCCFFFFFF9CFFFFFFCCFE001F9CFE001
      FE67FFFFFB6FFFFFFE67E001FB6FE001FCCFFFFFFE3FFFFFFCCFE001FE3FE001
      F99FFFFFFC9FFFFFF99FF003FC9FF003F33FFFFFF9CFFFFFF33FF003F9CFF003
      FFFFFFFFFBEFFFFFFFFFF807FBEFF807FFFFFFFFFFFFFFFFFFFFFE1FFFFFFE1F
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
