object Mand3DForm: TMand3DForm
  Left = 65
  Top = 100
  ClientHeight = 572
  ClientWidth = 771
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDragOver = FormDragOver
  OnHide = FormHide
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 618
    Top = 0
    Width = 153
    Height = 572
    Align = alRight
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 411
      Width = 151
      Height = 80
      Hint = 'Shows messages'
      Align = alTop
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
      TabOrder = 2
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 147
      Width = 151
      Height = 264
      ActivePage = TabSheet4
      Align = alTop
      BiDiMode = bdLeftToRight
      DoubleBuffered = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HotTrack = True
      MultiLine = True
      ParentBiDiMode = False
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      Touch.ParentTabletOptions = False
      Touch.TabletOptions = []
      OnChange = PageControl1Change
      object TabSheet2: TTabSheet
        Caption = 'Calculation'
        Highlighted = True
        ImageIndex = 1
        object Label16: TLabel
          Left = 4
          Top = 125
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'Smooth  normals:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label18: TLabel
          Left = 44
          Top = 6
          Width = 41
          Height = 13
          Alignment = taRightJustify
          Caption = 'DE stop:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label22: TLabel
          Left = 0
          Top = 51
          Width = 85
          Height = 13
          Alignment = taRightJustify
          Caption = 'Raystep multiplier:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label13: TLabel
          Left = 18
          Top = 93
          Width = 67
          Height = 26
          Alignment = taRightJustify
          Caption = 'Stepcount for '#13#10'binary search:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton10: TSpeedButton
          Left = 0
          Top = 0
          Width = 23
          Height = 22
          Hint = 
            'Click on "M" to save these settings plus image width and scale'#13#10 +
            'as a preset. Click afterwards on "preview",  "mid" or "high"'#13#10'or' +
            ' again on "M" to cancel.'
          AllowAllUp = True
          GroupIndex = 5
          Caption = 'M'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton10Click
        end
        object Label26: TLabel
          Left = 6
          Top = 74
          Width = 79
          Height = 13
          Alignment = taRightJustify
          Caption = 'Stepwidth limiter:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit25: TEdit
          Left = 92
          Top = 3
          Width = 49
          Height = 21
          Hint = 
            'Defines the distance to the objects surface where raymarching st' +
            'ops.'#13#10'Lower values gives more object details, but can also lead ' +
            'to undersampling.'#13#10'The value is related to the width of a pixel.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = '1.0'
          OnChange = SpinEdit2Change
        end
        object CheckBox9: TCheckBox
          Left = 12
          Top = 27
          Width = 125
          Height = 17
          Hint = 
            'The distance to the objects surface, the raymarching stops, will' +
            ' get bigger with the distance to the viewer.'#13#10'This leads to a ho' +
            'mogen object appearence, so it is normally choosen.'
          Alignment = taLeftJustify
          Caption = 'Vary DEstop on FOV:'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 1
        end
        object CheckBox1: TCheckBox
          Left = 39
          Top = 147
          Width = 98
          Height = 17
          Hint = 'Uncheck this, if the image looks flat and noisy.'
          Alignment = taLeftJustify
          Caption = 'Normals on DE:'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 6
        end
        object Edit6: TEdit
          Left = 92
          Top = 48
          Width = 49
          Height = 21
          Hint = 
            'The distance estimates are downscaled by this factor to avoid ov' +
            'erstepping.'#13#10'Reduce the value if overstepping occurs (black pixe' +
            'ls, noisy image).'#13#10'Too low values slows the rendering down.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = '0.5'
          OnChange = SpinEdit2Change
        end
        object CheckBox3: TCheckBox
          Left = 30
          Top = 164
          Width = 107
          Height = 17
          Hint = 
            'Multiplies the first stepwidth with a random number'#13#10'to give ove' +
            'rstepping artifacts a noisy look.  '#13#10'Also reduces banding in the' +
            ' dynamic fog. '
          Alignment = taLeftJustify
          Caption = 'First step random:'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 7
        end
        object CheckBox8: TCheckBox
          Left = 1
          Top = 198
          Width = 136
          Height = 17
          Hint = 'Useful for steep heightmaps'
          Alignment = taLeftJustify
          Caption = 'Shortdistance check DE:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 9
          Visible = False
        end
        object Edit8: TEdit
          Left = 92
          Top = 71
          Width = 49
          Height = 21
          Hint = 'Use values lower than 1 to reduce overstepping.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = '1.0'
          OnChange = SpinEdit2Change
        end
        object Edit19: TEdit
          Left = 92
          Top = 122
          Width = 30
          Height = 21
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 5
          Text = '0'
        end
        object SpinEdit2: TUpDown
          Left = 122
          Top = 122
          Width = 19
          Height = 21
          Associate = Edit19
          Max = 8
          TabOrder = 10
          OnChangingEx = SpinEdit2ChangingEx
        end
        object Edit20: TEdit
          Left = 92
          Top = 97
          Width = 30
          Height = 21
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 4
          Text = '8'
        end
        object SpinEdit5: TUpDown
          Left = 122
          Top = 97
          Width = 19
          Height = 21
          Associate = Edit20
          Max = 31
          Position = 8
          TabOrder = 11
          OnChangingEx = SpinEdit2ChangingEx
        end
        object CheckBox2: TCheckBox
          Left = 13
          Top = 181
          Width = 124
          Height = 17
          Hint = 
            'Subtract an amount of DEstop from next raystep, recommended on h' +
            'igh DEstop values.'
          Alignment = taLeftJustify
          Caption = 'Raystep sub DEstop:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 8
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Internal'
        ImageIndex = 3
        object Label15: TLabel
          Left = 12
          Top = 11
          Width = 68
          Height = 26
          Alignment = taRightJustify
          Caption = 'Threadcount  '#13#10'in Calculations'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object Label3: TLabel
          Left = 20
          Top = 160
          Width = 3
          Height = 13
        end
        object Label17: TLabel
          Left = 20
          Top = 176
          Width = 49
          Height = 13
          Caption = 'its for free!'
        end
        object Label33: TLabel
          Left = 13
          Top = 74
          Width = 34
          Height = 26
          Alignment = taRightJustify
          Caption = 'Thread'#13#10'Priority'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object ComboBox2: TComboBox
          Left = 56
          Top = 76
          Width = 81
          Height = 21
          Style = csDropDownList
          ItemIndex = 2
          TabOrder = 0
          Text = 'Lower'
          OnChange = CheckBox14Click
          Items.Strings = (
            'Idle'
            'Lowest'
            'Lower'
            'Normal')
        end
        object CheckBox12: TCheckBox
          Left = 10
          Top = 43
          Width = 111
          Height = 17
          Hint = 
            'Detects the amount of processor cores on startup.'#13#10'You can choos' +
            'e the amount yourself and disable'#13#10'this option to start with dif' +
            'ferent settings.'
          Alignment = taLeftJustify
          Caption = 'Autodetect on start'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 1
        end
        object CheckBox14: TCheckBox
          Left = 8
          Top = 122
          Width = 113
          Height = 17
          Hint = 
            'Check this to stop setting the slowest thread to a higher priori' +
            'ty.'
          Alignment = taLeftJustify
          Caption = 'Disable threadboost'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          OnClick = CheckBox14Click
        end
        object CheckBox15: TCheckBox
          Left = 24
          Top = 104
          Width = 97
          Height = 17
          Hint = 
            'Prevent the computer from shutdown by moving'#13#10'the mouse cursor f' +
            'rom time to time a bit.'
          Alignment = taLeftJustify
          Caption = 'Keep this priority'
          TabOrder = 3
        end
        object Edit21: TEdit
          Left = 91
          Top = 14
          Width = 30
          Height = 21
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 4
          Text = '1'
        end
        object UpDown3: TUpDown
          Left = 121
          Top = 14
          Width = 19
          Height = 21
          Associate = Edit21
          Min = 1
          Max = 64
          Position = 1
          TabOrder = 5
          OnChangingEx = SpinEdit2ChangingEx
        end
      end
      object TabSheet5: TTabSheet
        Caption = 'Infos'
        ImageIndex = 4
        object Label29: TLabel
          Left = 9
          Top = 67
          Width = 67
          Height = 13
          Alignment = taRightJustify
          Caption = 'Avg. raysteps:'
        end
        object Label30: TLabel
          Left = 6
          Top = 88
          Width = 70
          Height = 13
          Caption = 'Avg. iterations:'
        end
        object Label31: TLabel
          Left = 86
          Top = 67
          Width = 3
          Height = 13
        end
        object Label32: TLabel
          Left = 86
          Top = 88
          Width = 3
          Height = 13
        end
        object Label51: TLabel
          Left = 6
          Top = 127
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = 'Main calc time:'
        end
        object Label52: TLabel
          Left = 86
          Top = 127
          Width = 3
          Height = 13
        end
        object Label7: TLabel
          Left = 14
          Top = 145
          Width = 63
          Height = 13
          Alignment = taRightJustify
          Caption = 'HS calc time:'
        end
        object Label8: TLabel
          Left = 86
          Top = 145
          Width = 3
          Height = 13
        end
        object Label34: TLabel
          Left = 6
          Top = 106
          Width = 71
          Height = 13
          Alignment = taRightJustify
          Caption = 'Max. iterations:'
        end
        object Label40: TLabel
          Left = 86
          Top = 106
          Width = 3
          Height = 13
        end
        object Label47: TLabel
          Left = 14
          Top = 163
          Width = 63
          Height = 13
          Alignment = taRightJustify
          Caption = 'AO calc time:'
        end
        object Label48: TLabel
          Left = 86
          Top = 163
          Width = 3
          Height = 13
        end
        object Label49: TLabel
          Left = 13
          Top = 181
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = 'Reflects time:'
        end
        object Label50: TLabel
          Left = 86
          Top = 181
          Width = 3
          Height = 13
        end
        object Label60: TLabel
          Left = 4
          Top = 25
          Width = 22
          Height = 13
          Alignment = taRightJustify
          Caption = 'Orig:'
        end
        object Label59: TLabel
          Left = 2
          Top = 46
          Width = 24
          Height = 13
          Alignment = taRightJustify
          Caption = 'Mod:'
        end
        object Edit33: TEdit
          Left = 32
          Top = 23
          Width = 109
          Height = 19
          Ctl3D = False
          MaxLength = 16
          ParentCtl3D = False
          TabOrder = 0
          OnChange = Edit33Change
        end
        object Edit34: TEdit
          Left = 32
          Top = 44
          Width = 109
          Height = 19
          Ctl3D = False
          MaxLength = 16
          ParentCtl3D = False
          TabOrder = 1
          OnChange = Edit34Change
        end
        object ButtonAuthor: TButton
          Left = 32
          Top = 0
          Width = 57
          Height = 22
          Hint = 'Click to choose your name for automatic saving in parameters'
          Caption = 'Author:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = ButtonAuthorClick
        end
        object ButtonInsertAuthor: TButton
          Left = 95
          Top = 0
          Width = 46
          Height = 22
          Hint = 'Click to insert your name below'
          Caption = 'insert'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = ButtonInsertAuthorClick
        end
      end
      object TabSheet8: TTabSheet
        Caption = 'Cutting'
        ImageIndex = 7
        object Label37: TLabel
          Left = 9
          Top = 66
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Z:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label38: TLabel
          Left = 9
          Top = 18
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'X:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label39: TLabel
          Left = 9
          Top = 42
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Y:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit22: TEdit
          Left = 28
          Top = 63
          Width = 93
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '0.00'
        end
        object Edit23: TEdit
          Left = 28
          Top = 15
          Width = 93
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '0.00'
        end
        object Edit24: TEdit
          Left = 28
          Top = 39
          Width = 93
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '0.00'
        end
        object CheckBox4: TCheckBox
          Left = 126
          Top = 17
          Width = 17
          Height = 17
          TabOrder = 3
          OnClick = CheckBox7Click
        end
        object CheckBox5: TCheckBox
          Left = 126
          Top = 41
          Width = 17
          Height = 17
          TabOrder = 4
          OnClick = CheckBox7Click
        end
        object CheckBox6: TCheckBox
          Left = 126
          Top = 65
          Width = 17
          Height = 17
          TabOrder = 5
          OnClick = CheckBox7Click
        end
        object Button19: TButton
          Left = 28
          Top = 96
          Width = 109
          Height = 21
          Hint = 'Inserts the current mid position.'
          Caption = 'Insert mid values'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = Button19Click
        end
        object Button20: TButton
          Tag = 6
          Left = 16
          Top = 124
          Width = 121
          Height = 21
          Hint = 
            'Click on the button and afterwards on the object in the image to' +
            ' get'#13#10'the values from there.'
          Caption = 'Get values from image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = Button16Click
        end
      end
      object TabSheet9: TTabSheet
        Caption = 'Julia Off'
        ImageIndex = 8
        object Label43: TLabel
          Left = 9
          Top = 80
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Z:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label44: TLabel
          Left = 9
          Top = 32
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'X:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label45: TLabel
          Left = 9
          Top = 56
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Y:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 5
          Top = 104
          Width = 14
          Height = 13
          Alignment = taRightJustify
          Caption = 'W:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object CheckBox7: TCheckBox
          Left = 24
          Top = 8
          Width = 113
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Calculate Julia'
          TabOrder = 0
          OnClick = CheckBox7Click
        end
        object Edit28: TEdit
          Left = 28
          Top = 29
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '1.00'
        end
        object Edit29: TEdit
          Left = 28
          Top = 53
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '0.00'
        end
        object Edit30: TEdit
          Left = 28
          Top = 77
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = '0.00'
        end
        object Button13: TButton
          Left = 28
          Top = 128
          Width = 109
          Height = 21
          Hint = 
            'Inserts the current position as julia values.'#13#10'If in 4d mode, th' +
            'e vector is rotated according to the 4d rotation values.'
          Caption = 'Insert mid values'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = Button13Click
        end
        object Edit7: TEdit
          Left = 28
          Top = 101
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          Text = '0.00'
        end
        object Button16: TButton
          Tag = 3
          Left = 16
          Top = 156
          Width = 121
          Height = 21
          Hint = 
            'Click on the button and afterwards on the object in the image to' +
            ' get'#13#10'the julia values from there.'#13#10'If in 4d mode, the vector is' +
            ' rotated according to the 4d rotation values.'#13#10#13#10'Hint: Get the v' +
            'alues from the non julia calculated object, else the result'#13#10'has' +
            ' no real relation to that point.'
          Caption = 'Get values from image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = Button16Click
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Camera'
        ImageIndex = 5
        object Label21: TLabel
          Left = 24
          Top = 10
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'FOVy:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit14: TEdit
          Left = 64
          Top = 7
          Width = 73
          Height = 21
          Hint = 'Vertical field of view in degrees'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = '30'
        end
        object RadioGroup2: TRadioGroup
          Left = 19
          Top = 41
          Width = 110
          Height = 96
          Caption = 'Camera lense:'
          ItemIndex = 0
          Items.Strings = (
            'Common'
            'Rectilinear'
            '360 Panorama')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TabStop = True
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Coloring'
        ImageIndex = 6
        object Label2: TLabel
          Left = 5
          Top = 132
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Lli multiplier:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label58: TLabel
          Left = 7
          Top = 156
          Width = 72
          Height = 13
          Alignment = taRightJustify
          Caption = 'Color on Iterat.:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label61: TLabel
          Left = 126
          Top = 180
          Width = 13
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '0'
          Visible = False
        end
        object RadioGroup1: TRadioGroup
          Left = 4
          Top = 2
          Width = 140
          Height = 123
          Hint = 
            'The map options calculates x,y coordinates from the specific'#13#10've' +
            'ctor for spherical maps, this changes also the first color choic' +
            'e'#13#10'that is usually based on smooth iterations.'#13#10'You have to reca' +
            'lculate the image to see the result of this'#13#10'options changes.'
          Caption = 'Mode for 2. color choice:'
          ItemIndex = 0
          Items.Strings = (
            'Orbit trap (mindist. to 0)'
            'Last length increase'
            'Rout angle of X, Y'
            'Rout angle of X, Z'
            'Rout angle of Y, Z'
            'Map on output vector')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 71
          Top = 129
          Width = 65
          Height = 21
          Hint = 
            'Multiplier for the '#39'Last length increase'#39' option.'#13#10'Decrease the ' +
            'value on high powers, increase on formulas with low scales.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = '1.0'
        end
        object Edit16: TEdit
          Left = 87
          Top = 177
          Width = 49
          Height = 21
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = '0'
        end
        object Edit35: TEdit
          Left = 87
          Top = 153
          Width = 49
          Height = 21
          Hint = 
            'Does the coloring after this number of iterations and not from b' +
            'ailout (-1,  disabled)'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Text = '-1'
        end
        object ButtonVolLight: TButton
          Left = 1
          Top = 175
          Width = 83
          Height = 25
          Hint = 
            'Press to switch between dynamic fog on iterations and volumetric' +
            ' light on light nr'
          Caption = 'Dyn. fog on It.:'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = ButtonVolLightClick
        end
        object UpDown5: TUpDown
          Left = 107
          Top = 176
          Width = 19
          Height = 22
          Hint = 'Tune the size of the volumetric map in 20% steps'
          Min = -2
          Max = 9
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Visible = False
          OnClick = UpDown5Click
        end
      end
      object TabSheet6: TTabSheet
        Caption = 'Stereo'
        ImageIndex = 7
        object Label28: TLabel
          Left = 25
          Top = 62
          Width = 60
          Height = 13
          Alignment = taRightJustify
          Caption = 'Image width:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label35: TLabel
          Left = 5
          Top = 38
          Width = 80
          Height = 13
          Alignment = taRightJustify
          Caption = 'Screen distance:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label27: TLabel
          Left = 4
          Top = 86
          Width = 81
          Height = 13
          Alignment = taRightJustify
          Caption = 'Minimal distance:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label36: TLabel
          Left = 11
          Top = 12
          Width = 124
          Height = 13
          Caption = 'All realworld units in meter.'
        end
        object Edit15: TEdit
          Left = 91
          Top = 59
          Width = 49
          Height = 21
          Hint = 'Defines the realworld image width on the screen in meters.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          Text = '1.0'
          OnChange = SpinEdit2Change
        end
        object Edit18: TEdit
          Left = 91
          Top = 35
          Width = 49
          Height = 21
          Hint = 'Defines the realworld distance to the viewing screen in meters.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = '2.0'
          OnChange = SpinEdit2Change
        end
        object Edit13: TEdit
          Left = 91
          Top = 83
          Width = 49
          Height = 21
          Hint = 
            'Defines how near (in meters) the Zstart plane lies in front of y' +
            'ou.'#13#10'It is also the minimum distance that a (virtual) object can' +
            ' appear.'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Text = '1.5'
          OnChange = SpinEdit2Change
        end
        object Button12: TButton
          Tag = 1
          Left = 8
          Top = 175
          Width = 131
          Height = 22
          Hint = 'Use the default image for the right eye'
          Caption = 'Calc very left from midpos'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = Button12Click
        end
        object Button17: TButton
          Tag = 4
          Left = 11
          Top = 8
          Width = 131
          Height = 21
          Hint = 
            'Click on the button and afterwards on the object in the image to' +
            ' get'#13#10'the non shifted object distance.'#13#10'The object part would ap' +
            'pear in the real distance of the screen.'
          Caption = 'Get min.dist. from image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          Visible = False
          OnClick = Button16Click
        end
        object Button1: TButton
          Tag = 4
          Left = 8
          Top = 114
          Width = 131
          Height = 22
          Hint = 
            'After calculation all user light changes are cancelled because o' +
            'f different lightangles.'#13#10'Calculating in normal mode will enable' +
            ' it again.'
          Caption = 'Calculate left eye image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          OnClick = Button12Click
        end
        object Button6: TButton
          Tag = 3
          Left = 8
          Top = 142
          Width = 131
          Height = 22
          Hint = 
            'After calculation all user light changes are cancelled because o' +
            'f different lightangles.'#13#10'Calculating in normal mode will enable' +
            ' it again.'
          Caption = 'Calculate right eye image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = Button12Click
        end
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 531
      Width = 151
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Image2: TImage
        Left = 127
        Top = 16
        Width = 24
        Height = 24
        Cursor = crSizeNWSE
        Align = alCustom
        AutoSize = True
        Picture.Data = {
          07544269746D6170F6060000424DF60600000000000036000000280000001800
          0000180000000100180000000000C0060000C30E0000C30E0000000000000000
          0000D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFF
          FF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFFFF
          99A8AC99A8ACD8E9ECFFFFFF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF99
          A8AC99A8ACD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFFFF99A8ACD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFFFF99A8AC99A8ACD8E9ECFF
          FFFFD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFF
          FF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF
          99A8AC99A8ACD8E9ECFFFFFF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFFFFFF99A8ACD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECFF
          FFFFD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFF
          FF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECFFFFFF99A8AC99A8ACD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFFFFFF99A8ACD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECFF
          FFFFD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9EC
          D8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9
          ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8E9ECD8
          E9EC}
        Transparent = True
        OnMouseDown = Image2MouseDown
        OnMouseMove = Image2MouseMove
        ExplicitWidth = 19
        ExplicitHeight = 20
      end
      object Label19: TLabel
        Left = 8
        Top = 2
        Width = 3
        Height = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 35
        Top = 20
        Width = 3
        Height = 13
      end
    end
    object CategoryPanelGroup1: TCategoryPanelGroup
      Left = 1
      Top = 1
      Width = 151
      Height = 51
      VertScrollBar.Tracking = True
      VertScrollBar.Visible = False
      Align = alTop
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -12
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      HeaderHeight = 20
      TabOrder = 3
      object CategoryPanel2: TCategoryPanel
        Top = 26
        Height = 26
        Caption = 'Rotation'
        Collapsed = True
        TabOrder = 0
        OnCollapse = CategoryPanel2Collapse
        OnExpand = CategoryPanel2Expand
        ExpandedHeight = 181
        object Label53: TLabel
          Left = 10
          Top = 3
          Width = 61
          Height = 13
          Alignment = taCenter
          Caption = 'Euler angles:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label54: TLabel
          Left = 9
          Top = 24
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'X:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label55: TLabel
          Left = 9
          Top = 48
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Y:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label56: TLabel
          Left = 9
          Top = 72
          Width = 10
          Height = 13
          Alignment = taRightJustify
          Caption = 'Z:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label57: TLabel
          Left = 2
          Top = 119
          Width = 134
          Height = 39
          Alignment = taCenter
          Caption = 'Apply your changed values, because edits are only output'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          WordWrap = True
        end
        object Edit27: TEdit
          Left = 25
          Top = 21
          Width = 120
          Height = 21
          TabOrder = 0
          Text = '0.0'
          OnChange = SpinEdit2Change
        end
        object Edit31: TEdit
          Left = 25
          Top = 45
          Width = 120
          Height = 21
          Hint = 
            'Case Y angle is at 90 or -90 degrees, euler angles can'#39't be calc' +
            'ulated!'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          Text = '0.0'
          OnChange = SpinEdit2Change
        end
        object Edit32: TEdit
          Left = 25
          Top = 69
          Width = 120
          Height = 21
          TabOrder = 2
          Text = '0.0'
          OnChange = SpinEdit2Change
        end
        object Button7: TButton
          Left = 3
          Top = 94
          Width = 88
          Height = 22
          Hint = 'The rotation is performed around the Midpoint (Xmid, Ymid, Zmid)'
          Caption = 'Apply to image'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = Button7Click
        end
        object ButtonR0: TButton
          Left = 97
          Top = 94
          Width = 49
          Height = 22
          Caption = 'Reset 0'
          TabOrder = 4
          OnClick = ButtonR0Click
        end
      end
      object CategoryPanel1: TCategoryPanel
        Top = 0
        Height = 26
        Caption = 'Position'
        Collapsed = True
        TabOrder = 1
        OnCollapse = CategoryPanel2Collapse
        OnExpand = CategoryPanel1Expand
        ExpandedHeight = 201
        object Label9: TLabel
          Left = 5
          Top = 4
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'X mid:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label10: TLabel
          Left = 6
          Top = 26
          Width = 29
          Height = 13
          Alignment = taRightJustify
          Caption = 'Y mid:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton32: TSpeedButton
          Tag = 2
          Left = -1
          Top = 45
          Width = 40
          Height = 19
          Hint = 'Click to render the 2d plane at the midpoint.'
          Caption = 'Z mid'
          ParentShowHint = False
          ShowHint = True
          OnClick = Button1Click
        end
        object SpeedButton33: TSpeedButton
          Tag = 1
          Left = -1
          Top = 67
          Width = 40
          Height = 19
          Hint = 'Click to render the 2d startplane.'
          Caption = 'Z start'
          ParentShowHint = False
          ShowHint = True
          OnClick = Button1Click
        end
        object SpeedButton34: TSpeedButton
          Tag = 3
          Left = -1
          Top = 89
          Width = 40
          Height = 18
          Hint = 'Click to render the Z endplane.'
          Caption = 'Z end'
          ParentShowHint = False
          ShowHint = True
          OnClick = Button1Click
        end
        object SpeedButton30: TSpeedButton
          Left = 40
          Top = 109
          Width = 70
          Height = 19
          Hint = 
            'Click on the object in the image to be centered.'#13#10'The camera dir' +
            'ection will not be changed, use the rotation'#13#10'options to rotate ' +
            'around the midpoint.'
          Caption = 'get midpoint'
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton30Click
        end
        object SpeedButton31: TSpeedButton
          Left = 112
          Top = 109
          Width = 35
          Height = 19
          Hint = 
            'Reset the position and the rotation to the start values.'#13#10'On box' +
            ' formulas it will be automatically zoomed out more.'
          Caption = 'reset'
          ParentShowHint = False
          ShowHint = True
          OnClick = Button14Click
        end
        object Label5: TLabel
          Left = 5
          Top = 131
          Width = 30
          Height = 13
          Alignment = taRightJustify
          Caption = 'Zoom:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Edit1: TEdit
          Left = 38
          Top = 67
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '-2.0'
        end
        object Edit3: TEdit
          Left = 38
          Top = 89
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = '30.0'
        end
        object Edit9: TEdit
          Left = 38
          Top = 1
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '0.0'
        end
        object Edit10: TEdit
          Left = 38
          Top = 23
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Text = '0.0'
        end
        object Edit17: TEdit
          Left = 38
          Top = 45
          Width = 109
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          Text = '0.0'
        end
        object Edit5: TEdit
          Left = 38
          Top = 128
          Width = 109
          Height = 21
          Hint = 
            'Defines the size of the Zstart viewplane.'#13#10'It is set automatical' +
            'ly when using the navigator,'#13#10'change only if objects are cutted ' +
            'at the image'#13#10'borders.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 5
          Text = '1.0'
        end
      end
    end
    object Panel6: TPanel
      Left = 1
      Top = 52
      Width = 151
      Height = 95
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
      object SpeedButton3: TSpeedButton
        Left = 2
        Top = 71
        Width = 47
        Height = 21
        Hint = 'Quick quality settings'
        AllowAllUp = True
        GroupIndex = 3
        Down = True
        Caption = 'preview'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton3Click
      end
      object SpeedButton5: TSpeedButton
        Tag = 2
        Left = 84
        Top = 71
        Width = 32
        Height = 21
        AllowAllUp = True
        GroupIndex = 3
        Caption = 'mid'
        Flat = True
        OnClick = SpeedButton3Click
      end
      object SpeedButton6: TSpeedButton
        Tag = 3
        Left = 116
        Top = 71
        Width = 33
        Height = 21
        AllowAllUp = True
        GroupIndex = 3
        Caption = 'high'
        Flat = True
        OnClick = SpeedButton3Click
      end
      object SpeedButton13: TSpeedButton
        Tag = 1
        Left = 49
        Top = 71
        Width = 35
        Height = 21
        AllowAllUp = True
        GroupIndex = 3
        Caption = 'video'
        Flat = True
        OnClick = SpeedButton3Click
      end
      object SpeedButton9: TSpeedButton
        Left = 4
        Top = 3
        Width = 27
        Height = 21
        Hint = 
          'Leftclick:   Undo -> Sets the parameter to the state before the ' +
          'last calculation'#13#10'Rightclick: Redo'
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
      object Button2: TButton
        Left = -1
        Top = 25
        Width = 81
        Height = 43
        Hint = 'Main rendering of the image'
        Caption = 'Calculate 3D'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = Button2Click
        OnMouseDown = Button2MouseDown
      end
      object Button10: TButton
        Left = 86
        Top = 6
        Width = 63
        Height = 20
        Hint = 
          'Press to bring up the formula window'#13#10'Rightclick for sticky opti' +
          'ons.'
        Caption = 'Formulas'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button10Click
        OnMouseDown = Button10MouseDown
      end
      object Button15: TButton
        Tag = 2
        Left = 86
        Top = 48
        Width = 63
        Height = 20
        Hint = 
          'Press to bring up the postprocessing window.'#13#10'Rightclick for sti' +
          'cky options.'
        Caption = 'Postprocess'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = Button15Click
        OnMouseDown = Button10MouseDown
      end
      object Button11: TButton
        Tag = 1
        Left = 43
        Top = 6
        Width = 37
        Height = 19
        Hint = 'Calculate a fast 8x8 blocky image without proper lighting'
        Caption = 'Calc-'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = Button11Click
      end
      object Button18: TButton
        Tag = 1
        Left = 86
        Top = 27
        Width = 63
        Height = 20
        Hint = 
          'Press to bring up the light+color adjust window.'#13#10'Rightclick for' +
          ' sticky options.'
        Caption = 'Lighting'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = Button18Click
        OnMouseDown = Button10MouseDown
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 618
    Height = 572
    Align = alClient
    BevelOuter = bvNone
    DragKind = dkDock
    TabOrder = 1
    object Panel3: TPanel
      Left = 0
      Top = 537
      Width = 618
      Height = 35
      Align = alBottom
      TabOrder = 0
      object SpeedButton1: TSpeedButton
        Left = 6
        Top = 3
        Width = 48
        Height = 29
        Hint = 
          'Push down to 2D zoom in (out) with left (right) click on the ima' +
          'ge,'#13#10'or by marking a zoom-in area.'
        AllowAllUp = True
        GroupIndex = 1
        Down = True
        Flat = True
        Glyph.Data = {
          760B0000424D760B000000000000360000002800000028000000180000000100
          180000000000400B0000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00000000FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000FFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFF080504080504080504C0C0C0C0C0C00805
          04080504C0C0C0C0C0C0080504080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFFFFFFFFFFFFFF000000000000000000000000000000
          000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
          FFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFC0
          C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080504
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
          FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFC0
          C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080504
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF00000000000000
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF080504FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF08
          0504080504C0C0C0C0C0C0080504080504C0C0C0C0C0C0080504080504080504
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 54
        Top = 3
        Width = 41
        Height = 29
        Hint = 'Push down to shift the object in X,Y direction with the mouse.'
        AllowAllUp = True
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          760B0000424D760B000000000000360000002800000028000000180000000100
          180000000000400B0000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          5A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A5A5A0000005A5A5AFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF5A5A5A0000000000000000005A5A5AFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A5A5AFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFF5A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF5A5A5A000000FFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFF0000005A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF5A5A
          5A00000000000000000000000000000000000000000000000000000000000000
          00005A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A5A5A000000FF
          FFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF0000005A5A5AFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5A5A5AFFFFFFFFFFFFFFFFFF
          000000FFFFFFFFFFFFFFFFFF5A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF5A5A5A0000000000000000005A5A5AFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF5A5A5A0000005A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          5A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
      end
      object SpeedButton4: TSpeedButton
        Left = 95
        Top = 3
        Width = 41
        Height = 29
        Hint = 'Push down to move the object in the Z direction with the mouse.'
        AllowAllUp = True
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          760B0000424D760B000000000000360000002800000028000000180000000100
          180000000000400B0000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
          C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040000000C0C0C0
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000000000000000000C0C0C0FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF404040000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFC0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF404040
          5A5A5AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C05A5A5AFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFC0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000C0
          C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800000005A5A5AFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF00000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton1Click
      end
      object Label20: TLabel
        Left = 138
        Top = 11
        Width = 3
        Height = 13
      end
      object SpeedButton11: TSpeedButton
        Tag = 11
        Left = 205
        Top = 0
        Width = 18
        Height = 17
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers X axis @ Ymid+Zm' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects X axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C300000000000000000000000000000084C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C30000003E3E3E3E3E3E3E
          3E3E00000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C30000
          0045454545454545454500000084C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C30000004C4C4C4C4C4C4C4C4C00000084C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C300000052525252525252525200000084C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C300000059595959595959
          595900000084C4C384C4C384C4C384C4C30084C4C384C4C30000000000000000
          0060606060606060606000000000000000000084C4C384C4C30084C4C384C4C3
          00000029292967676767676767676767676767676724242400000084C4C384C4
          C30084C4C384C4C384C4C30000002929296E6E6E6E6E6E6E6E6E292929000000
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C300000033333380808033
          333300000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4
          C300000033333300000084C4C384C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C384C4C384C4C300000084C4C384C4C384C4C384C4C384C4C384C4
          C300}
        Margin = 1
        ParentShowHint = False
        ShowHint = True
        Spacing = 0
        OnMouseUp = SpeedButton18MouseUp
      end
      object SpeedButton16: TSpeedButton
        Tag = 12
        Left = 205
        Top = 17
        Width = 18
        Height = 17
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers X axis @ Ymid+Zm' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects X axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C300000084C4C384C4C384C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C384C4C300000033333300000084C4C384C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C300000033333380808033
          333300000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C30000002929
          296E6E6E6E6E6E6E6E6E29292900000084C4C384C4C384C4C30084C4C384C4C3
          00000029292967676767676767676767676767676729292900000084C4C384C4
          C30084C4C384C4C3000000000000000000606060606060606060000000000000
          00000084C4C384C4C30084C4C384C4C384C4C384C4C300000059595959595959
          595900000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C30000
          0052525252525252525200000084C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C30000004C4C4C4C4C4C4C4C4C00000084C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C300000045454545454545454500000084C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C30000003E3E3E3E3E3E3E
          3E3E00000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C30000
          0000000000000000000000000084C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C300}
        Margin = 1
        ParentShowHint = False
        ShowHint = True
        Spacing = 0
        OnMouseUp = SpeedButton18MouseUp
      end
      object SpeedButton17: TSpeedButton
        Tag = 13
        Left = 188
        Top = 8
        Width = 17
        Height = 19
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers Y axis @ Xmid+Zm' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects Y axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C300000000000084C4C384
          C4C384C4C384C4C384C4C384C4C384C4C30084C4C384C4C384C4C30000002424
          2400000084C4C384C4C384C4C384C4C384C4C384C4C384C4C30084C4C384C4C3
          00000024242467676700000000000000000000000000000000000000000084C4
          C30084C4C30000002424246E6E6E6767676060605959595252524C4C4C454545
          3E3E3E00000084C4C3000000002424246E6E6E6E6E6E67676760606059595952
          52524C4C4C4545453E3E3E00000084C4C30084C4C30000002424246E6E6E6767
          676060605959595252524C4C4C4545453E3E3E00000084C4C30084C4C384C4C3
          00000024242467676700000000000000000000000000000000000000000084C4
          C30084C4C384C4C384C4C300000024242400000084C4C384C4C384C4C384C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C300000000000084C4C384
          C4C384C4C384C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4
          C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C300}
        ParentShowHint = False
        ShowHint = True
        OnMouseUp = SpeedButton18MouseUp
      end
      object SpeedButton18: TSpeedButton
        Tag = 14
        Left = 224
        Top = 8
        Width = 16
        Height = 19
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers Y axis @ Xmid+Zm' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects Y axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          3E020000424D3E0200000000000036000000280000000D0000000D0000000100
          18000000000008020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C30084C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4C384C4C384C4C300
          000000000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4
          C384C4C384C4C300000024242400000084C4C384C4C384C4C30084C4C3000000
          00000000000000000000000000000000000067676724242400000084C4C384C4
          C30084C4C30000003E3E3E4545454C4C4C5252525959596060606767676E6E6E
          24242400000084C4C30084C4C30000003E3E3E4545454C4C4C52525259595960
          60606767676E6E6E6E6E6E2424240000000084C4C30000003E3E3E4545454C4C
          4C5252525959596060606767676E6E6E24242400000084C4C30084C4C3000000
          00000000000000000000000000000000000067676724242400000084C4C384C4
          C30084C4C384C4C384C4C384C4C384C4C384C4C384C4C3000000242424000000
          84C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4C384C4C384C4C300
          000000000084C4C384C4C384C4C384C4C30084C4C384C4C384C4C384C4C384C4
          C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C30084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C300}
        ParentShowHint = False
        ShowHint = True
        OnMouseUp = SpeedButton18MouseUp
      end
      object Label6: TLabel
        Left = 418
        Top = 11
        Width = 3
        Height = 13
      end
      object SpeedButton22: TSpeedButton
        Tag = 15
        Left = 166
        Top = 0
        Width = 20
        Height = 17
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers Z axis @ Xmid+Ym' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects Z axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          9E020000424D9E0200000000000036000000280000000E0000000E0000000100
          18000000000068020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C384C4C3000084C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C384C4C384C4C384C4C384C4C384C4C300000000000000000000000000000000
          0000000000000000000084C4C384C4C384C4C384C4C384C4C384C4C300000000
          007D7D7D7373736E6E6E67676742424200000084C4C384C4C384C4C384C4C384
          C4C384C4C384C4C300000000007D7D7D7373736E6E6E5F5F5F00000084C4C384
          C4C384C4C384C4C300000000000084C4C384C4C300000000007D7D7D7373736E
          6E6E57575700000084C4C384C4C384C4C300000026262614141400000084C4C3
          00000000007D7D7D6B6B6B6E6E6E6767674C4C4C000000000000000000303030
          3E3E3E36363620202000000000000000004F4F4F0000004F4F4F676767606060
          5252524747474848484545453E3E3E3636362C2C2C0000000000000000000000
          84C4C30000004F4F4F6060605959595252524C4C4C4646463E3E3E3030300000
          0084C4C3000000000084C4C384C4C384C4C30000000000003E3E3E4E4E4E4545
          4538383800000000000084C4C384C4C3000084C4C384C4C384C4C384C4C384C4
          C384C4C300000000000000000000000084C4C384C4C384C4C384C4C3000084C4
          C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384
          C4C384C4C384C4C3000084C4C384C4C384C4C384C4C384C4C384C4C384C4C384
          C4C384C4C384C4C384C4C384C4C384C4C384C4C3000084C4C384C4C384C4C384
          C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
          0000}
        ParentShowHint = False
        ShowHint = True
        OnMouseUp = SpeedButton18MouseUp
      end
      object SpeedButton23: TSpeedButton
        Tag = 16
        Left = 166
        Top = 17
        Width = 20
        Height = 17
        Hint = 
          'Leftclick:   Rotate the bulb around the viewers Z axis @ Xmid+Ym' +
          'id values'#13#10'Rightclick: Rotate the bulb around the objects Z axis' +
          ' @ 0'
        AllowAllUp = True
        Flat = True
        Glyph.Data = {
          9E020000424D9E0200000000000036000000280000000E0000000E0000000100
          18000000000068020000110B0000110B0000000000000000000084C4C384C4C3
          84C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C384C4C3000084C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4
          C384C4C384C4C384C4C384C4C384C4C3000084C4C384C4C384C4C384C4C384C4
          C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3000084C4
          C384C4C384C4C384C4C384C4C384C4C300000000000000000000000084C4C384
          C4C384C4C384C4C3000000000084C4C384C4C384C4C30000000000003A3A3A4E
          4E4E45454538383800000000000084C4C384C4C3000000000000000084C4C300
          00002F2F2F4C4C4C5959595252524C4C4C4646463E3E3E30303000000084C4C3
          00000000004F4F4F0000003333335353536060605A5A5A4B4B4B484848454545
          3E3E3E3636362C2C2C00000000000000007373734747475656566767675C5C5C
          0000000000000000003030303E3E3E3636362020200000000000000000737373
          7373736E6E6E57575700000084C4C384C4C384C4C30000002626261414140000
          0084C4C300000000007373737373736E6E6E63636300000084C4C384C4C384C4
          C384C4C300000000000084C4C384C4C300000000007373737373736E6E6E6767
          674E4E4E00000084C4C384C4C384C4C384C4C384C4C384C4C384C4C300000000
          0000000000000000000000000000000000000000000084C4C384C4C384C4C384
          C4C384C4C384C4C3000084C4C384C4C384C4C384C4C384C4C384C4C384C4C384
          C4C384C4C384C4C384C4C384C4C384C4C384C4C3000084C4C384C4C384C4C384
          C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C384C4C3
          0000}
        ParentShowHint = False
        ShowHint = True
        OnMouseUp = SpeedButton18MouseUp
      end
      object ProgressBar1: TProgressBar
        Left = 288
        Top = 8
        Width = 126
        Height = 19
        Smooth = True
        TabOrder = 0
        Visible = False
      end
      object Edit4: TEdit
        Left = 243
        Top = 7
        Width = 30
        Height = 21
        Hint = 'Degree of rotation'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '5'
      end
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 73
      Width = 618
      Height = 464
      HorzScrollBar.Tracking = True
      VertScrollBar.Tracking = True
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      TabOrder = 1
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 480
        Height = 400
        AutoSize = True
        OnMouseDown = Image1MouseDown
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
      end
      object Shape1: TShape
        Left = 72
        Top = 104
        Width = 65
        Height = 65
        Brush.Style = bsClear
        Pen.Color = clWhite
        Pen.Mode = pmXor
        Pen.Style = psDot
        Visible = False
        OnMouseDown = Shape1MouseDown
      end
      object Shape2: TShape
        Left = 176
        Top = 88
        Width = 9
        Height = 9
        Cursor = crCross
        Brush.Style = bsClear
        Pen.Color = clWhite
        Pen.Mode = pmXor
        Shape = stCircle
        Visible = False
        OnMouseDown = Shape2MouseDown
        OnMouseMove = Shape2MouseMove
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 618
      Height = 73
      Align = alTop
      TabOrder = 2
      object SpeedButton12: TSpeedButton
        Left = 2
        Top = 5
        Width = 52
        Height = 30
        Hint = 'Open the animation maker'
        Glyph.Data = {
          160E0000424D160E000000000000360000002800000031000000180000000100
          180000000000E00D0000120B0000120B0000000000000000000068E9F868E9F8
          68E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9
          F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868
          E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F8
          68E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9
          F868E9F868E9F868E9F868E9F8FF000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00FF000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000FF000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF0000000000
          00FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000EF000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF0000000000
          00FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FF0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000FF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000FF000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000FF000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000FF000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA50000
          00F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000000000000000000000F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA50000
          00FF000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5
          000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000FF000000F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA50000
          00000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000FF000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000FF0000
          00F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000000000F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5000000F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA50000
          00F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5000000F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000FF000000F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000000000
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5000000FF000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5
          F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000FF000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9
          DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5000000F9DAA5
          F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DAA5F9DA
          A5F9DAA5F9DAA5F9DAA5000000FF000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00FF000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000FF000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF0000000000
          00FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000FF000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFF
          FFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF0000000000
          00FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF00
          0000000000FFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FF0000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000FF0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000EF68E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9
          F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868
          E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F8
          68E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9
          F868E9F868E9F868E9F868E9F868E9F868E9F868E9F868E9F8FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton12Click
      end
      object SpeedButton15: TSpeedButton
        Left = 2
        Top = 38
        Width = 52
        Height = 31
        Hint = 'Open the Navigator'
        Glyph.Data = {
          7E120000424D7E120000000000003600000028000000330000001E0000000100
          18000000000048120000120B0000120B0000000000000000000000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
          FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
          00FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
          0000FF0000FF0000FF0000FF0000FF0000FF00000000826B626F59505C463D5C
          42355C42355C42355C42355C42355C42355C42355C42345C42345C42345C4234
          5D42345D42345D42345D42345D42355C42355C42355C42355C42355C42355C42
          355C42355C42355C42355C42355C42345D42335E43316745294C3B3B0C2D7D32
          2E465C381E73491F6A492C63432B61442E60432F5F43315E42315A3F315A3D31
          5E43355C42345C42355C42355C4235000000927B727F695F71574C7157497157
          4971574971574971574971574972564973564874564875564777564775564776
          564876574876574876574976574976574A74574A735749725749715749715749
          715749715749715749715748735747775743835C39544852054FAC4070AC3555
          984E4354744C2D895C32815C3A7F5A3E805C407A523987674B8C6F5471544772
          5648715749715749715749000000A28A7E8F786B866B59866B59866B59866B59
          866B59876B59886B58896B578B6A568D6953936850896A558F6C57966C53926C
          55936D58966D58926D58936D588F6C598B6B59896B59886B58886B58886B5888
          6B59886B58886B58896C548D6D4C986E376B606C0061BF0F65BF5086BF5288BF
          436DA96C5A68936A349D723D755A4C828481C1B3879078678A694F886B579B72
          58876C5973584B000000B2917F9F7F6C9B745B9B745B9B745B9B745B9C745B9D
          745A9E735AA17258A87155A270525F7E693780703E7C6F787665A873539F7155
          756B584C70625875679F755CA7755AA2755AA0745A9F745A9F745A9F745A9E74
          5A9E74599F7555A4764CAE76356368920874D30030D30031D12060C85E9DD325
          71D3254AA702157C0026A4008BD34F6C96AB723BA176539E74589C745A886D5B
          745A4C000000B59381A2806E9F765D9F765DA0765DA1765DA2765CA5765CAA75
          5BB37358A36B51628E7844BDA154BDA046A6993388844064603C4F482C5C5D36
          6D6A295D5C435958B57258C0795BB2775BB1765AB4785AB77759B37659A8765A
          AA7756B1794CC278316F6981036CE6003CE6004DE60031E6004FE6437EE50037
          D00020DC0249CF003EA98B5A40C48248AD7952A577589E765C896E5D755B4D00
          0000B69482A48270A2785FA3785FA4785FA5785EA8785EAC785DB9795C7D6B57
          37665D55BFA85BA4A761A4BE599EA74D9384316673375C683953593A5B623958
          562D6F6D3E665E90745EC97958C37D5BA0755D847C66937D64B57A5CB57A57B8
          7C4DC6792D6D6D8B0971FF003EFF0049FF004FFF0354FF002FB60034FF3191FF
          163DB00026BBB58D6EC7843BB47E50AA7B58A0795C8B6F5E775C4E000000B896
          84A68371A77A61A87A60AB7A60AE7960B27A5FBA7A5EB47D5F41655E274D4E46
          8F824585884D8C93509796539F9D56A3A04B898830515D3A66653D8B803E8A7F
          33887827696475695C5F6461347C792E89872C8A7A5F7D69BB7755C27F4DCC7A
          2E696F99036DFF003FFF004FFF0041FB0021BB0053FF3B92FF2950C1000AB000
          13C10C40D7BE7E4CC78749B27E55A37B5C8D715F785D4F000000BB9785A98573
          AD7C62B07C62B67B62C47C61C3785DD28262B47C5C4A857F62C2BA6CCAC370C5
          BC66B0A960A09E598B8B353C422B2C304F8A824C8D815BA79A509B8A3B776738
          736D26676B2F6C7E3D7B7A41858142878129856F977551D38651CC7C2D686F9D
          0066FF0048FF0041FF002BC00055FF3F79EC2C429E00039D0013B90006AA003D
          E43657AABE7C41C48952A87F5A90725F7B5E4F000000BF9986B08673B67D63C2
          7C61AB7C616274615F7C706A706274776D417A7B4865604B6A6E6AA4A8619199
          547B863E54602B3A4C2B3F5036585A63ABA45C9B9E599D9262B8A24A94873B64
          5E43716D4A87853D6D7344778C35827D777153EB964EBD74363B64CD0064FF00
          2DF00032CF0B50F0387BFF1E4AC9001BB90422AD000BA40006AC002AC4338FFF
          464785C98748AF845693745D7E604F000000C29A87BD8773C97A5FB47E624588
          73207F78216D6E225F682B676D2337361C1C2B2B4360384964445B7142536634
          3C493352653756646CC1B36EB9BA63A9A850978C5E989353918E396A6A3B404D
          4D74774D817E3D696A3368648E7F56FA98445C4E5E116DFF0029E50026C10F5E
          FF497DE8337EFF005BFF0040FF0049FF002DD70010BA0014ED3487FF3B8FFA4C
          4A73C0904497765D81624F000000CD9A87A9847256665B417F6D3A9C8347897A
          529E913E7976385B62304452315A6F3B6C8A31506335555C364A4F38585B3E6C
          773D6B76486E776AA1AD7CD7D780EADF6ED2C05292924A807D385766455A6247
          696B4B837C28625E9E8755C06F3F245AE0024CFF0005BE0855FF3165E4277AFF
          0034FF002FFF0043FF0051FF004DFF0041FF0050FF0037FF2C87FA0051E75853
          81A17D5E82634F000000C79B856CA28846A08C4B9F8651A992549C9250909855
          9C9D4E938E23303C365C5E4585714E997D4E9A7F498B7A498A7D4C88815FADA5
          33505D2A36513A526F3A4E6A415A713A505C334D56292F433638433E464E353D
          385C614A68774C4344800463FF0026F40030DE2C68F7005AFF0025FF004DFF27
          85FF2780FF287DFF3F83FF508CFD4183FF448DFF5485E83F6FD36470A59B785B
          846451000000C3A38C7ECDAD67AEAE5DB09A66B8AB63A79D7ACDC15F9FAA4054
          6265A89F5DB09068BB9D71C5B060B29E5DAA99518F813B6363314B513A505C5B
          98A3508F9D4277883D657523283C41686F6DC6BD3E666D36575C1E3142A17D5A
          94635E0028E30D70FF085CFF3781FF004CFF0031F64554B0AB938EC0916AB587
          68B38566C78D57D18F4EC78D59C88A51D19054CC8E53B88B5298786683655300
          0000D1A68C80C6B65EA5B062AA9D76CCC79AFFF56DB7C5425D733A515F4F7C7B
          68BBA17AC9BC6EB6A96ABBA7579F8D55928B61AFA14F888834566D4F82957AD2
          DF62AAB746707A2E48552126304878764E87844B95844585703E706F10299B33
          71FF274CC54983FF075DFF4B56ADCA9068E89948E08F3FD5904FD5914FD59250
          CE8E57C68D5AC88D59C48C61C38B5EC08B62AE8A67987969846656000000D99F
          888DA9935DB8B16CB6AE589B984C667B38435A446F7B406A7844717789EFDF75
          BAAE5FA28D426E6C6DCAB2467D783C546465A7AB5CA1B0385A6968A9B97ACBDA
          497A8C2A4866568C9577CAC34175706DBAA75CAA892A6BA40020DC021DA90000
          562C599A2C6054A88641F59C54D8955DCD9161C68F64C48E64C28D64C18D66C1
          8D67C08D68BF8C69BE8C6ABC8C6BAD8C6D987B6A846758000000DF9B84AB9E8C
          5FB0AB55686B345F6839556160B0B86ECED85593A455949D5FA6AE64A7A26EC9
          BC4C89885FA39F7CE0DD55999D80D5E576CBD737525B547F98629AB170BECE64
          B7C154919784CED47BD6D165ACA75FB9B12E85DB1B62C01A4E7A416D62579572
          49AB74497654D89265D6966DC9926EC28F6DC08E6EBF8D6DC1906FC19070BF8E
          70BF8E70BE8E70BF8F72B090739A7C6C866959000000E09D85B79A866A918776
          CFBF1A55591B263464BBCDADFFFF86E1F17BE5F66FD3DD85DEE68AECEF83EDEB
          68C6C965AABA6AA8C26EB7D04F7B922D3C51415C6F5E91AB7CCADA7FE6F93765
          783863745595A265B2A1509B8755B08A469D715FA47C5BA3961E4D4E1D7C6450
          8960D7906BC98B6ACA9576C38F70C29172BD8A6DBA8668C99576C69275C39274
          C18F71B98668B290709E7F6E896B5A000000E09E89878C792F605C425655331C
          160B00000000001D4859599FC185D7F35671741007070E04080F0A0E00000000
          00000D2138426D873A698338698A355F84346083355973689BAF3E3E3F0F211A
          75E6D841827C5C857F191209001B0B2E646E527C834645333028220000005837
          2A0D0806492B1DDDA381BC8466CEA082171716030000CE997AC99375DDA9894F
          47400000009C7C6C906F5D000000669082559693FFFFF8FFFFFFFFFFFFFFFFFF
          CEBAA5000000000C29BBBAB6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE0CFB30200
          0000010956A8BB4D96AB4E9EB0448BA61F5E7FC1BAAFFFFFFF0F06087AE3EE58
          CBC1FFFFFFFFE0C6000000B6C2B5FFFFFFFFFFFFFFFFFFF2F6DBFFFFFFADC3BD
          190100E5A986C98866FFFFFFFFFFFF0000007D5440DDA07EFAD2A0FDF8FA0612
          1892726193726000000071BEACFFFFFFFFFFFF4B5F641D3B57AEC7C1FFFFFFBA
          A490000000BCC9C2FFFFFF676661608698708DA7C0C4C0FFFFFFFFFFFF0B0000
          0C2D3251A2A43552563A70771A5A6ECDD2C5FFFFFF0B060931627A2D7183FFFF
          FFFFFADF000000FFFFFFE2D7C41F312CEBC49EFFFFE7FFFFFFB5C2B82B1209D7
          936FE6B79AFFFFFFFFFFFF6A7976020000EEAE8AFDD18FFDF8FA121C20947261
          96736000000095C3B8FFFFFAA4CEBE1F616C44939A002F45FFFFF8FFFFE10000
          08C7F0E5FFFFFF0F18191F73890E476D0021494F626EFFFFFFDDC5AF00000051
          A79C375F572D6C640D4853C7CBBDFFFFFF0100000F2D49041D37FFFFFFFFF3D7
          000008FFFFFFE9E4CF000000190000220000FFFFFFB4C4BA270B02D68F6BFFFB
          DFFAFFFCCDCAB9FFFFFF000000BF8567FDCA9CFDF8FA171E2194715F97746000
          000087D3BF437A703F67686EE9E235949D000416FFFFFFFFFEE4000816C0E2D0
          FFFFFF181818276175306B89153B5C0D2F41FFFFF6FFFFFF0000004395854792
          843983750B4044BDB9B2FFFFFF0000000E4061002846FFFFFFFFF3D50000007F
          9BA2FFFFFFFFFFFFAFADA094A096FFFFFFB2C0B6240500E9A885FFFFFF9AA39A
          7E533EFFFFFF001118492213FDDDB4FDF8FA212728916F5C99756200000096DC
          C763A99948888B9CF6ED7A7D71BFB09FFFFFFF8FA89B00605FB3CCB8FFFFFF0F
          04041440552454761B4765001E36C8C5B5FFFFFF05050653B09D57B2A041907E
          0D4444AEA195FFFFFF00000000263C23718EFFFFFFFFF5D80000063F81920000
          002E2F30CAE1D4FFF9D2FFFFFFACC1B91D0000FFEACAFFFFFF696259AB6948FF
          FFFFA6BDB7000000FDDDB3FDF8FA1E252793715E9976630000007CC0B3537581
          7CF3F7C4FFFFFFFFFFFFFFFFC3AD9D000000137A6DAAC8B3FFFFFF0D08092971
          75347F872A6B7319686ADCE7D1FFFFFF18231E69C8B756A29A50A691165B53B8
          B6A4FFFFFFBAAC9B000000041518FFFFFFF1DEC6001C2FFFFFFFFFFFEE000000
          0000001A1C19FFFFFFC1CDC07B422CFFFFFFC6E4DC5E3F31DE9C79FFDDA7FFFF
          FF000000A47E65FDF8FA0000099A78679A7764000000CEBCA8797D761921293A
          7F9057A4C3C1C5C0FFFFFF2C100E00443BCAF5DAFFFFFF14141233797352B0A8
          32968F2F8982FFFFF8FFFAE024436070C5C94EA97B54A3952F8C7AC2BFA9FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF6F8F8C000D1F91898BFFFFFFFFFFFFFFFFF0FF
          FFFFFFFFFFDDAD8FE3A98BFFFFFFCBBFACA57056DDA784E1A572FFFFFF9F9A8D
          B68868FDF8FAA08B78A68271997664000000F4B094FFF7D58C86790201010A43
          5A345667FFFFFF837066045854D3FBE2FFFFFF0203020B705913706802303971
          9B97FFFFFFC5C1B045ADA678E1CD58B49354AAA151A1B764B79B536C6229575E
          72969897C1BE4B73781A5C61234D5646828971C3BE89BFB393CCBE569086918B
          6EE09374D69F81DEA886DDA584D39E80CC9B7CCF9B7EDDA887EEB491EDAF8B84
          59437F5A48AD8A79997865000000E7AD93FFFFE5FFFFFF776B60151414D2CDBB
          FFFFFF80A69D45B0A1E0FBDAFFFFFF967B716B4D4A7B5E5AC69A90FFFFFFFFFF
          FF5DB693438E6F68C3AB6ABFAE74CBB960ACA4488AA634626939646324454828
          535B396F71417C77345D575D9DA05394942F5F65278A78288065C19B7BE29F82
          D59C7ECF9C7FD19C80D2A183D2A083D2A083D19F81D19B7DF6C5A0A0B1A91514
          14A07F6E9D7B69000000EEB49BB4A291E0FCEBFFFFFFFFFFFFFFFFF799A79F76
          DDC483E5F2D8FDF1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC6FADE62A78D426C65
          648B93658B967AACA786BDB884C0AB6E99A06196895E8B7F619992629A8C6498
          925F988F4C7267678F926FBAB46F9B8F87A08CC4A68BEAA58DDBA48DD6A48ED4
          A48ED4A48FD4A58FD4A58FD4A48ED4A48ED19F89F2CAADFDF8FABEA69AA78C80
          9D8276000000F1BBA283A89C53858872868E80B2AF586B7651887C99EDE69DE3
          E685BDB574B6B0618F8B546D7B91DCDF93E2DE78CDB76590896074827EA8B89C
          D4E093CFD399D6CD9FD6CB95C8BE83B9A679A49577A0A688BEC885B1B87FB6A8
          749F8B8FA9A1B9B7A5F0BDA5FFBCA5F0B9A3E7B8A2E2B7A2DFB7A2DEB7A2DEB7
          A2DEB7A2DEB7A2DEB7A3DEB7A3DFB7A2E1B9A4DEB7A1CFB39FBFA498AF948800
          0000}
        ParentShowHint = False
        ShowHint = True
        Spacing = 0
        OnClick = SpeedButton15Click
      end
      object ScriptEditorBtn: TSpeedButton
        Left = 55
        Top = 5
        Width = 52
        Height = 30
        Hint = 'Open the animation maker'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object MutaGenBtn: TSpeedButton
        Left = 55
        Top = 38
        Width = 52
        Height = 31
        Hint = 'Open the MutaGen'
        Caption = 'MutaGen'
        ParentShowHint = False
        ShowHint = True
        Spacing = 0
        OnClick = MutaGenBtnClick
      end
      object GroupBox1: TGroupBox
        Left = 411
        Top = 1
        Width = 209
        Height = 69
        Caption = 'Image'
        TabOrder = 0
        object Label11: TLabel
          Left = 8
          Top = 14
          Width = 31
          Height = 13
          Caption = 'Width:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object SpeedButton19: TSpeedButton
          Tag = 1
          Left = 165
          Top = 23
          Width = 34
          Height = 14
          Hint = 'Click to set the image height to fit this aspect ratio.'
          AllowAllUp = True
          Caption = '4:3'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton19Click
        end
        object SpeedButton20: TSpeedButton
          Tag = 2
          Left = 165
          Top = 37
          Width = 34
          Height = 14
          Hint = 'Click to set the image height to fit this aspect ratio.'
          AllowAllUp = True
          Caption = '5:3'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton19Click
        end
        object SpeedButton21: TSpeedButton
          Tag = 3
          Left = 165
          Top = 51
          Width = 34
          Height = 14
          Hint = 'User defined apect ratio.'#13#10'Rightclick to define the ratio.'
          AllowAllUp = True
          Caption = 'user'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton19Click
          OnMouseDown = SpeedButton21MouseDown
        end
        object Label4: TLabel
          Left = 164
          Top = 8
          Width = 36
          Height = 13
          Caption = 'Aspect:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label25: TLabel
          Left = 62
          Top = 14
          Width = 34
          Height = 13
          Caption = 'Height:'
        end
        object Label12: TLabel
          Left = 115
          Top = 14
          Width = 30
          Height = 13
          Caption = 'Scale:'
        end
        object Edit11: TEdit
          Tag = 1
          Left = 7
          Top = 29
          Width = 49
          Height = 21
          TabOrder = 0
          Text = '480'
          OnChange = Edit11Change
        end
        object Edit12: TEdit
          Tag = 2
          Left = 61
          Top = 29
          Width = 49
          Height = 21
          TabOrder = 1
          Text = '360'
          OnChange = Edit11Change
        end
        object CheckBox10: TCheckBox
          Left = 7
          Top = 51
          Width = 82
          Height = 15
          Hint = 
            'Keep the aspect ratio when manually changing the width or height' +
            '.'#13#10'No need to uncheck if pressing an aspect button.'
          Caption = 'keep aspect'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 2
          OnClick = CheckBox10Click
        end
        object CheckBox11: TCheckBox
          Left = 93
          Top = 51
          Width = 68
          Height = 15
          Hint = 
            'Scale ClipRadius (DoF) and the DE stop value'#13#10'to keep the detail' +
            ' level and colors.'
          Caption = 'DEstop+C'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 3
        end
        object UpDown2: TUpDown
          Left = 116
          Top = 29
          Width = 30
          Height = 21
          Hint = 'Scale the image size by 2, up or down.'
          Min = -30000
          Max = 30000
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = UpDown2Click
        end
      end
      object PageControl2: TPageControl
        Left = 109
        Top = 4
        Width = 248
        Height = 64
        ActivePage = TabSheet13
        TabOrder = 1
        object TabSheet7: TTabSheet
          Caption = 'Open'
          object Button9: TSpeedButton
            Left = 9
            Top = 3
            Width = 40
            Height = 31
            Hint = 'Open full M3I'
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
            Visible = False
            OnClick = Button9Click
          end
          object Button5: TSpeedButton
            Left = 100
            Top = 4
            Width = 30
            Height = 30
            Hint = 'Open parameter'
            Glyph.Data = {
              B6050000424DB605000000000000360400002800000010000000180000000100
              08000000000080010000C30E0000C30E00000001000000010000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A60000000000848400002202920006A7DC0019E7F90080FFFF00C6C6C600FFFF
              FF00000014002202920006000000A80714000000140040261A0064EB12000000
              0000A8ED1200B4EB12000000140022029200040000004807140000001400E8EC
              1A00D0EB12000000140022029200040000004807140000001400E8EC1A00A8EB
              1200DB019200ECED120020E9910028029200FFFFFF00220292009B019200DB01
              92003CEE120068EE1200000000000000000060EE120000000000E8EB1200AC76
              DA0040EF120020E9910068F69100FFFFFF0061F691005877DA0000000000C402
              0000000000006377DA0014001400E8EC1A0018000000C402000060EE12004000
              00000000000000000000A8EE120068EE12000000000000000000000000000000
              000000000000000000000000000040000000ACEE120020E99100000000000200
              000001000000C402000060EE1200C40200006014920038261A0018261A000000
              00000000000090EC01008F00000004EC120020E99100C0EC12007C94370011A9
              000011A90000D4EC12001E9437007828AF0011A9000000000000ECEC1200E294
              37007828AF003D150F00F057E200B057E2000CED1200824C0F00F057E2004803
              2E00B64C0F00F057E20014ED120000000000B800920038261A00E0ED12004100
              9200A80714005D00920038EE1200000000003CED120000000000B8009200E0EC
              1A0008EE1200410092004807140058ED120000000000B8009200E0EC1A0024EE
              120041009200480714005D00920068EE12000400000000000000020000000000
              000004000000300000000000000040261A00D98B360000F0FD00300000000400
              00000000140098EB12005CF691002000000000000000E8EC1A00C4ED12000000
              0000B800920068830A0090EE120041009200380BE2005D00920088460A007083
              0A000300000061F69100EECF9100CEDD910000001400E4ED1200DADD91008CEE
              120020E9910068F69100FFFF01000400000068ED1200000000008CEE120020E9
              910060009200FFFFFF005D009200AC04920000001400C8000000E8EC1A0048EE
              120082049200E8EC1A00000000009CEE12000EECDA0020ECDA00C8A662000000
              E200D4A66200000000000000000000000000000000000000010019000000D4ED
              120070830A00C8EE120020E9910060009200FFFFFF005D009200DEC2BF000000
              E20000000000E3C2BF0088460A0070830A0003000000AA68D30070830A007083
              0A00D4EE1200A4EE1200FFFFFF0040EF1200945CC0007020BE00FFFFFF00E3C2
              BF00D595440070830A00A01B6300A01B6300F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00101000111111
              1111111111111100101010100011001100001100110011001010101000111111
              1111111111111100101010100011110011000011110011001010101000111111
              1111111111111100101010100011000011001100001111001010101000111111
              1111111111111100101010100000000000000000000000001010101010101010
              1010101010101010101010101010101010101010101010101010100000000000
              0000000000000010101000000E0E0E0E0E0E0E0E0E0E0E001010000F000E0E0E
              0E0E0E0E0E0E0E001010000F000E0E0E0E0E0E0E0E0E0E0E0010000F0F000E0E
              0E0E0E0E0E0E0E0E0010000F0F000E0E0E0E0E0E0E0E0E0E0E00000F0F0F0000
              0000000E0E0E0E0E0E00000F0F0F0F0F0F0F0F00000000000010000F0F0F0F0F
              0F0F0F0F0F0F00101010000F0F0F0F0F0F0F0F0F0F0F00101010000F0F0F0F0F
              0000000000001010101010000000000010101010101010101010101010101010
              1010101010101010101010101010101010101010101010101010}
            ParentShowHint = False
            ShowHint = True
            OnClick = Button5Click
          end
          object SpeedButton8: TSpeedButton
            Left = 144
            Top = 4
            Width = 30
            Height = 30
            Hint = 
              'Open parameter from Clipboard text:'#13#10'Select parameter text inclu' +
              'ding '#39'Mandel...{..}'#39','#13#10'press ctrl+c and afterwards the open-txt ' +
              'button.'
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
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00434343434343
              4343434343434343434343430000434343434343434343434343434343434343
              0000434343430043430043004343004343434343000043434343004343004300
              4343004343434343000043434343004343430043434300434343434300004343
              4343004343004300434300434343434300004343430000004300430043000000
              4343434300004343434343434343434343434343434343430000434343434343
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
            Visible = False
            OnClick = SpeedButton8Click
          end
        end
        object TabSheet10: TTabSheet
          Caption = 'Save'
          ImageIndex = 1
          object Button8: TSpeedButton
            Left = 9
            Top = 3
            Width = 40
            Height = 31
            Hint = 'Save complete M3I'
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
            Visible = False
            OnClick = Button8Click
          end
          object Button4: TSpeedButton
            Left = 100
            Top = 4
            Width = 30
            Height = 30
            Hint = 'Save parameters only'
            Glyph.Data = {
              36010000424D3601000000000000760000002800000010000000180000000100
              040000000000C0000000C30E0000C30E0000100000001000000000000000FF00
              00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00440555555555
              5044440505005050504444055555555550444405505005505044440555555555
              5044440500505005504444055555555550444400000000000044444444444444
              4444430000000000003440110311544011044011031154401104401104334440
              1104401120000002110440111111111111044012000000002104401055555555
              0104401055555555010440105555555501044010555555550104400055555555
              0004401055555555010443000000000000344444444444444444}
            ParentShowHint = False
            ShowHint = True
            OnClick = Button4Click
          end
          object SpeedButton7: TSpeedButton
            Left = 138
            Top = 4
            Width = 30
            Height = 30
            Hint = 
              'Save parameters to Clipboard as text,'#13#10'afterwards you can press ' +
              'ctrl+v to insert the text somewhere else.'
            Glyph.Data = {
              96010000424D9601000000000000760000002800000012000000180000000100
              04000000000020010000C30E0000C30E0000100000001000000000000000FF00
              00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
              4444440000004444444444444444440000004444044040440444440000004444
              0440404404444400000044440444044404444400000044440440404404444400
              0000444000404040004444000000444444444444444444000000444444444444
              4444440000004430000000000003440000004401103115440110440000004401
              1031154401104400000044011043344401104400000044011200000021104400
              0000440111111111111044000000440120000000021044000000440105555555
              5010440000004401055555555010440000004401055555555010440000004401
              0555555550104400000044000555555550004400000044010555555550104400
              0000443000000000000344000000444444444444444444000000}
            ParentShowHint = False
            ShowHint = True
            Visible = False
            OnClick = SpeedButton7Click
          end
          object SpeedButton29: TSpeedButton
            Left = 181
            Top = 4
            Width = 44
            Height = 30
            Hint = 'Save image + parameters'
            Glyph.Data = {
              56020000424D5602000000000000760000002800000024000000180000000100
              040000000000E0010000C30E0000C30E0000100000001000000000000000FF00
              00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
              4444444444405555555555040000444444444444444444444440505005050504
              0000400440444400044000444440555555555504000040404044440444044044
              0440550500550504000044404000440044040040004055555555550400004440
              4044040444044444044050050500550400004440400044000440004444405555
              5555550400004444444444444444444444400000000000040000444444444444
              4444444444444444444444440000444444444443000000000000344444444444
              0000444444444440110311544011044444444444000044444444444011031154
              4011044444444444000044444444444011043344401104444444444400004444
              4444444011200000021104444444444400004444444444401111111111110444
              4444444400004444444444401200000000210444444444440000444444444440
              1055555555010444444444440000444444444440105555555501044444444444
              0000444444444440105555555501044444444444000044444444444010555555
              5501044444444444000044444444444000555555550004444444444400004444
              4444444010555555550104444444444400004444444444430000000000003444
              4444444400004444444444444444444444444444444444440000}
            ParentShowHint = False
            ShowHint = True
            Visible = False
            OnClick = SpeedButton29Click
          end
          object CheckBox16: TCheckBox
            Left = 53
            Top = 10
            Width = 40
            Height = 17
            Hint = 
              'Save m3i files including the internal image buffer, saving refle' +
              'ctions etc.'
            Caption = 'Img'
            Checked = True
            ParentShowHint = False
            ShowHint = True
            State = cbChecked
            TabOrder = 0
          end
        end
        object TabSheet12: TTabSheet
          Caption = 'Save pic'
          ImageIndex = 2
          object Button3: TSpeedButton
            Left = 3
            Top = 4
            Width = 33
            Height = 30
            Hint = 'Save the image as BMP or PNG file, scaled like the current view.'
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
            OnClick = Button3Click
          end
          object SBsaveJPEG: TSpeedButton
            Left = 40
            Top = 4
            Width = 30
            Height = 30
            Hint = 'Save the image as JPEG file, scaled like the current view.'
            Glyph.Data = {
              96010000424D9601000000000000760000002800000012000000180000000100
              04000000000020010000C30E0000C30E0000100000001000000000000000FF00
              00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
              4444440000004444444444444444440000000044044440004400040000000404
              0444404440440400000044040004400440400400000044040440404440444400
              0000440400044000440004000000444444444444444444000000444444444444
              4444440000004430000000000003440000004401103115440110440000004401
              1031154401104400000044011043344401104400000044011200000021104400
              0000440111111111111044000000440120000000021044000000440105555555
              5010440000004401055555555010440000004401055555555010440000004401
              0555555550104400000044000555555550004400000044010555555550104400
              0000443000000000000344000000444444444444444444000000}
            ParentShowHint = False
            ShowHint = True
            OnClick = SBsaveJPEGClick
          end
          object SpeedButton26: TSpeedButton
            Left = 74
            Top = 4
            Width = 30
            Height = 30
            Hint = 
              'Save a Z buffer image as BMP or PNG file, scaled like the curren' +
              't view.'
            Glyph.Data = {
              36010000424D3601000000000000760000002800000010000000180000000100
              040000000000C0000000C30E0000C30E0000100000001000000000000000FF00
              00008484000084848400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
              FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00444444444444
              4444444444444444444400044004400040440444404040404044404440044040
              4004440440404040404400044004404040004444444444444444444444444444
              4444430000000000003440110311544011044011031154401104401104334440
              1104401120000002110440111111111111044012000000002104401055555555
              0104401055555555010440105555555501044010555555550104400055555555
              0004401055555555010443000000000000344444444444444444}
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton26Click
          end
          object Label24: TLabel
            Left = 152
            Top = 0
            Width = 29
            Height = 13
            Caption = 'sharp:'
          end
          object Label23: TLabel
            Left = 149
            Top = 17
            Width = 6
            Height = 13
            Alignment = taRightJustify
            Caption = '0'
          end
          object Label41: TLabel
            Left = 112
            Top = 0
            Width = 29
            Height = 13
            Caption = 'jpg q.:'
          end
          object Label42: TLabel
            Left = 192
            Top = 0
            Width = 39
            Height = 13
            Caption = 'png par:'
          end
          object Edit26: TEdit
            Left = 111
            Top = 14
            Width = 29
            Height = 21
            Hint = '1..100: JPEG quality'#13#10'> 100: maximal filesize in kilobytes'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Text = '95'
          end
          object CheckBox13: TCheckBox
            Left = 203
            Top = 16
            Width = 17
            Height = 17
            Hint = 
              'Save text parameters in the PNG file, if selected.'#13#10'You can see ' +
              'these for example in gimp under'#13#10#39'Image Properties'#39' -> Comment.'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
          end
          object UpDown4: TUpDown
            Left = 161
            Top = 14
            Width = 19
            Height = 21
            Min = -30000
            Max = 30000
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = UpDown4Click
          end
        end
        object TabSheet11: TTabSheet
          Caption = 'Utilities'
          ImageIndex = 3
          object SpeedButton25: TSpeedButton
            Left = 2
            Top = 4
            Width = 54
            Height = 30
            Hint = 'Convert many M3P files to M3I'
            Glyph.Data = {
              96070000424D9607000000000000360400002800000024000000180000000100
              08000000000060030000C30E0000C30E00000001000000010000000000000000
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
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343430043434300434300004343004343434343434343434300434343
              0043430000434300000000434343004300434300430043434343434300434343
              0043434300430043430043430043004343430043434343004300000043434343
              0000434300434343004343434300434300430043004300434343004343004343
              0043000000000043004300430043434300434343004300004300004300434300
              4300434300434343000043430000430000430043430043430043004343430043
              4300004343000000434343430043434300434343004343000043430000004343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434300000000434300434343
              0043434300434343430000004343004343430043434343434343004343430043
              0043434300434343004343430043434300430043434300434343434343430043
              4343004300000000004343430043434300434343434300434343004343434343
              4343000000004343004343430043434300434343004343434343000000000043
              4343434343430043434300430043434300434343004343430043434343430043
              4343004343434343434300434343004300434343004343430043434300434343
              0043004343430043434343434343000000004343430000004343000000000043
              4300000043430043434300434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343434343434343
              4343434343434343434343434343434343434343434343434343}
            ParentShowHint = False
            ShowHint = True
            Spacing = 0
            OnClick = SpeedButton25Click
          end
          object SpeedButton24: TSpeedButton
            Left = 128
            Top = 4
            Width = 62
            Height = 30
            Hint = 'Export a cube as a stack of PNG files'
            Caption = 'Voxelstack'
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton24Click
          end
          object SpeedButton27: TSpeedButton
            Left = 61
            Top = 4
            Width = 62
            Height = 30
            Hint = 'Generate big images by tiling'
            Caption = 'Big render'
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton27Click
          end
          object SpeedButton28: TSpeedButton
            Left = 195
            Top = 4
            Width = 37
            Height = 30
            Hint = 'Monte Carlo rendering'
            Caption = 'M.C.'
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton28Click
          end
        end
        object TabSheet13: TTabSheet
          Caption = 'Ini'
          ImageIndex = 4
          object SpeedButton14: TSpeedButton
            Left = 67
            Top = 4
            Width = 94
            Height = 30
            Hint = 'Define default directories for loading+saving'
            Caption = 'Initial directories'
            ParentShowHint = False
            ShowHint = True
            OnClick = SpeedButton14Click
          end
        end
      end
      object GroupBox2: TGroupBox
        Left = 357
        Top = 1
        Width = 53
        Height = 69
        Caption = 'Viewing'
        TabOrder = 2
        object SpeedButton35: TSpeedButton
          Tag = 1
          Left = 9
          Top = 17
          Width = 35
          Height = 19
          Hint = 
            'Image downscaling for viewing purpose and for saving as jpeg, pn' +
            'g or bmp.'#13#10'Only at scales 1:2 and 1:3 an anti aliasing filter is' +
            ' performed on saving.'#13#10'Click for a selection menu.'
          AllowAllUp = True
          Caption = '1:1'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = SpeedButton35Click
        end
        object UpDown1: TUpDown
          Left = 9
          Top = 36
          Width = 35
          Height = 28
          Min = 1
          Max = 10
          Position = 10
          TabOrder = 0
          OnClick = UpDown1Click
        end
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    OnTimer = Timer1Timer
    Left = 304
    Top = 104
  end
  object Timer3: TTimer
    Enabled = False
    Interval = 150
    OnTimer = Timer3Timer
    Left = 304
    Top = 72
  end
  object Timer4: TTimer
    Enabled = False
    Interval = 300
    OnTimer = Timer4Timer
    Left = 336
    Top = 72
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = 'm3p'
    Filter = 'Mandel3D Parameter  (*.m3p)|*.m3p'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 168
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'm3p'
    Filter = 'M3D parameter (*.m3p)|*.m3p'
    Left = 104
    Top = 72
  end
  object SaveDialog3: TSaveDialog
    DefaultExt = 'm3i'
    Filter = 'M3D Image + Parameter (*.m3i)|*.m3i'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 200
    Top = 72
  end
  object Timer8: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer8Timer
    Left = 408
    Top = 72
  end
  object SaveDialog4: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG Image|*.jpg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 232
    Top = 72
  end
  object SaveDialog6: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Windows Bitmap|*.bmp|Portable Network Graphic|*.png'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog6TypeChange
    Left = 264
    Top = 72
  end
  object PopupMenu1: TPopupMenu
    Left = 496
    Top = 72
    object N111: TMenuItem
      Tag = 1
      Caption = '1:1'
      OnClick = N111Click
    end
    object N12aa1: TMenuItem
      Tag = 2
      Caption = '1:2  aa'
      OnClick = N111Click
    end
    object N13aa1: TMenuItem
      Tag = 3
      Caption = '1:3  aa'
      OnClick = N111Click
    end
    object N141: TMenuItem
      Tag = 4
      Caption = '1:4'
      OnClick = N111Click
    end
    object N151: TMenuItem
      Tag = 5
      Caption = '1:5'
      OnClick = N111Click
    end
    object N161: TMenuItem
      Tag = 6
      Caption = '1:6'
      OnClick = N111Click
    end
    object N171: TMenuItem
      Tag = 7
      Caption = '1:7'
      OnClick = N111Click
    end
    object N181: TMenuItem
      Tag = 8
      Caption = '1:8'
      OnClick = N111Click
    end
    object N191: TMenuItem
      Tag = 9
      Caption = '1:9'
      OnClick = N111Click
    end
    object N1101: TMenuItem
      Tag = 10
      Caption = '1:10'
      OnClick = N111Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'jpg'
    Filter = 'JPEG|*.jpg|Portable Network Graphic|*.png'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    OnTypeChange = SaveDialog1TypeChange
    Left = 264
    Top = 104
  end
  object PopupMenu2: TPopupMenu
    Left = 576
    Top = 160
    object Stickthiswindowtotherightside1: TMenuItem
      Tag = 1
      Caption = 'Stick this window to the right side'
      Checked = True
      OnClick = Stickthiswindowtotherightside1Click
    end
    object Stickthiswindowtotheleftside1: TMenuItem
      Tag = 2
      Caption = 'Stick this window to the left side'
      OnClick = Stickthiswindowtotherightside1Click
    end
    object Donotmakethiswindowsticky1: TMenuItem
      Caption = 'Do not make this window sticky'
      OnClick = Stickthiswindowtotherightside1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 576
    Top = 200
    object StartrenderingandsaveafterwardstheM3Ifile1: TMenuItem
      Caption = 'Start rendering and save afterwards the M3I file automatically!'
      OnClick = StartrenderingandsaveafterwardstheM3Ifile1Click
    end
  end
  object Timer2: TTimer
    Interval = 60000
    OnTimer = Timer2Timer
    Left = 304
    Top = 136
  end
  object Timer5: TTimer
    Interval = 50
    OnTimer = Timer5Timer
    Left = 360
    Top = 136
  end
  object PopupMenu4: TPopupMenu
    Left = 192
    Top = 168
    object ShapeDisc1: TMenuItem
      Caption = 'Disc'
      OnClick = ShapeDisc1Click
    end
    object ShapeBox1: TMenuItem
      Caption = 'Rect'
      OnClick = ShapeBox1Click
    end
  end
  object Timer6: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer6Timer
    Left = 264
    Top = 160
  end
end
