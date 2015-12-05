object LightAdjustForm: TLightAdjustForm
  Left = 844
  Top = 100
  BorderStyle = bsDialog
  Caption = 'Lighting'
  ClientHeight = 625
  ClientWidth = 233
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 0
    Top = 521
    Width = 233
    Height = 104
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton13: TSpeedButton
      Left = 8
      Top = 69
      Width = 28
      Height = 30
      Hint = 'Open full light and color parameter'
      Glyph.Data = {
        16060000424D1606000000000000360400002800000012000000180000000100
        080000000000E0010000C30E0000C30E00000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A60000000000357C62007C8B1400758B1F006D8D2C00738D25003B917C005B89
        43004C8755004E895E0053935E0048936D0053966000439478008F8D0500878B
        0900898B09000177A1000077B200007CC10018809A00358F84000B80AB000384
        B2000584B8000D87BB000B8BBA001B93BF002AA1BF00018FCA00008BCE00148F
        C3001493C7001094C700169ACC00189ACA000091D6000094D4000094D6000B96
        D000219ECC000BA5E60000A5EC0009A7E8000BABEE0012ADEE0000ABF30000B4
        FF0005B8FF0012BFFF0005C1FF0001C7FF0000ECFF0019E7F90000F1FF0000FF
        FF0080FFFF00C6C6C6001400140058871B0018000000E401000060EE12004000
        00000000000000000000A8EE120068EE12000000000000000000000000000000
        000000000000000000000000000040000000ACEE120020E99100000000000200
        000001000000E401000060EE1200E401000060149200F8D62200D8D622000000
        00000000000090EC01008F00000004EC120020E99100C0EC12007C94370011A9
        000011A90000D4EC12001E9437005044AF0011A9000000000000ECEC1200E294
        37005044AF003D150F00F057E200B057E2000CED1200824C0F00F057E200A603
        3700B64C0F00F057E20014ED120000000000B8009200105BCE00E0ED12004100
        9200A80714005D00920038EE1200000000003CED120000000000B80092005087
        1B0008EE1200410092004807140058ED120000000000B800920050871B0024EE
        120041009200480714005D00920068EE12000400000000000000020000000000
        0000040000003000000000000000185BCE00D98B360000F0FD00300000000400
        00000000140098EB12005CF69100200000000000000058871B00C4ED12000000
        0000B800920020210B0090EE120041009200380BE2005D009200806A0A002821
        0B000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
        120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
        910060009200FFFFFF005D009200AC04920000001400C800000058871B0048EE
        12008204920058871B00000000009CEE12000EECDA0020ECDA00C8A662000000
        E200D4A66200000000000000000000000000000000000000010019000000D4ED
        120028210B00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
        E20000000000E3C2BF00806A0A0028210B0003000000AA68D30028210B002821
        0B00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
        BF00D595440028210B00A01B6300A01B6300F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00434343434300
        0000434343434343434343430000430043004343434300430043430043430043
        0000430043004343000000430043430043004343000043004300430043430043
        0043430043004343000043004300430043430043000043004300434300004300
        4300434300000043004300434300004300004300434343434343434300434343
        4300434300004300430043434343434300434343434343430000434343434343
        4343434343434343434343430000434343434343434343434343434343434343
        000043430000000000000000000000004343434300004300003F3F3F3F3F3F3F
        3F3F3F3F004343430000430042003F3F3F3F3F3F3F3F3F3F0043434300004300
        42003F3F3F3F3F3F3F3F3F3F3F004343000043004242003F3F3F3F3F3F3F3F3F
        3F004343000043004242003F3F3F3F3F3F3F3F3F3F3F00430000430042424200
        000000003F3F3F3F3F3F00430000430042424242424242420000000000004343
        0000430042424242424242424242420043434343000043004242424242424242
        4242420043434343000043004242424242000000000000434343434300004343
        0000000000434343434343434343434300004343434343434343434343434343
        4343434300004343434343434343434343434343434343430000}
      ParentShowHint = False
      ShowHint = True
      OnClick = Button1Click
    end
    object SpeedButton14: TSpeedButton
      Left = 42
      Top = 69
      Width = 28
      Height = 30
      Hint = 'Save full light and color parameter'
      Glyph.Data = {
        16060000424D1606000000000000360400002800000012000000180000000100
        080000000000E0010000C30E0000C30E00000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A60000000000357C6200FF0000007C8B1400758B1F006D8D2C00738D25003B91
        7C005B8943004C8755004E895E0053935E0048936D0053966000439478008484
        00008F8D0500878B0900898B09000177A1000077B200007CC10018809A00358F
        84000B80AB000384B2000584B8000D87BB000B8BBA001B93BF002AA1BF00018F
        CA00008BCE00148FC3001493C7001094C700169ACC00189ACA000091D6000094
        D4000094D6000B96D000219ECC000BA5E60000A5EC0009A7E8000BABEE0012AD
        EE0000ABF30000B4FF0005B8FF0012BFFF0005C1FF0001C7FF0000ECFF0000F1
        FF0000FFFF0084848400C6C6C600FFFFFF00180000007401000060EE12004000
        00000000000000000000A8EE120068EE12000000000000000000000000000000
        000000000000000000000000000040000000ACEE120020E99100000000000200
        0000010000007401000060EE12007401000060149200C01F1800A01F18000000
        00000000000090EC0100C301000004EC120020E99100C0EC12007C94370011A9
        000011A90000D4EC12001E9437004047AF0011A9000000000000ECEC1200E294
        37004047AF003D150F00F057E200B057E2000CED1200824C0F00F057E2003E03
        5B00B64C0F00F057E20014ED120000000000B8009200A04E2200E0ED12004100
        9200A80714005D00920038EE1200000000003CED120000000000B8009200A851
        220008EE1200410092004807140058ED120000000000B8009200A851220024EE
        120041009200480714005D00920068EE12000400000000000000020000000000
        0000040000003000000000000000A84E2200D98B360000F0FD00300000000400
        00000000140098EB12005CF691002000000000000000B0512200C4ED12000000
        0000B800920020210B0090EE120041009200380BE2005D009200806A0A002821
        0B000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
        120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
        910060009200FFFFFF005D009200AC04920000001400C8000000B051220048EE
        120082049200B0512200000000009CEE12000EECDA0020ECDA00C8A662000000
        E200D4A66200000000000000000000000000000000000000010019000000D4ED
        120028210B00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
        E20000000000E3C2BF00806A0A0028210B0003000000AA68D30028210B002821
        0B00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
        BF00D595440028210B00A01B6300A01B6300F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00444444444400
        0000444444444444444444440000440044004444444400440044440044440044
        0000440044004444000000440044440044004444000044004400440044440044
        0044440044004444000044004400440044440044000044004400444400004400
        4400444400000044004400444400004400004400444444444444444400444444
        4400444400004400440044444444444400444444444444440000444444444444
        4444444444444444444444440000444443000000000000000000000000434444
        00004444000C0C00430C0C454444000C0C00444400004444000C0C00430C0C45
        4444000C0C00444400004444000C0C00444343444444000C0C00444400004444
        000C0C19000000000000190C0C00444400004444000C0C0C0C0C0C0C0C0C0C0C
        0C00444400004444000C190000000000000000190C00444400004444000C0045
        45454545454545000C00444400004444000C004545454545454545000C004444
        00004444000C004545454545454545000C00444400004444000C004545454545
        454545000C004444000044440000004545454545454545000000444400004444
        000C004545454545454545000C00444400004444430000000000000000000000
        0043444400004444444444444444444444444444444444440000}
      ParentShowHint = False
      ShowHint = True
      OnClick = Button2Click
    end
    object SpeedButton15: TSpeedButton
      Tag = 1
      Left = 78
      Top = 2
      Width = 25
      Height = 21
      Hint = 'preset <sand>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton16: TSpeedButton
      Tag = 2
      Left = 103
      Top = 2
      Width = 25
      Height = 21
      Hint = 'preset <slime>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton17: TSpeedButton
      Tag = 3
      Left = 128
      Top = 2
      Width = 25
      Height = 21
      Hint = 'preset <metallic>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton18: TSpeedButton
      Tag = 4
      Left = 153
      Top = 2
      Width = 25
      Height = 21
      Hint = 'preset <flower>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton23: TSpeedButton
      Tag = 9
      Left = 153
      Top = 23
      Width = 25
      Height = 21
      Hint = 'custom preset 4'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton20: TSpeedButton
      Tag = 6
      Left = 78
      Top = 23
      Width = 25
      Height = 21
      Hint = 'custom preset 1'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton21: TSpeedButton
      Tag = 7
      Left = 103
      Top = 23
      Width = 25
      Height = 21
      Hint = 'custom preset 2'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton22: TSpeedButton
      Tag = 8
      Left = 128
      Top = 23
      Width = 25
      Height = 21
      Hint = 'custom preset 3'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButtonMem: TSpeedButton
      Left = 41
      Top = 2
      Width = 27
      Height = 21
      Hint = 
        'Click to save the current light and most color settings'#13#10'on a cu' +
        'stom preset button.'#13#10'Click this button again to cancel saving.'
      AllowAllUp = True
      GroupIndex = 6
      Caption = 'M'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButtonMemClick
    end
    object SpeedButton19: TSpeedButton
      Tag = 5
      Left = 178
      Top = 2
      Width = 25
      Height = 21
      Hint = 'preset <neutral>'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton24: TSpeedButton
      Tag = 10
      Left = 178
      Top = 23
      Width = 25
      Height = 21
      Hint = 'custom preset 5'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton25: TSpeedButton
      Tag = 11
      Left = 78
      Top = 44
      Width = 25
      Height = 21
      Hint = 'custom preset 6'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton26: TSpeedButton
      Tag = 12
      Left = 103
      Top = 44
      Width = 25
      Height = 21
      Hint = 'custom preset 7'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton27: TSpeedButton
      Tag = 13
      Left = 128
      Top = 44
      Width = 25
      Height = 21
      Hint = 'custom preset 8'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton28: TSpeedButton
      Tag = 14
      Left = 153
      Top = 44
      Width = 25
      Height = 21
      Hint = 'custom preset 9'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton29: TSpeedButton
      Tag = 15
      Left = 178
      Top = 44
      Width = 25
      Height = 21
      Hint = 'custom preset 10'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      Transparent = False
      OnClick = SpeedButton15Click
    end
    object SpeedButton9: TSpeedButton
      Left = 6
      Top = 2
      Width = 27
      Height = 21
      Hint = 
        'Leftclick:   Undo -> Sets the light parameter to the state befor' +
        'e the last painting'#13#10'Rightclick: Redo'
      Enabled = False
      Flat = True
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000C30E0000C30E0000100000001000000000000000C6C6
        C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00111111111111
        1111111111111111111111111111111111111111111111111111111111111111
        0111110000011111011111000011111110111100011111111011110010111111
        1011110111001111011111111111000011111111111111111111111111111111
        1111111111111111111111111111111111111111111111111111}
      ParentShowHint = False
      ShowHint = True
      OnMouseUp = SpeedButton9MouseUp
    end
    object SpeedButton31: TSpeedButton
      Left = 205
      Top = 1
      Width = 16
      Height = 22
      Hint = 'Shrink the panel'
      Glyph.Data = {
        C2010000424DC20100000000000036000000280000000C0000000B0000000100
        1800000000008C010000110B0000110B0000000000000000000084C4C384C4C3
        84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
        C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384
        C4C384C4C3000000000000000000000000000000000000000000000000000000
        00000084C4C384C4C30000002929294848484848484848484848484848484848
        4829292900000084C4C384C4C384C4C300000035353554545454545454545454
        545435353500000084C4C384C4C384C4C384C4C384C4C3000000414141636363
        63636341414100000084C4C384C4C384C4C384C4C384C4C384C4C384C4C30000
        0046464646464600000084C4C384C4C384C4C384C4C384C4C384C4C384C4C384
        C4C384C4C300000000000084C4C384C4C384C4C384C4C384C4C384C4C384C4C3
        84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
        C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384
        C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
        84C4C384C4C3}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton31Click
    end
    object SpeedButton32: TSpeedButton
      Left = 205
      Top = 1
      Width = 18
      Height = 22
      Hint = 'Expand the panel'
      Glyph.Data = {
        C2010000424DC20100000000000036000000280000000C0000000B0000000100
        1800000000008C010000110B0000110B0000000000000000000084C4C384C4C3
        84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
        C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384
        C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
        84C4C384C4C384C4C384C4C384C4C384C4C384C4C300000000000084C4C384C4
        C384C4C384C4C384C4C384C4C384C4C384C4C384C4C300000046464646464600
        000084C4C384C4C384C4C384C4C384C4C384C4C384C4C3000000414141636363
        63636341414100000084C4C384C4C384C4C384C4C384C4C30000003535355454
        5454545454545454545435353500000084C4C384C4C384C4C300000029292948
        484848484848484848484848484848484829292900000084C4C384C4C3000000
        00000000000000000000000000000000000000000000000000000084C4C384C4
        C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384
        C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
        84C4C384C4C3}
      ParentShowHint = False
      ShowHint = True
      Visible = False
      OnClick = SpeedButton31Click
    end
    object ComboBox3: TComboBox
      Left = 77
      Top = 73
      Width = 137
      Height = 21
      Hint = 
        'Quick load of light parameter files that are'#13#10'stored in the spec' +
        'ific ini directory.'
      Style = csDropDownList
      DropDownCount = 40
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnDropDown = ComboBox3DropDown
      OnSelect = ComboBox3Select
    end
    object CheckBox11: TCheckBox
      Left = 4
      Top = 28
      Width = 72
      Height = 17
      Hint = 
        'If enabled, the lights are not changed when presets or light par' +
        'ameters are loaded.'#13#10'Can be useful if you don'#39't want to recalcul' +
        'ate the hard shadows, for example.'
      Caption = 'Keep lights'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
  end
  object TabControl1: TTabControl
    Left = 0
    Top = 0
    Width = 233
    Height = 180
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Tabs.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6')
    TabIndex = 0
    TabWidth = 36
    OnChange = TabControl1Change
    OnChanging = TabControl1Changing
    OnMouseDown = TabControl1MouseDown
    object Label8: TLabel
      Left = 127
      Top = 30
      Width = 19
      Height = 13
      Caption = 'Diff:'
    end
    object Label9: TLabel
      Left = 127
      Top = 54
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Spec:'
    end
    object Label26: TLabel
      Left = 76
      Top = 33
      Width = 42
      Height = 13
      Caption = 'Intensity:'
    end
    object SpeedButton12: TSpeedButton
      Tag = 12
      Left = 45
      Top = 25
      Width = 29
      Height = 21
      Hint = 'Light color, press to select a new one.'
      Flat = True
      Glyph.Data = {
        A6020000424DA60200000000000036000000280000000F0000000D0000000100
        18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000C0C0C0000000}
      Layout = blGlyphRight
      ParentShowHint = False
      ShowHint = True
      Spacing = -1
      OnClick = SpeedButton1Click
    end
    object ComboBox1: TComboBox
      Left = 151
      Top = 27
      Width = 68
      Height = 20
      Hint = 
        'Diffuse function, choose Cos or Cos^2 if you use a hard shadow o' +
        'n this light.'
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = ComboBox1Change
      Items.Strings = (
        'Cos'
        'Cos^2'
        'Cos/2+ '
        '(Cos/2+)'#178)
    end
    object ComboBox2: TComboBox
      Left = 161
      Top = 51
      Width = 58
      Height = 20
      Hint = 'Specular power function'
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ItemIndex = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = '8'
      OnChange = ComboBox1Change
      Items.Strings = (
        '2'
        '4'
        '8'
        '16'
        '32'
        '64'
        '128'
        '256')
    end
    object CheckBox4: TCheckBox
      Left = 6
      Top = 29
      Width = 33
      Height = 17
      Alignment = taLeftJustify
      Caption = 'On'
      TabOrder = 2
      OnClick = CheckBox4Click
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 72
      Width = 221
      Height = 108
      ActivePage = TabSheet6
      TabOrder = 3
      OnChange = PageControl1Change
      OnChanging = PageControl1Changing
      object TabSheet1: TTabSheet
        Caption = 'Global light'
        object Label2: TLabel
          Left = 5
          Top = 30
          Width = 59
          Height = 13
          Caption = 'Light Yangle'
        end
        object Label3: TLabel
          Left = 5
          Top = 56
          Width = 59
          Height = 13
          Caption = 'Light Xangle'
        end
        object Label25: TLabel
          Left = 6
          Top = 6
          Width = 33
          Height = 13
          Caption = 'Visible:'
        end
        object TrackBar1: TTrackBar
          Left = 69
          Top = 52
          Width = 136
          Height = 25
          Max = 180
          Min = -180
          Frequency = 180
          Position = 44
          SelEnd = -1
          TabOrder = 0
          ThumbLength = 18
          OnChange = TrackBar1Change
          OnKeyPress = TrackBar21KeyPress
        end
        object TrackBar2: TTrackBar
          Left = 69
          Top = 26
          Width = 136
          Height = 25
          Max = 180
          Min = -180
          Frequency = 180
          Position = 54
          SelEnd = -1
          TabOrder = 1
          ThumbLength = 18
          OnChange = TrackBarYangleChange
          OnKeyPress = TrackBar21KeyPress
        end
        object CheckBox6: TCheckBox
          Left = 110
          Top = 4
          Width = 83
          Height = 17
          Hint = 'Use it in animations to fix the lights to the scenery.'
          Alignment = taLeftJustify
          Caption = 'Rel. to object:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = CheckBox6Click
        end
        object ComboBox4: TComboBox
          Left = 44
          Top = 3
          Width = 38
          Height = 20
          Hint = 'Determines whether the light should be visible and its shape.'
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = '0'
          OnChange = ComboBox4Change
          Items.Strings = (
            '0'
            '1'
            '2'
            '3'
            '4')
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Positional light'
        ImageIndex = 1
        object Label13: TLabel
          Left = 47
          Top = 5
          Width = 24
          Height = 13
          Caption = 'Xpos'
        end
        object Label14: TLabel
          Left = 47
          Top = 31
          Width = 24
          Height = 13
          Caption = 'Ypos'
        end
        object Label15: TLabel
          Left = 47
          Top = 57
          Width = 24
          Height = 13
          Caption = 'Zpos'
        end
        object Label32: TLabel
          Left = 1
          Top = 6
          Width = 33
          Height = 13
          Caption = 'Visible:'
        end
        object TrackBar15: TTrackBarEx
          Tag = 1
          Left = 72
          Top = 27
          Width = 112
          Height = 25
          Hint = 
            'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
            'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
            's the trackbar to its zero position.'
          Max = 180
          Min = -180
          ParentShowHint = False
          PageSize = 1
          Frequency = 180
          SelEnd = -1
          ShowHint = True
          TabOrder = 0
          ThumbLength = 18
          OnChange = TrackBar16Change
          OnKeyPress = TrackBar21KeyPress
          OnMouseUp = TrackBar16MouseUp
        end
        object TrackBar16: TTrackBarEx
          Left = 72
          Top = 1
          Width = 112
          Height = 25
          Hint = 
            'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
            'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
            's the trackbar to its zero position.'
          Max = 180
          Min = -180
          ParentShowHint = False
          PageSize = 1
          Frequency = 180
          SelEnd = -1
          ShowHint = True
          TabOrder = 1
          ThumbLength = 18
          OnChange = TrackBar16Change
          OnKeyPress = TrackBar21KeyPress
          OnMouseUp = TrackBar16MouseUp
        end
        object TrackBar17: TTrackBarEx
          Tag = 2
          Left = 72
          Top = 53
          Width = 112
          Height = 25
          Hint = 
            'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
            'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
            's the trackbar to its zero position.'
          Max = 180
          Min = -180
          ParentShowHint = False
          PageSize = 1
          Frequency = 180
          SelEnd = -1
          ShowHint = True
          TabOrder = 2
          ThumbLength = 18
          OnChange = TrackBar16Change
          OnKeyPress = TrackBar21KeyPress
          OnMouseUp = TrackBar16MouseUp
        end
        object UpDown1: TUpDown
          Left = 184
          Top = 2
          Width = 25
          Height = 19
          Hint = 'fine tune the positions with the arrow buttons'
          Min = -32768
          Max = 32767
          Orientation = udHorizontal
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = UpDown1Click
        end
        object UpDown2: TUpDown
          Tag = 1
          Left = 184
          Top = 28
          Width = 25
          Height = 19
          Hint = 'fine tune the positions with the arrow buttons'
          Min = -32768
          Max = 32767
          Orientation = udHorizontal
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = UpDown1Click
        end
        object UpDown3: TUpDown
          Tag = 2
          Left = 184
          Top = 54
          Width = 25
          Height = 19
          Hint = 'fine tune the positions with the arrow buttons'
          Min = -32768
          Max = 32767
          Orientation = udHorizontal
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = UpDown1Click
        end
        object ButtonGetPos: TButton
          Left = 1
          Top = 53
          Width = 39
          Height = 21
          Hint = 
            'Click on button and afterwards on the object in image'#13#10'to set th' +
            'e midpoint for the light.'
          Caption = 'mid'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = ButtonGetPosClick
        end
        object ComboBox5: TComboBox
          Left = 2
          Top = 24
          Width = 38
          Height = 20
          Hint = 'Determines whether the light should be visible and its shape.'
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ItemIndex = 0
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          Text = '0'
          OnChange = ComboBox4Change
          Items.Strings = (
            '0'
            '1'
            '2'
            '3'
            '4')
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'Lightmap'
        ImageIndex = 2
        object Label39: TLabel
          Left = 158
          Top = 31
          Width = 39
          Height = 26
          Alignment = taCenter
          Caption = 'Map not'#13#10'found'
        end
        object Label29: TLabel
          Left = 3
          Top = 5
          Width = 19
          Height = 13
          Caption = 'Xrot'
        end
        object Label30: TLabel
          Left = 3
          Top = 31
          Width = 19
          Height = 13
          Caption = 'Yrot'
        end
        object Label31: TLabel
          Left = 3
          Top = 57
          Width = 19
          Height = 13
          Caption = 'Zrot'
        end
        object Image3: TImage
          Left = 145
          Top = 30
          Width = 64
          Height = 32
        end
        object TrackBar25: TTrackBar
          Tag = 1
          Left = 26
          Top = 27
          Width = 112
          Height = 25
          Hint = 'Pressing "0" (zero) sets the trackbar to its zero position.'
          Max = 255
          ParentShowHint = False
          PageSize = 1
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          ShowHint = True
          TabOrder = 0
          ThumbLength = 18
          OnChange = TrackBar26Change
          OnKeyPress = TrackBar21KeyPress
        end
        object TrackBar26: TTrackBar
          Left = 26
          Top = 1
          Width = 112
          Height = 25
          Hint = 'Pressing "0" (zero) sets the trackbar to its zero position.'
          Max = 255
          ParentShowHint = False
          PageSize = 1
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          ShowHint = True
          TabOrder = 1
          ThumbLength = 18
          OnChange = TrackBar26Change
          OnKeyPress = TrackBar21KeyPress
        end
        object TrackBar27: TTrackBar
          Tag = 2
          Left = 26
          Top = 53
          Width = 112
          Height = 25
          Hint = 'Pressing "0" (zero) sets the trackbar to its zero position.'
          Max = 255
          ParentShowHint = False
          PageSize = 1
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          ShowHint = True
          TabOrder = 2
          ThumbLength = 18
          OnChange = TrackBar26Change
          OnKeyPress = TrackBar21KeyPress
        end
        object CheckBox14: TCheckBox
          Left = 145
          Top = 63
          Width = 60
          Height = 17
          Hint = 
            'Set the maps orientation relative to the object.'#13#10'Use it in anim' +
            'ations to fix the lights to the scenery.'
          Alignment = taLeftJustify
          Caption = 'M.rel.obj.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = CheckBox6Click
        end
        object Edit2: TEdit
          Left = 150
          Top = 5
          Width = 37
          Height = 21
          Hint = 'Map number'
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          Text = '1'
          OnChange = SpinEdit1Change
          OnMouseDown = Edit2MouseDown
        end
        object UpDownLight: TUpDown
          Left = 187
          Top = 5
          Width = 18
          Height = 21
          Associate = Edit2
          Min = 1
          Max = 32000
          Position = 1
          TabOrder = 5
          Thousands = False
        end
      end
    end
    object CheckBox7: TCheckBox
      Left = 6
      Top = 52
      Width = 33
      Height = 17
      Hint = 
        'Enables the hard shadow, if calculated.'#13#10'If the HS wasnt calcula' +
        'ted, the ambshadow decreases the light if enabled.'
      Alignment = taLeftJustify
      Caption = 'HS'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBox7Click
    end
    object Edit1: TEdit
      Left = 54
      Top = 50
      Width = 42
      Height = 20
      Hint = 
        'Light amplitude, use exponent style like:'#13#10'1.4e-2   ( = 0.014   ' +
        ')'#13#10'3e-4      ( = 0.0003 )'
      AutoSize = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      Text = '1.0'
      OnChange = Edit1Change
    end
    object UpDown4: TUpDown
      Left = 96
      Top = 50
      Width = 25
      Height = 20
      Min = -32000
      Max = 32000
      TabOrder = 6
      OnClick = UpDown4Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 483
    Width = 233
    Height = 38
    Align = alClient
    TabOrder = 2
    object Label16: TLabel
      Left = 8
      Top = 12
      Width = 60
      Height = 13
      Caption = 'Gamma:  0.5'
    end
    object Label17: TLabel
      Left = 168
      Top = 12
      Width = 6
      Height = 13
      Caption = '2'
    end
    object TrackBar18: TTrackBar
      Left = 72
      Top = 8
      Width = 93
      Height = 25
      Hint = 
        'If selected, press '#39'1'#39' to set this slider to the default positio' +
        'n.'
      Max = 63
      ParentShowHint = False
      Frequency = 32
      Position = 32
      SelEnd = 32
      SelStart = 32
      ShowHint = True
      TabOrder = 0
      ThumbLength = 18
      OnChange = TrackBar2Change
      OnKeyPress = TrackBar11KeyPress
    end
    object CheckBox10: TCheckBox
      Left = 184
      Top = 11
      Width = 33
      Height = 17
      Hint = 
        'Enable internal gamma of 2 for light calculations.'#13#10'This is inde' +
        'pendent from the Gamma slider.'
      Caption = 'I2'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = CheckBox1Click
    end
  end
  object PageControl2: TPageControl
    Left = 0
    Top = 180
    Width = 233
    Height = 303
    ActivePage = Fog
    Align = alTop
    TabOrder = 3
    object TabSheet3: TTabSheet
      Caption = 'Object'
      object Label37: TLabel
        Left = 31
        Top = 38
        Width = 36
        Height = 13
        Caption = 'Diffuse:'
      end
      object SpeedButton1: TSpeedButton
        Tag = 1
        Left = 0
        Top = 34
        Width = 81
        Height = 23
        Hint = 'Diffuse object colors, click to change them.'
        Caption = 'Diff'
        Flat = True
        Glyph.Data = {
          1A060000424D1A060000000000003600000028000000260000000D0000000100
          180000000000E4050000120B0000120B0000000000000000000043FD35000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
          000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD
          35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          0043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF00000043FD35800043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
          000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD355BF943FD35000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF00000043FD35000043FD3500000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000043FD350000}
        Layout = blGlyphRight
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        Transparent = False
        OnClick = SpeedButton2Click
      end
      object SpeedButton2: TSpeedButton
        Tag = 2
        Left = 0
        Top = 6
        Width = 81
        Height = 23
        Hint = 'Specular object colors, click to change them.'
        Caption = 'Spec'
        Flat = True
        Glyph.Data = {
          1A060000424D1A060000000000003600000028000000260000000D0000000100
          180000000000E4050000120B0000120B0000000000000000000043FD35000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
          000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD
          35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          0043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF00000043FD35800043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
          000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD355BF943FD35000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFF00000043FD35000043FD3500000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000043FD350000}
        Layout = blGlyphRight
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        Transparent = False
        OnClick = SpeedButton2Click
      end
      object Panel2: TPanel
        Left = 0
        Top = 88
        Width = 217
        Height = 187
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object Label40: TLabel
          Left = 155
          Top = 2
          Width = 39
          Height = 26
          Alignment = taCenter
          Caption = 'Map not'#13#10'found'
        end
        object Label34: TLabel
          Left = 8
          Top = 7
          Width = 62
          Height = 13
          Caption = 'Map number:'
        end
        object Label35: TLabel
          Left = 29
          Top = 39
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = 'Offset X:'
        end
        object Label36: TLabel
          Left = 29
          Top = 65
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = 'Offset Y:'
        end
        object Image4: TImage
          Left = 142
          Top = 1
          Width = 64
          Height = 32
        end
        object Label41: TLabel
          Left = 27
          Top = 91
          Width = 43
          Height = 13
          Alignment = taRightJustify
          Caption = 'Rotation:'
        end
        object Label38: TLabel
          Left = 40
          Top = 117
          Width = 30
          Height = 13
          Alignment = taRightJustify
          Caption = 'Scale:'
        end
        object TrackBar28: TTrackBar
          Left = 73
          Top = 61
          Width = 136
          Height = 25
          Max = 255
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          TabOrder = 0
          ThumbLength = 18
          OnChange = TrackBar2Change
          OnKeyPress = TrackBar21KeyPress
        end
        object TrackBar29: TTrackBar
          Left = 73
          Top = 35
          Width = 136
          Height = 25
          Max = 255
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          TabOrder = 1
          ThumbLength = 18
          OnChange = TrackBar2Change
          OnKeyPress = TrackBar21KeyPress
        end
        object TrackBar30: TTrackBar
          Left = 73
          Top = 87
          Width = 136
          Height = 25
          Max = 255
          Frequency = 128
          Position = 128
          SelEnd = 128
          SelStart = 128
          TabOrder = 2
          ThumbLength = 18
          OnChange = TrackBar2Change
          OnKeyPress = TrackBar21KeyPress
        end
        object CheckBox18: TCheckBox
          Left = 12
          Top = 170
          Width = 182
          Height = 17
          Hint = 'Use the map intensities and diffuse colors.'
          Caption = 'Combine map Y with diffuse colors'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = CheckBox16Click
        end
        object RadioGroup1: TRadioGroup
          Left = 0
          Top = 136
          Width = 215
          Height = 31
          Hint = 
            'The its.trap mode depends on the calculated option in the "Color' +
            'ing" tab.'
          Caption = 'Mode:'
          Columns = 4
          ItemIndex = 0
          Items.Strings = (
            'its.trap'
            'norms'
            'wrap1'
            'wrap2')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = CheckBox16Click
        end
        object TrackBar31: TTrackBar
          Left = 73
          Top = 113
          Width = 136
          Height = 25
          Max = 255
          Frequency = 128
          Position = 30
          SelEnd = 30
          SelStart = 30
          TabOrder = 5
          ThumbLength = 18
          OnChange = TrackBar2Change
          OnKeyPress = TrackBar11KeyPress
        end
        object Edit21: TEdit
          Left = 80
          Top = 4
          Width = 37
          Height = 21
          MaxLength = 5
          NumbersOnly = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          Text = '1'
          OnChange = SpinEdit2Change
          OnMouseDown = Edit2MouseDown
        end
        object UpDownDiffMap: TUpDown
          Left = 117
          Top = 4
          Width = 19
          Height = 21
          Associate = Edit21
          Min = 1
          Max = 32000
          Position = 1
          TabOrder = 7
          Thousands = False
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 80
        Width = 213
        Height = 195
        BevelOuter = bvNone
        TabOrder = 2
        object Label5: TLabel
          Left = 31
          Top = 31
          Width = 47
          Height = 13
          Caption = 'Color start'
        end
        object Label7: TLabel
          Left = 33
          Top = 69
          Width = 45
          Height = 13
          Caption = 'Color end'
        end
        object SBFineAdj: TSpeedButton
          Left = 16
          Top = 45
          Width = 29
          Height = 23
          Hint = 'Adjust roughly then click for fine adjustment.'
          AllowAllUp = True
          GroupIndex = 7
          Caption = 'fine'
          ParentShowHint = False
          ShowHint = True
          OnClick = SBFineAdjClick
        end
        object Label10: TLabel
          Left = 31
          Top = 99
          Width = 47
          Height = 13
          Caption = 'Color start'
        end
        object Label11: TLabel
          Left = 33
          Top = 137
          Width = 45
          Height = 13
          Caption = 'Color end'
        end
        object Image1: TImage
          Left = 95
          Top = 52
          Width = 107
          Height = 5
        end
        object Image2: TImage
          Left = 95
          Top = 120
          Width = 107
          Height = 5
        end
        object Label12: TLabel
          Left = 8
          Top = 172
          Width = 64
          Height = 13
          Caption = 'Col. var. on Z'
        end
        object Label27: TLabel
          Left = 120
          Top = 178
          Width = 4
          Height = 9
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Microsoft Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton33: TSpeedButton
          Tag = 33
          Left = 0
          Top = 113
          Width = 81
          Height = 23
          Hint = 'Oject colors on cuts and 2d inside, click to change them.'
          Caption = 'Cuts'
          Flat = True
          Glyph.Data = {
            1A060000424D1A060000000000003600000028000000260000000D0000000100
            180000000000E4050000120B0000120B0000000000000000000043FD35000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
            000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD
            35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
            0043FD35000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35000043FD35000000
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF00000043FD35800043FD35000000FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD35
            000043FD35000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFF00000043FD355BF943FD35000000FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFF00000043FD35000043FD3500000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000043FD350000}
          Layout = blGlyphRight
          Margin = 2
          ParentShowHint = False
          ShowHint = True
          Spacing = -1
          Transparent = False
          OnClick = SpeedButton2Click
        end
        object SpeedButton34: TSpeedButton
          Left = 52
          Top = 45
          Width = 29
          Height = 23
          Hint = 'Adjust sliders to fit the histograms endpoints'
          Caption = '>||<'
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton34Click
        end
        object TrackBar9: TTrackBar
          Left = 84
          Top = 27
          Width = 129
          Height = 25
          Max = 90
          Min = -30
          Frequency = 30
          Position = 68
          TabOrder = 0
          ThumbLength = 18
          OnChange = TrackBar2Change
        end
        object TrackBar10: TTrackBar
          Left = 84
          Top = 57
          Width = 129
          Height = 28
          Max = 90
          Min = -30
          Frequency = 30
          Position = 72
          TabOrder = 1
          ThumbLength = 18
          TickMarks = tmTopLeft
          OnChange = TrackBar2Change
        end
        object TrackBar12: TTrackBar
          Left = 84
          Top = 95
          Width = 129
          Height = 25
          Max = 120
          Frequency = 30
          TabOrder = 2
          ThumbLength = 18
          OnChange = TrackBar2Change
        end
        object TrackBar13: TTrackBar
          Left = 84
          Top = 125
          Width = 129
          Height = 29
          Max = 120
          Frequency = 30
          Position = 60
          TabOrder = 3
          ThumbLength = 18
          TickMarks = tmTopLeft
          OnChange = TrackBar2Change
        end
        object CheckBox1: TCheckBox
          Left = 3
          Top = 7
          Width = 75
          Height = 17
          Caption = 'Col cycling'
          Checked = True
          ParentShowHint = False
          ShowHint = False
          State = cbChecked
          TabOrder = 4
          OnClick = CheckBox1Click
        end
        object CheckBox2: TCheckBox
          Left = 83
          Top = 7
          Width = 69
          Height = 17
          Caption = '2. choice'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 5
          OnClick = CheckBox2Click
        end
        object TrackBar14: TTrackBar
          Left = 84
          Top = 168
          Width = 129
          Height = 25
          Hint = 
            'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
            'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
            's the trackbar to its zero position.'
          Max = 360
          Min = -120
          ParentShowHint = False
          Frequency = 120
          SelEnd = -1
          ShowHint = True
          TabOrder = 6
          ThumbLength = 18
          OnChange = TrackBar2Change
          OnKeyPress = TrackBar21KeyPress
        end
        object CheckBox22: TCheckBox
          Left = 157
          Top = 7
          Width = 52
          Height = 17
          Caption = 'No ipol'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 7
          OnClick = CheckBox22Click
        end
      end
      object TrackBar5: TTrackBar
        Left = 84
        Top = 34
        Width = 129
        Height = 25
        Hint = 
          'If selected, press '#39'1'#39' to set this slider to the default positio' +
          'n.'
        Max = 250
        ParentShowHint = False
        Frequency = 50
        Position = 50
        SelEnd = 50
        SelStart = 50
        ShowHint = True
        TabOrder = 0
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object TrackBar7: TTrackBar
        Left = 84
        Top = 6
        Width = 129
        Height = 25
        Hint = 
          'If selected, press '#39'1'#39' to set this slider to the default positio' +
          'n.'
        Max = 350
        ParentShowHint = False
        Frequency = 50
        Position = 50
        SelEnd = 50
        SelStart = 50
        ShowHint = True
        TabOrder = 1
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object CheckBox15: TCheckBox
        Left = 32
        Top = 64
        Width = 169
        Height = 17
        Hint = 
          'See also the map coloring options in the main windows '#39'Coloring'#39 +
          ' tab.'
        Caption = 'Use a map for the diffuse color'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = CheckBox15Click
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Ambient'
      ImageIndex = 1
      object Label4: TLabel
        Left = 2
        Top = 169
        Width = 78
        Height = 13
        Caption = 'Ambient shadow'
      end
      object SpeedButton3: TSpeedButton
        Tag = 3
        Left = 0
        Top = 6
        Width = 60
        Height = 23
        Hint = 
          'Ambient top color, leftclick to change color,'#13#10'rightclick to ins' +
          'ert the depth colors.'
        Caption = 'Amb'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Layout = blGlyphRight
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
        OnMouseUp = SpeedButton3MouseUp
      end
      object SpeedButton6: TSpeedButton
        Tag = 6
        Left = 60
        Top = 6
        Width = 21
        Height = 23
        Hint = 'Ambient bottom color, click to change.'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
      end
      object SpeedButton10: TSpeedButton
        Tag = 10
        Left = 0
        Top = 34
        Width = 60
        Height = 23
        Hint = 
          'Background top color, leftclick to change, rightclick for popupm' +
          'enu.'
        Caption = 'Depth'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Layout = blGlyphRight
        Margin = 2
        ParentShowHint = False
        PopupMenu = PopupMenu2
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
      end
      object SpeedButton11: TSpeedButton
        Tag = 11
        Left = 60
        Top = 34
        Width = 21
        Height = 23
        Hint = 'Background bottom color, click to change.'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
      end
      object Label21: TLabel
        Left = 93
        Top = 191
        Width = 4
        Height = 9
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 146
        Top = 191
        Width = 4
        Height = 9
        Caption = '1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Microsoft Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label23: TLabel
        Left = 11
        Top = 205
        Width = 64
        Height = 13
        Caption = '2nd reflection'
      end
      object SpeedButton5: TSpeedButton
        Tag = 1
        Left = 127
        Top = 66
        Width = 25
        Height = 23
        Hint = 'Depth gradient function, works only if not '#39'Relative to object'#39'.'
        GroupIndex = 12
        Flat = True
        Glyph.Data = {
          46050000424D460500000000000036040000280000000F000000110000000100
          08000000000010010000C30E0000C30E00000001000000010000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A60000000000357C62007C8B1400758B1F006D8D2C00738D25003B917C005B89
          43004C8755004E895E0053935E0048936D0053966000439478008F8D0500878B
          0900898B09000177A1000077B200007CC10018809A00358F84000B80AB000384
          B2000584B8000D87BB000B8BBA001B93BF002AA1BF00018FCA00008BCE00148F
          C3001493C7001094C700169ACC00189ACA000091D6000094D4000094D6000B96
          D000219ECC000BA5E60000A5EC0009A7E8000BABEE0012ADEE0000ABF30000B4
          FF0005B8FF0012BFFF0005C1FF0001C7FF0000ECFF0019E7F90000F1FF0000FF
          FF0080FFFF00C6C6C6001400140058871B0018000000E401000060EE12004000
          00000000000000000000A8EE120068EE12000000000000000000000000000000
          000000000000000000000000000040000000ACEE120020E99100000000000200
          000001000000E401000060EE1200E401000060149200F8D62200D8D622000000
          00000000000090EC01008F00000004EC120020E99100C0EC12007C94370011A9
          000011A90000D4EC12001E9437005044AF0011A9000000000000ECEC1200E294
          37005044AF003D150F00F057E200B057E2000CED1200824C0F00F057E200A603
          3700B64C0F00F057E20014ED120000000000B8009200105BCE00E0ED12004100
          9200A80714005D00920038EE1200000000003CED120000000000B80092005087
          1B0008EE1200410092004807140058ED120000000000B800920050871B0024EE
          120041009200480714005D00920068EE12000400000000000000020000000000
          0000040000003000000000000000185BCE00D98B360000F0FD00300000000400
          00000000140098EB12005CF69100200000000000000058871B00C4ED12000000
          0000B800920020210B0090EE120041009200380BE2005D009200806A0A002821
          0B000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
          120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
          910060009200FFFFFF005D009200AC04920000001400C800000058871B0048EE
          12008204920058871B00000000009CEE12000EECDA0020ECDA00C8A662000000
          E200D4A66200000000000000000000000000000000000000010019000000D4ED
          120028210B00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
          E20000000000E3C2BF00806A0A0028210B0003000000AA68D30028210B002821
          0B00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
          BF00D595440028210B00A01B6300A01B6300F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00434343434343
          4343434343434343430000000000000000000000000000000000000043434343
          4343434343434343000000004343434343434343434343430000004300434343
          4343434343434343000000430043434343434343434343430000004343004343
          4343434343434343000000434300434343434343434343430000004343430043
          4343434343434343000000434343430043434343434343430000004343434343
          0043434343434343000000434343434343004343434343430000004343434343
          4343000043434343000000434343434343434343000043430000004343434343
          4343434343430000000000000000000000000000000000000000434343434343
          43434343434343434300}
        ParentShowHint = False
        ShowHint = True
        OnClick = CheckBox1Click
      end
      object SpeedButton7: TSpeedButton
        Tag = 2
        Left = 152
        Top = 66
        Width = 25
        Height = 23
        Hint = 'Depth gradient function, works only if not '#39'Relative to object'#39'.'
        GroupIndex = 12
        Down = True
        Flat = True
        Glyph.Data = {
          46050000424D460500000000000036040000280000000F000000110000000100
          08000000000010010000C30E0000C30E00000001000000010000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A60000000000357C62007C8B1400758B1F006D8D2C00738D25003B917C005B89
          43004C8755004E895E0053935E0048936D0053966000439478008F8D0500878B
          0900898B09000177A1000077B200007CC10018809A00358F84000B80AB000384
          B2000584B8000D87BB000B8BBA001B93BF002AA1BF00018FCA00008BCE00148F
          C3001493C7001094C700169ACC00189ACA000091D6000094D4000094D6000B96
          D000219ECC000BA5E60000A5EC0009A7E8000BABEE0012ADEE0000ABF30000B4
          FF0005B8FF0012BFFF0005C1FF0001C7FF0000ECFF0019E7F90000F1FF0000FF
          FF0080FFFF00C6C6C6001400140058871B0018000000E401000060EE12004000
          00000000000000000000A8EE120068EE12000000000000000000000000000000
          000000000000000000000000000040000000ACEE120020E99100000000000200
          000001000000E401000060EE1200E401000060149200F8D62200D8D622000000
          00000000000090EC01008F00000004EC120020E99100C0EC12007C94370011A9
          000011A90000D4EC12001E9437005044AF0011A9000000000000ECEC1200E294
          37005044AF003D150F00F057E200B057E2000CED1200824C0F00F057E200A603
          3700B64C0F00F057E20014ED120000000000B8009200105BCE00E0ED12004100
          9200A80714005D00920038EE1200000000003CED120000000000B80092005087
          1B0008EE1200410092004807140058ED120000000000B800920050871B0024EE
          120041009200480714005D00920068EE12000400000000000000020000000000
          0000040000003000000000000000185BCE00D98B360000F0FD00300000000400
          00000000140098EB12005CF69100200000000000000058871B00C4ED12000000
          0000B800920020210B0090EE120041009200380BE2005D009200806A0A002821
          0B000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
          120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
          910060009200FFFFFF005D009200AC04920000001400C800000058871B0048EE
          12008204920058871B00000000009CEE12000EECDA0020ECDA00C8A662000000
          E200D4A66200000000000000000000000000000000000000010019000000D4ED
          120028210B00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
          E20000000000E3C2BF00806A0A0028210B0003000000AA68D30028210B002821
          0B00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
          BF00D595440028210B00A01B6300A01B6300F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00434343434343
          4343434343434343430000000000000000000000000000000000000043434343
          4343434343434343000000430043434343434343434343430000004343004343
          4343434343434343000000434343004343434343434343430000004343434300
          4343434343434343000000434343434300434343434343430000004343434343
          4300434343434343000000434343434343430043434343430000004343434343
          4343430043434343000000434343434343434343004343430000004343434343
          4343434343004343000000434343434343434343434300430000004343434343
          4343434343434300000000000000000000000000000000000000434343434343
          43434343434343434300}
        ParentShowHint = False
        ShowHint = True
        OnClick = CheckBox1Click
      end
      object SpeedButton8: TSpeedButton
        Tag = 3
        Left = 177
        Top = 66
        Width = 25
        Height = 23
        Hint = 'Depth gradient function, works only if not '#39'Relative to object'#39'.'
        GroupIndex = 12
        Flat = True
        Glyph.Data = {
          46050000424D460500000000000036040000280000000F000000110000000100
          08000000000010010000C30E0000C30E00000001000000010000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A60000000000357C62007C8B1400758B1F006D8D2C00738D25003B917C005B89
          43004C8755004E895E0053935E0048936D0053966000439478008F8D0500878B
          0900898B09000177A1000077B200007CC10018809A00358F84000B80AB000384
          B2000584B8000D87BB000B8BBA001B93BF002AA1BF00018FCA00008BCE00148F
          C3001493C7001094C700169ACC00189ACA000091D6000094D4000094D6000B96
          D000219ECC000BA5E60000A5EC0009A7E8000BABEE0012ADEE0000ABF30000B4
          FF0005B8FF0012BFFF0005C1FF0001C7FF0000ECFF0019E7F90000F1FF0000FF
          FF0080FFFF00C6C6C6001400140058871B0018000000E401000060EE12004000
          00000000000000000000A8EE120068EE12000000000000000000000000000000
          000000000000000000000000000040000000ACEE120020E99100000000000200
          000001000000E401000060EE1200E401000060149200F8D62200D8D622000000
          00000000000090EC01008F00000004EC120020E99100C0EC12007C94370011A9
          000011A90000D4EC12001E9437005044AF0011A9000000000000ECEC1200E294
          37005044AF003D150F00F057E200B057E2000CED1200824C0F00F057E200A603
          3700B64C0F00F057E20014ED120000000000B8009200105BCE00E0ED12004100
          9200A80714005D00920038EE1200000000003CED120000000000B80092005087
          1B0008EE1200410092004807140058ED120000000000B800920050871B0024EE
          120041009200480714005D00920068EE12000400000000000000020000000000
          0000040000003000000000000000185BCE00D98B360000F0FD00300000000400
          00000000140098EB12005CF69100200000000000000058871B00C4ED12000000
          0000B800920020210B0090EE120041009200380BE2005D009200806A0A002821
          0B000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
          120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
          910060009200FFFFFF005D009200AC04920000001400C800000058871B0048EE
          12008204920058871B00000000009CEE12000EECDA0020ECDA00C8A662000000
          E200D4A66200000000000000000000000000000000000000010019000000D4ED
          120028210B00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
          E20000000000E3C2BF00806A0A0028210B0003000000AA68D30028210B002821
          0B00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
          BF00D595440028210B00A01B6300A01B6300F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00434343434343
          4343434343434343430000000000000000000000000000000000000000434343
          4343434343434343000000434300004343434343434343430000004343434300
          0043434343434343000000434343434343004343434343430000004343434343
          4343004343434343000000434343434343434300434343430000004343434343
          4343434300434343000000434343434343434343430043430000004343434343
          4343434343004343000000434343434343434343434300430000004343434343
          4343434343430043000000434343434343434343434343000000004343434343
          4343434343434300000000000000000000000000000000000000434343434343
          43434343434343434300}
        ParentShowHint = False
        ShowHint = True
        OnClick = CheckBox1Click
      end
      object Label28: TLabel
        Left = 21
        Top = 253
        Width = 54
        Height = 13
        Caption = 'Roughness'
      end
      object Label42: TLabel
        Left = 5
        Top = 119
        Width = 73
        Height = 13
        Caption = 'Diffuse shadow'
      end
      object Label43: TLabel
        Left = 21
        Top = 140
        Width = 180
        Height = 13
        Caption = '(only if hard shadows were calculated)'
      end
      object TrackBar11: TTrackBar
        Left = 84
        Top = 165
        Width = 129
        Height = 25
        Hint = 
          'If selected, press '#39'1'#39' to set this slider to the default positio' +
          'n.'
        Max = 106
        ParentShowHint = False
        Frequency = 53
        Position = 53
        SelEnd = 53
        SelStart = 53
        ShowHint = True
        TabOrder = 0
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object TrackBar4: TTrackBar
        Left = 84
        Top = 34
        Width = 129
        Height = 25
        Max = 240
        Frequency = 90
        Position = 27
        SelEnd = -1
        TabOrder = 1
        ThumbLength = 18
        OnChange = TrackBar2Change
      end
      object TrackBar8: TTrackBar
        Left = 84
        Top = 6
        Width = 129
        Height = 25
        Max = 270
        Frequency = 90
        Position = 90
        SelEnd = 90
        SelStart = 90
        TabOrder = 2
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object CheckBox3: TCheckBox
        Left = 9
        Top = 65
        Width = 86
        Height = 17
        Hint = 'Decreases the fog in near parts'
        Caption = 'Far depth fog'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 3
        OnClick = CheckBox1Click
      end
      object CheckBox9: TCheckBox
        Left = 9
        Top = 86
        Width = 104
        Height = 17
        Hint = 
          'Make the top-bottom gradient of the ambient and background color' +
          's'#13#10'relative to the objects coordinate system.'#13#10'Use it in animati' +
          'ons to fix the lights to the scenery.'
        Caption = 'Relative to object'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = CheckBox1Click
      end
      object TrackBar23: TTrackBar
        Left = 84
        Top = 201
        Width = 129
        Height = 25
        Hint = 
          'If selected, press '#39'1'#39' to set this slider to the default positio' +
          'n.'
        Max = 106
        ParentShowHint = False
        Frequency = 53
        Position = 53
        SelEnd = 53
        SelStart = 53
        ShowHint = True
        TabOrder = 5
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object TrackBar24: TTrackBar
        Left = 84
        Top = 249
        Width = 129
        Height = 25
        Hint = 
          'Only working if '#39'Smooth normals'#39' was set bigger than zero on cal' +
          'culation.'
        Max = 255
        ParentShowHint = False
        Frequency = 255
        Position = 255
        SelEnd = 255
        SelStart = 255
        ShowHint = True
        TabOrder = 6
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar11KeyPress
      end
      object TrackBar32: TTrackBar
        Left = 84
        Top = 115
        Width = 129
        Height = 25
        Hint = 'To decrease also direct light by ambient occlusion'
        Max = 255
        ParentShowHint = False
        Frequency = 53
        Position = 128
        SelEnd = -1
        ShowHint = True
        TabOrder = 7
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar21KeyPress
      end
      object CheckBox16: TCheckBox
        Left = 9
        Top = 227
        Width = 63
        Height = 17
        Hint = 'Different calculation of light combining'
        Caption = 'Mode 2'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = CheckBox1Click
      end
    end
    object Fog: TTabSheet
      Caption = 'd.Fog'
      ImageIndex = 3
      object Label1: TLabel
        Left = 33
        Top = 79
        Width = 47
        Height = 13
        Caption = 'Fog offset'
      end
      object FogResetButton: TSpeedButton
        Left = 0
        Top = 83
        Width = 35
        Height = 31
        Hint = 'Click to set all dynamic fog sliders to zero.'
        BiDiMode = bdLeftToRight
        Caption = 'set to 0'
        Flat = True
        ParentShowHint = False
        ParentBiDiMode = False
        ShowHint = True
        OnClick = FogResetButtonClick
      end
      object Label18: TLabel
        Left = 34
        Top = 110
        Width = 44
        Height = 13
        Caption = 'Far offset'
      end
      object SpeedButton4: TSpeedButton
        Tag = 4
        Left = 0
        Top = 42
        Width = 60
        Height = 23
        Hint = 
          'Dynamic fog, click to change the color.  Rightclick to insert vo' +
          'lumetric light color.'
        Caption = 'Dyn.fog'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Layout = blGlyphRight
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
        OnMouseDown = SpeedButton4MouseDown
      end
      object SpeedButton30: TSpeedButton
        Tag = 30
        Left = 60
        Top = 42
        Width = 21
        Height = 23
        Hint = 'Dynamic fog intense color, click to change.'
        Flat = True
        Glyph.Data = {
          A6020000424DA60200000000000036000000280000000F0000000D0000000100
          18000000000070020000C30E0000C30E00000000000000000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF000000C0C0C0000000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0000000C0C0C0000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000C0C0C0000000}
        Margin = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = -1
        OnClick = SpeedButton1Click
      end
      object Label44: TLabel
        Left = 13
        Top = 5
        Width = 184
        Height = 26
        Alignment = taCenter
        Caption = 
          'Dynamic fog or volumetric light params. See '#39'Coloring'#39' tab for o' +
          'ptions!'
        WordWrap = True
      end
      object Label47: TLabel
        Left = 7
        Top = 225
        Width = 197
        Height = 39
        Alignment = taCenter
        Caption = 
          'If volumetric light choosen:  Rightclick on '#39'Dyn.fog'#39' button to ' +
          'insert the volumetric light color.'
        WordWrap = True
      end
      object TrackBar3: TTrackBar
        Left = 84
        Top = 75
        Width = 129
        Height = 25
        Max = 256
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelEnd = 128
        SelStart = 128
        ShowHint = False
        TabOrder = 0
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar21KeyPress
      end
      object TrackBar6: TTrackBar
        Left = 84
        Top = 42
        Width = 129
        Height = 25
        Max = 159
        Frequency = 53
        Position = 53
        SelEnd = 53
        SelStart = 53
        TabOrder = 1
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar21KeyPress
      end
      object TrackBar19: TTrackBar
        Left = 84
        Top = 106
        Width = 129
        Height = 25
        Hint = 
          'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
          'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
          's the trackbar to its zero position.'
        Max = 256
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelEnd = 128
        SelStart = 128
        ShowHint = True
        TabOrder = 2
        ThumbLength = 18
        OnChange = TrackBar2Change
        OnKeyPress = TrackBar21KeyPress
      end
      object CheckBox19: TCheckBox
        Left = 9
        Top = 139
        Width = 76
        Height = 17
        Hint = 
          'Blend the dynamic fog  instead of adding the light,'#13#10'makes the b' +
          'ackground vanishing.'
        Caption = 'Blend dFog'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = CheckBox1Click
      end
      object CheckBox23: TCheckBox
        Left = 9
        Top = 161
        Width = 86
        Height = 17
        Hint = 'Make sure that no light will be subtracted in non-blend mode'
        Caption = 'Only add light'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = CheckBox1Click
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Back pic'
      ImageIndex = 2
      object Label6: TLabel
        Left = 49
        Top = 177
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Axis X'
      end
      object Label19: TLabel
        Left = 49
        Top = 150
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Axis Y'
      end
      object Label20: TLabel
        Left = 49
        Top = 123
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Axis Z'
      end
      object Label24: TLabel
        Left = 1
        Top = 123
        Width = 38
        Height = 26
        Caption = 'Image rotation:'
        WordWrap = True
      end
      object Image5: TImage
        Left = 142
        Top = 5
        Width = 64
        Height = 32
      end
      object Label33: TLabel
        Left = 3
        Top = 204
        Width = 21
        Height = 13
        AutoSize = False
        Caption = 'Int.:'
      end
      object Label45: TLabel
        Left = 23
        Top = 204
        Width = 57
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '1.0'
      end
      object Label46: TLabel
        Left = 1
        Top = 154
        Width = 23
        Height = 39
        Caption = '(use also navi)'
        WordWrap = True
      end
      object CheckBox8: TCheckBox
        Left = 9
        Top = 8
        Width = 120
        Height = 17
        Hint = 'Click to load a background picture.'
        Caption = 'Background image:'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = CheckBox8Click
      end
      object TrackBar20: TTrackBar
        Left = 82
        Top = 173
        Width = 133
        Height = 25
        Hint = 
          'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
          'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
          's the trackbar to its zero position.'
        Max = 255
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelEnd = 128
        SelStart = 128
        ShowHint = True
        TabOrder = 1
        ThumbLength = 18
        OnChange = TrackBar22Change
        OnKeyPress = TrackBar21KeyPress
      end
      object TrackBar21: TTrackBar
        Left = 82
        Top = 146
        Width = 133
        Height = 25
        Hint = 
          'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
          'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
          's the trackbar to its zero position.'
        Max = 255
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelEnd = 128
        SelStart = 128
        ShowHint = True
        TabOrder = 2
        ThumbLength = 18
        OnChange = TrackBar22Change
        OnKeyPress = TrackBar21KeyPress
      end
      object TrackBar22: TTrackBar
        Left = 82
        Top = 119
        Width = 133
        Height = 25
        Hint = 
          'You can do a finer adjust with the left or right arrow keys'#13#10'on ' +
          'most trackbars, when they are selected.'#13#10'Pressing "0" (zero) set' +
          's the trackbar to its zero position.'
        Max = 255
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelEnd = 128
        SelStart = 128
        ShowHint = True
        TabOrder = 3
        ThumbLength = 18
        OnChange = TrackBar22Change
        OnKeyPress = TrackBar21KeyPress
      end
      object CheckBox12: TCheckBox
        Left = 9
        Top = 95
        Width = 147
        Height = 17
        Hint = 
          'If enabled, the image covers the whole sphere.'#13#10'Useful in animat' +
          'ions.'
        Caption = 'As full background sphere:'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 4
        OnClick = CheckBox1Click
      end
      object CheckBox13: TCheckBox
        Left = 23
        Top = 50
        Width = 128
        Height = 17
        Hint = 
          'Reduces blocky artifacts, no more that important due to spline i' +
          'nterpolation.'
        Caption = 'Smooth image on load'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object CheckBox5: TCheckBox
        Left = 23
        Top = 70
        Width = 189
        Height = 17
        Hint = 
          'Stretches upper and lower parts, maybe useful for a common image' +
          ' in full sphere option.'
        Caption = 'Scale rows to geographic projection'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object CheckBox17: TCheckBox
        Left = 9
        Top = 232
        Width = 200
        Height = 17
        Hint = 'If enabled, the image does not vanish on a high '#39'Depth'#39' value.'
        Caption = 'Add to background depth (not blend)'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = CheckBox1Click
      end
      object CheckBox20: TCheckBox
        Left = 23
        Top = 30
        Width = 115
        Height = 17
        Hint = 'Get a smooth image wraparound for spherical usage'
        Caption = 'Fit left+right borders'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
      object CheckBox21: TCheckBox
        Left = 9
        Top = 254
        Width = 200
        Height = 17
        Hint = 
          'For spherical usage, replaces the ambient colors with the downsc' +
          'aled background image'
        Caption = 'Use a small image as ambient color'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = CheckBox21Click
      end
      object TrackBar33: TTrackBar
        Left = 81
        Top = 201
        Width = 133
        Height = 25
        Hint = 'Intensity of image'
        Max = 255
        ParentShowHint = False
        Frequency = 128
        Position = 40
        SelEnd = 40
        SelStart = 40
        ShowHint = True
        TabOrder = 10
        ThumbLength = 18
        OnChange = TrackBar33Change
        OnKeyPress = TrackBar11KeyPress
      end
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 56
    Top = 512
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'm3l'
    Filter = 'M3D Light Adjustments  (*.m3l)|*.m3l'
    Top = 504
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'm3l'
    Filter = 'M3D Light Adjustments  (*.m3l)|*.m3l'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 32
    Top = 504
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 65528
    object CopythislighttoLight11: TMenuItem
      Caption = 'Copy this light to Light1'
      OnClick = CopythislighttoLight11Click
    end
    object CopythislighttoLight21: TMenuItem
      Tag = 1
      Caption = 'Copy this light to Light2'
      OnClick = CopythislighttoLight11Click
    end
    object CopythislighttoLight31: TMenuItem
      Tag = 2
      Caption = 'Copy this light to Light3'
      OnClick = CopythislighttoLight11Click
    end
    object CopythislighttoLight41: TMenuItem
      Tag = 3
      Caption = 'Copy this light to Light4'
      OnClick = CopythislighttoLight11Click
    end
    object CopythislighttoLight51: TMenuItem
      Tag = 4
      Caption = 'Copy this light to Light5'
      OnClick = CopythislighttoLight11Click
    end
    object CopythislighttoLight61: TMenuItem
      Tag = 5
      Caption = 'Copy this light to Light6'
      OnClick = CopythislighttoLight11Click
    end
  end
  object PopupMenu2: TPopupMenu
    Images = ImageList1
    Left = 120
    Top = 336
    object N01: TMenuItem
      Caption = '0'
      OnClick = N01Click
    end
  end
  object ImageList1: TImageList
    Masked = False
    Width = 32
    Left = 120
    Top = 392
  end
  object OpenDialogPic: TOpenPictureDialog
    Filter = 'BMP, JPEG, PNG|*.bmp;*.jpg;*.jpe;*.png'
    Left = 104
    Top = 536
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'BMP, JPEG, PNG|*.bmp;*.jpg;*.jpe;*.png'
    Left = 160
    Top = 536
  end
  object PopupMenu3: TPopupMenu
    Left = 168
    Top = 336
    object Insertvolumetriclightcolor1: TMenuItem
      Caption = 'Insert volumetric light color'
      OnClick = Insertvolumetriclightcolor1Click
    end
  end
end
