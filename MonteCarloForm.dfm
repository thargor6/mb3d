object MCForm: TMCForm
  Left = 363
  Top = 197
  Caption = 'Monte carlo rendering '
  ClientHeight = 562
  ClientWidth = 801
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 600
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolbarPnl: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 45
    Align = alTop
    TabOrder = 0
    object Button9: TSpeedButton
      Left = 15
      Top = 9
      Width = 30
      Height = 30
      Hint = 'Open a m3c file'
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00430018132440
        2E1C323227303C291018004300004300180D2C37392F1C281D36411B0C180043
        00004300180E2D2241333431383D23260F180043000043001818191E353B3A41
        3E252B1A1818004300004300181818160B2A2921201F17181818004300004300
        1818181818151211141818181818004300004300181818181818181818181818
        1818004300004300000000000000000000000000000000430000434343434343
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
      OnClick = Button9Click
    end
    object Button8: TSpeedButton
      Left = 51
      Top = 8
      Width = 30
      Height = 30
      Hint = 'Save a m3c file'
      Enabled = False
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
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0044001A142641
        301E343429323E2B111A0044000044001A0E2E393B311E2A1F38421D0D1A0044
        000044001A0F2F24423536333A3F2528101A0044000044001A1A1B20373D3C42
        40272D1C1A1A0044000044001A1A1A170B2C2B232221181A1A1A004400004400
        1A1A1A1A1A161312151A1A1A1A1A0044000044001A1A1A1A1A1A1A1A1A1A1A1A
        1A1A004400004400000000000000000000000000000000440000444444444444
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
      OnClick = Button8Click
    end
    object SpeedButton1: TSpeedButton
      Left = 102
      Top = 8
      Width = 33
      Height = 30
      Hint = 'Save the image as BMP or PNG file.'
      Enabled = False
      Glyph.Data = {
        F6010000424DF601000000000000760000002800000019000000180000000100
        04000000000080010000C30E0000C30E0000100000001000000000000000FF00
        00008484000084848400C6C6C600FFFFFF0040404000FFFFFF00FFFFFF00FFFF
        FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
        4444444444444000000044444444444644444444444440000000003404040443
        4044404404300000000004040404044440444046040400000000003403040034
        4003403304030000000004040004040440404064040440000000003404040034
        4003404404300000000044444444444444444444444440000000444444444444
        4444444444444000000044444300000000000034444440000000444440110311
        5440110444444000000044444011031154401104444440000000444440110433
        4440110444444000000044444011200000021104444440000000444440111111
        1111110444444000000044444012000000002104444440000000444440105555
        5555010444444000000044444010555555550104444440000000444440105555
        5555010444444000000044444010555555550104444440000000444440005555
        5555000444444000000044444010555555550104444440000000444443000000
        0000003444444000000044444444444444444444444440000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = SpeedButton1Click
    end
    object ToggleBatchPnlBtn: TSpeedButton
      Left = 641
      Top = 8
      Width = 154
      Height = 31
      Hint = 'open/close batch panel'
      Caption = 'M.C. batch render'
      Glyph.Data = {
        46020000424D460200000000000036000000280000000C0000000B0000000100
        200000000000100200000000000000000000000000000000000084C4C30084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C300000000000000000084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C300000000003C3C3C000000000084C4C30084C4C30084C4C30084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30000000000545454003C3C
        3C000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C3000000000054545400545454003C3C3C000000000084C4C30084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30000000000545454005454
        540054545400424242000000000084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C30000000000545454005454540059595900595959000000000084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30000000000545454005959
        5900646464000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C3000000000059595900646464000000000084C4C30084C4C30084C4
        C30084C4C30084C4C30084C4C30084C4C30084C4C30000000000646464000000
        000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C300000000000000000084C4C30084C4C30084C4C30084C4C30084C4
        C30084C4C30084C4C300}
      ParentShowHint = False
      ShowHint = True
      OnClick = ToggleBatchPnlBtnClick
    end
    object Button3: TButton
      Left = 244
      Top = 12
      Width = 105
      Height = 25
      Hint = 'Import the main programs parameter for mc rendering'
      Caption = 'Import parameter'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 360
      Top = 12
      Width = 127
      Height = 25
      Hint = 'send parameter to programs main render window'
      Caption = 'Send parameter to main'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button4Click
    end
    object Button6: TButton
      Left = 144
      Top = 12
      Width = 48
      Height = 25
      Hint = 'perform a noise filter on the image'
      Caption = '-noise'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Visible = False
      OnClick = Button6Click
    end
  end
  object BottomPnl: TPanel
    Left = 0
    Top = 502
    Width = 801
    Height = 60
    Align = alBottom
    TabOrder = 1
    object Label8: TLabel
      Left = 520
      Top = 8
      Width = 72
      Height = 13
      Caption = '..til next update'
      Visible = False
    end
    object Label14: TLabel
      Left = 362
      Top = 36
      Width = 3
      Height = 13
    end
    object Label15: TLabel
      Left = 425
      Top = 36
      Width = 3
      Height = 13
    end
    object Button1: TButton
      Left = 208
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 8
      Width = 144
      Height = 25
      Hint = 'You can always start/continue or stop the calculation'
      Caption = 'Start rendering'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button2Click
    end
    object ProgressBar1: TProgressBar
      Left = 360
      Top = 6
      Width = 150
      Height = 19
      TabOrder = 2
      Visible = False
    end
    object CheckBox5: TCheckBox
      Left = 21
      Top = 39
      Width = 134
      Height = 17
      Hint = 'Save the M3C file every update and 5 minutes passed'
      Alignment = taLeftJustify
      Caption = 'Auto-saving the m3c file:'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 45
    Width = 262
    Height = 457
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 262
      Height = 325
      Align = alClient
      TabOrder = 0
      object Label33: TLabel
        Left = 8
        Top = 233
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CategoryPanelGroup2: TCategoryPanelGroup
        Left = 1
        Top = 1
        Width = 260
        Height = 224
        VertScrollBar.Tracking = True
        VertScrollBar.Visible = False
        Align = alNone
        HeaderAlignment = taCenter
        HeaderFont.Charset = DEFAULT_CHARSET
        HeaderFont.Color = clWindowText
        HeaderFont.Height = -12
        HeaderFont.Name = 'Tahoma'
        HeaderFont.Style = []
        HeaderHeight = 22
        Images = ImageList1
        TabOrder = 0
        object CategoryPanel2: TCategoryPanel
          Top = 200
          Height = 28
          Caption = 'Statistics'
          Collapsed = True
          CollapsedHotImageIndex = 4
          CollapsedImageIndex = 0
          CollapsedPressedImageIndex = 4
          ExpandedHotImageIndex = 5
          ExpandedImageIndex = 1
          ExpandedPressedImageIndex = 5
          TabOrder = 0
          OnCollapse = CategoryPanel2Collapse
          OnExpand = CategoryPanel2Expand
          ExpandedHeight = 141
          object Label4: TLabel
            Left = 51
            Top = 12
            Width = 71
            Height = 13
            Alignment = taRightJustify
            Caption = 'Average noise:'
          end
          object Label5: TLabel
            Left = 35
            Top = 52
            Width = 87
            Height = 13
            Alignment = taRightJustify
            Caption = 'Average raycount:'
          end
          object Label2avrgnoise: TLabel
            Left = 138
            Top = 12
            Width = 3
            Height = 13
            Caption = ' '
          end
          object Label7avrgrays: TLabel
            Left = 138
            Top = 52
            Width = 3
            Height = 13
            Caption = ' '
          end
          object Label10: TLabel
            Left = 71
            Top = 31
            Width = 51
            Height = 13
            Alignment = taRightJustify
            Caption = 'Max noise:'
          end
          object Label11: TLabel
            Left = 55
            Top = 71
            Width = 67
            Height = 13
            Alignment = taRightJustify
            Caption = 'Max raycount:'
          end
          object Label12: TLabel
            Left = 138
            Top = 31
            Width = 3
            Height = 13
            Caption = ' '
          end
          object Label13: TLabel
            Left = 138
            Top = 71
            Width = 3
            Height = 13
            Caption = ' '
          end
          object Label18: TLabel
            Left = 19
            Top = 93
            Width = 103
            Height = 13
            Alignment = taRightJustify
            Caption = 'Total calculation time:'
          end
          object Label19: TLabel
            Left = 138
            Top = 93
            Width = 3
            Height = 13
            Caption = ' '
          end
        end
        object CategoryPanel6: TCategoryPanel
          Tag = 1
          Top = 172
          Height = 28
          Caption = 'Depth of Field'
          Collapsed = True
          CollapsedHotImageIndex = 4
          CollapsedImageIndex = 0
          CollapsedPressedImageIndex = 4
          ExpandedHotImageIndex = 5
          ExpandedImageIndex = 1
          ExpandedPressedImageIndex = 5
          TabOrder = 1
          OnCollapse = CategoryPanel2Collapse
          OnExpand = CategoryPanel2Expand
          ExpandedHeight = 142
          object Image2: TImage
            Left = 185
            Top = 35
            Width = 33
            Height = 33
            Visible = False
          end
          object Label23: TLabel
            Left = 84
            Top = 44
            Width = 45
            Height = 13
            AutoSize = False
            Caption = 'Bokeh:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label22: TLabel
            Left = 132
            Top = 44
            Width = 14
            Height = 13
            Alignment = taCenter
            AutoSize = False
            Caption = '1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label3: TLabel
            Left = 6
            Top = 99
            Width = 245
            Height = 13
            Caption = 'More options: send paras to main, adjust and import.'
          end
          object Label26: TLabel
            Left = 4
            Top = 77
            Width = 248
            Height = 13
            Caption = 'Only 1 focuspoint, made from average of Zsharp1+2!'
          end
          object CheckBox4: TCheckBox
            Left = 55
            Top = 11
            Width = 110
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Calculate DoF:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = CheckBox4Click
          end
          object UpDown2: TUpDown
            Left = 151
            Top = 42
            Width = 23
            Height = 21
            Enabled = False
            Min = 1
            Max = 9999
            Position = 5000
            TabOrder = 1
            OnClick = UpDown2Click
          end
        end
        object CategoryPanel5: TCategoryPanel
          Tag = 15
          Top = 144
          Height = 28
          Caption = 'Reflections + Transparency'
          Collapsed = True
          CollapsedHotImageIndex = 4
          CollapsedImageIndex = 0
          CollapsedPressedImageIndex = 4
          ExpandedHotImageIndex = 5
          ExpandedImageIndex = 1
          ExpandedPressedImageIndex = 5
          TabOrder = 2
          OnCollapse = CategoryPanel2Collapse
          OnExpand = CategoryPanel2Expand
          ExpandedHeight = 184
          object Label20: TLabel
            Left = 24
            Top = 35
            Width = 129
            Height = 16
            Alignment = taRightJustify
            Caption = 'Reflection rays depth:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label21: TLabel
            Left = 43
            Top = 64
            Width = 110
            Height = 16
            Alignment = taRightJustify
            Caption = 'Reflection diffusity:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label25: TLabel
            Left = 5
            Top = 141
            Width = 245
            Height = 13
            Caption = 'More options: send paras to main, adjust and import.'
          end
          object CheckBox2: TCheckBox
            Left = 30
            Top = 9
            Width = 145
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Calculate reflections:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = CheckBox2Click
          end
          object Edit1: TEdit
            Left = 162
            Top = 34
            Width = 30
            Height = 21
            Hint = 
              'determines how many following straight reflections will be calcu' +
              'lated'
            Enabled = False
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 1
            Text = '3'
          end
          object UpDown1: TUpDown
            Left = 192
            Top = 34
            Width = 18
            Height = 21
            Associate = Edit1
            Enabled = False
            Min = 1
            Max = 30
            Position = 3
            TabOrder = 2
          end
          object Edit2: TEdit
            Left = 162
            Top = 62
            Width = 48
            Height = 21
            Hint = 'Makes reflections a little diffuse, value range from 0 to 2.5'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Text = '0.0'
          end
          object CheckBox3: TCheckBox
            Left = 13
            Top = 91
            Width = 162
            Height = 17
            Hint = 'Reflections must be calculated too, else this has no effect'
            Alignment = taLeftJustify
            Caption = 'Calculate transparency:'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
          end
          object Button5: TButton
            Left = 191
            Top = 91
            Width = 54
            Height = 39
            Hint = 
              'Verify that sum of diffuse and specular colors dont exceed 1, de' +
              'pending on the choosen options'
            Caption = 'Check colors'
            Enabled = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            WordWrap = True
            OnClick = Button5Click
          end
          object CheckBox7: TCheckBox
            Left = 42
            Top = 113
            Width = 133
            Height = 17
            Hint = 
              'Verify while calculating if specular+diffuse amount exceeds 1.  ' +
              'Useful when using diffmaps.'
            Alignment = taLeftJustify
            Caption = 'Autoclip spec+diff :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
          end
        end
        object CategoryPanel1: TCategoryPanel
          Top = 0
          Height = 144
          Caption = 'Calculation options'
          CollapsedHotImageIndex = 4
          CollapsedImageIndex = 0
          CollapsedPressedImageIndex = 4
          ExpandedHotImageIndex = 5
          ExpandedImageIndex = 1
          ExpandedPressedImageIndex = 5
          TabOrder = 3
          OnCollapse = CategoryPanel2Collapse
          OnExpand = CategoryPanel2Expand
          object Label9: TLabel
            Left = 35
            Top = 10
            Width = 118
            Height = 16
            Alignment = taRightJustify
            Caption = 'Ambient rays depth:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label6: TLabel
            Left = 30
            Top = 63
            Width = 123
            Height = 16
            Alignment = taRightJustify
            Caption = 'Hard shadow radius:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label24: TLabel
            Left = 78
            Top = 90
            Width = 75
            Height = 16
            Alignment = taRightJustify
            Caption = 'Anti aliasing:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Edit21: TEdit
            Left = 162
            Top = 9
            Width = 30
            Height = 21
            Hint = 
              'determines how many following objects diffuse reflections will b' +
              'e calculated'
            ParentShowHint = False
            ReadOnly = True
            ShowHint = True
            TabOrder = 0
            Text = '3'
          end
          object UpDown3: TUpDown
            Left = 192
            Top = 9
            Width = 18
            Height = 21
            Associate = Edit21
            Min = 1
            Max = 30
            Position = 3
            TabOrder = 1
          end
          object CheckBox6: TCheckBox
            Left = 29
            Top = 37
            Width = 146
            Height = 17
            Hint = 
              'A faster method than binsearch, but can lead to failures if DE'#39's' +
              ' are bad'
            Alignment = taLeftJustify
            Caption = 'Secant searchmode:'
            Checked = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 2
          end
          object Edit3: TEdit
            Left = 162
            Top = 62
            Width = 48
            Height = 21
            Hint = 
              'Softens the hard shadows. The value is relative to the size of t' +
              'he lightsource, a bigger value leads to a softer shadow.'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Serif'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            Text = '1.0'
          end
          object ComboBox1: TComboBox
            Left = 162
            Top = 89
            Width = 67
            Height = 21
            Style = csDropDownList
            ItemIndex = 0
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            Text = 'Box'
            Items.Strings = (
              'Box'
              'Gauss')
          end
        end
      end
    end
    object Panel5: TPanel
      Left = 0
      Top = 325
      Width = 262
      Height = 132
      Align = alBottom
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 3
        Width = 49
        Height = 16
        Caption = 'Lighting:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 7
        Top = 37
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Exposure:  0.25'
      end
      object Label7: TLabel
        Left = 232
        Top = 37
        Width = 21
        Height = 13
        Caption = '2.24'
      end
      object Label29: TLabel
        Left = 12
        Top = 68
        Width = 69
        Height = 13
        Alignment = taRightJustify
        Caption = 'L-Gamma:  0.5'
      end
      object Label30: TLabel
        Left = 232
        Top = 68
        Width = 6
        Height = 13
        Caption = '2'
      end
      object Label31: TLabel
        Left = 9
        Top = 99
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = 'Saturation:   0  '
      end
      object Label32: TLabel
        Left = 232
        Top = 99
        Width = 6
        Height = 13
        Caption = '2'
      end
      object TrackBar1: TTrackBar
        Left = 83
        Top = 33
        Width = 145
        Height = 25
        Hint = 
          'If selected, press '#39'1'#39' to set this slider to the default positio' +
          'n.'
        Max = 255
        ParentShowHint = False
        Frequency = 128
        Position = 128
        SelStart = 128
        ShowHint = True
        TabOrder = 0
        ThumbLength = 18
        OnChange = TrackBar1Change
        OnKeyPress = TrackBar18KeyPress
      end
      object TrackBar3: TTrackBar
        Left = 83
        Top = 64
        Width = 145
        Height = 25
        Max = 63
        ParentShowHint = False
        Frequency = 128
        Position = 32
        SelStart = 32
        ShowHint = True
        TabOrder = 1
        ThumbLength = 18
        OnChange = TrackBar1Change
        OnKeyPress = TrackBar18KeyPress
      end
      object CheckBox8: TCheckBox
        Left = 137
        Top = 10
        Width = 84
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Soft clipping:'
        TabOrder = 2
        OnClick = TrackBar1Change
      end
      object TrackBar4: TTrackBar
        Left = 83
        Top = 95
        Width = 145
        Height = 25
        Max = 63
        Frequency = 128
        Position = 32
        SelStart = 32
        TabOrder = 3
        ThumbLength = 18
        OnChange = TrackBar1Change
        OnKeyPress = TrackBar18KeyPress
      end
    end
  end
  object ScrollBox1: TScrollBox
    Left = 262
    Top = 45
    Width = 277
    Height = 457
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 1
      Height = 1
      AutoSize = True
    end
  end
  object BatchPnl: TPanel
    Left = 539
    Top = 45
    Width = 262
    Height = 457
    Align = alRight
    TabOrder = 4
    Visible = False
    object Label16: TLabel
      Left = 120
      Top = 367
      Width = 85
      Height = 16
      Alignment = taRightJustify
      Caption = 'Max ray count:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object BatchOpenM3PSequenceBtn: TButton
      Left = 45
      Top = 6
      Width = 178
      Height = 25
      Hint = 'Import the main programs parameter for mc rendering'
      Caption = 'Open *.m3p-sequence'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BatchOpenM3PSequenceBtnClick
    end
    object BatchProgressBar: TProgressBar
      Left = 6
      Top = 403
      Width = 250
      Height = 17
      Smooth = True
      Step = 1
      TabOrder = 1
    end
    object BatchRenderBtn: TButton
      Left = 45
      Top = 426
      Width = 178
      Height = 25
      Caption = 'Start batch rendering'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BatchRenderBtnClick
    end
    object BatchMaxRayCountEdit: TEdit
      Left = 209
      Top = 366
      Width = 30
      Height = 21
      Hint = 'Determines when to stop rendering in batch-mode'
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      Text = '4'
    end
    object BatchMaxRayCountUpDown: TUpDown
      Left = 239
      Top = 366
      Width = 16
      Height = 21
      Associate = BatchMaxRayCountEdit
      Min = 1
      Max = 30
      Position = 4
      TabOrder = 4
    end
    object BatchEntriesGrid: TStringGrid
      Left = 6
      Top = 37
      Width = 250
      Height = 288
      ColCount = 3
      FixedCols = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 5
      RowHeights = (
        24
        18
        24
        23
        24)
    end
    object ClearBatchLstBtn: TButton
      Left = 6
      Top = 331
      Width = 64
      Height = 25
      Caption = 'Clear'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = ClearBatchLstBtnClick
    end
    object RemoveBatchLstEntryBtn: TButton
      Left = 190
      Top = 331
      Width = 64
      Height = 25
      Caption = 'Del Entry'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = RemoveBatchLstEntryBtnClick
    end
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer2Timer
    Left = 296
    Top = 456
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 264
    Top = 456
  end
  object SaveDialog3: TSaveDialog
    DefaultExt = 'm3c'
    Filter = 'M3D monte carlo file (*.m3c)|*.m3c'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 328
    Top = 56
  end
  object SaveDialog6: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 
      'Windows Bitmap|*.bmp|Portable Network Graphic|*.png|JPEG image|*' +
      '.jpg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog6TypeChange
    Left = 392
    Top = 56
  end
  object ImageList1: TImageList
    Masked = False
    Width = 32
    Left = 457
    Top = 56
    Bitmap = {
      494C010108000E00300020001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
  object Timer3: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer3Timer
    Left = 344
    Top = 456
  end
  object ToggleBtnImageList: TImageList
    Height = 11
    Masked = False
    Width = 12
    Left = 661
    Top = 286
    Bitmap = {
      494C0101040009005C000C000B00FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000300000001600000001002000000000008010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      00000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      00000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C3000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084C4C30084C4C30084C4C30084C4C3000000
      00003C3C3C000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C300000000003C3C
      3C000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C300000000000000000084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C3000000000029292900484848004848480048484800484848004848
      480048484800292929000000000084C4C30084C4C30084C4C30084C4C3000000
      0000545454003C3C3C000000000084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C300000000003C3C3C005454
      54000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C3000000000046464600464646000000000084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30000000000353535005454540054545400545454005454
      5400353535000000000084C4C30084C4C30084C4C30084C4C30084C4C3000000
      000054545400545454003C3C3C000000000084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C300000000003C3C3C00545454005454
      54000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      0000414141006363630063636300414141000000000084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C300000000004141410063636300636363004141
      41000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      0000545454005454540054545400424242000000000084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C300000000004242420054545400545454005454
      54000000000084C4C30084C4C30084C4C30084C4C30084C4C300000000003535
      350054545400545454005454540054545400353535000000000084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C3000000000046464600464646000000
      000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      0000545454005454540059595900595959000000000084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C300000000005959590059595900545454005454
      54000000000084C4C30084C4C30084C4C30084C4C30000000000292929004848
      48004848480048484800484848004848480048484800292929000000000084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C300000000000000000084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      00005454540059595900646464000000000084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C3000000000064646400595959005454
      54000000000084C4C30084C4C30084C4C30084C4C30000000000000000000000
      00000000000000000000000000000000000000000000000000000000000084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      000059595900646464000000000084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30000000000646464005959
      59000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      0000646464000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C300000000006464
      64000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      00000000000084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4
      C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C30084C4C3000000
      00000000000084C4C30084C4C30084C4C300424D3E000000000000003E000000
      2800000030000000160000000100010000000000B00000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000}
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'm3p'
    Filter = 'M3D parameter (*.m3p)|*.m3p'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 666
    Top = 210
  end
end
