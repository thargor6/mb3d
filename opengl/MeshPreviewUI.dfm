object MeshPreviewFrm: TMeshPreviewFrm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'MeshPreviewFrm'
  ClientHeight = 464
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 525
    Top = 0
    Width = 158
    Height = 464
    Align = alRight
    TabOrder = 0
    object Label15: TLabel
      Left = 7
      Top = 425
      Width = 143
      Height = 13
      Caption = 'LMB: move           RMB: rotate'
    end
    object Label16: TLabel
      Left = 7
      Top = 441
      Width = 88
      Height = 13
      Caption = 'MMB/Wheel: zoom'
    end
    object DisplayStyleGrp: TRadioGroup
      Left = 1
      Top = 1
      Width = 156
      Height = 137
      Align = alTop
      Caption = 'Display Style'
      ItemIndex = 5
      Items.Strings = (
        'Points'
        'Wireframe'
        'Flat Solid'
        'Flat Solid with Edges'
        'Smooth Solid'
        'Smooth Solid with Edges')
      TabOrder = 0
      OnClick = DisplayStyleGrpClick
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 138
      Width = 156
      Height = 281
      Align = alTop
      Caption = 'Appearance'
      TabOrder = 1
      object AppearancePageCtrl: TPageControl
        Left = 2
        Top = 15
        Width = 152
        Height = 264
        ActivePage = MaterialSheet
        Align = alClient
        TabOrder = 0
        object MaterialSheet: TTabSheet
          Caption = 'Material'
          object Label17: TLabel
            Left = 4
            Top = 8
            Width = 63
            Height = 13
            Alignment = taCenter
            Caption = 'Surface color'
          end
          object Label1: TLabel
            Left = 4
            Top = 32
            Width = 55
            Height = 13
            Caption = 'Edges color'
          end
          object Label2: TLabel
            Left = 4
            Top = 60
            Width = 76
            Height = 13
            Caption = 'Wireframe color'
          end
          object Label3: TLabel
            Left = 4
            Top = 80
            Width = 55
            Height = 13
            Caption = 'Points color'
          end
          object Label4: TLabel
            Left = 4
            Top = 136
            Width = 39
            Height = 13
            Caption = 'Ambient'
          end
          object MatDiffuseColorLbl: TLabel
            Left = 4
            Top = 160
            Width = 34
            Height = 13
            Caption = 'Diffuse'
          end
          object Label6: TLabel
            Left = 4
            Top = 184
            Width = 41
            Height = 13
            Caption = 'Specular'
          end
          object Label7: TLabel
            Left = 4
            Top = 211
            Width = 44
            Height = 13
            Caption = 'Shininess'
          end
          object SurfaceColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 4
            Width = 48
            Height = 22
            TabOrder = 0
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object EdgesColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 28
            Width = 48
            Height = 22
            TabOrder = 1
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object WireframeColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 56
            Width = 48
            Height = 22
            TabOrder = 2
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object PointsColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 76
            Width = 48
            Height = 22
            TabOrder = 3
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object MatAmbientColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 132
            Width = 48
            Height = 22
            TabOrder = 4
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object MatDiffuseColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 156
            Width = 48
            Height = 22
            TabOrder = 5
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object MatSpecularColorBtn: TJvOfficeColorButton
            Left = 88
            Top = 180
            Width = 48
            Height = 22
            TabOrder = 6
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object MatShininessEdit: TEdit
            Left = 70
            Top = 208
            Width = 54
            Height = 21
            TabOrder = 7
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object MatShininessBtn: TUpDown
            Left = 124
            Top = 208
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 8
            OnClick = MatShininessBtnClick
          end
          object LightingEnabledCBx: TCheckBox
            Left = 4
            Top = 105
            Width = 101
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Enable Lighting'
            Checked = True
            State = cbChecked
            TabOrder = 9
            OnClick = LightingEnabledCBxClick
          end
        end
        object LightSheet: TTabSheet
          Caption = 'Light'
          ImageIndex = 1
          object Label8: TLabel
            Left = 3
            Top = 8
            Width = 39
            Height = 13
            Caption = 'Ambient'
          end
          object Label9: TLabel
            Left = 3
            Top = 32
            Width = 34
            Height = 13
            Caption = 'Diffuse'
          end
          object Label5: TLabel
            Left = 4
            Top = 76
            Width = 46
            Height = 13
            Caption = 'Position X'
          end
          object Label10: TLabel
            Left = 4
            Top = 99
            Width = 46
            Height = 13
            Caption = 'Position Y'
          end
          object Label11: TLabel
            Left = 4
            Top = 122
            Width = 46
            Height = 13
            Caption = 'Position Z'
          end
          object Label12: TLabel
            Left = 4
            Top = 208
            Width = 57
            Height = 26
            Caption = 'Quadratic Attenuation'
            WordWrap = True
          end
          object Label13: TLabel
            Left = 4
            Top = 185
            Width = 57
            Height = 26
            Caption = 'Linear Attenuation'
            WordWrap = True
          end
          object Label14: TLabel
            Left = 4
            Top = 162
            Width = 57
            Height = 26
            Caption = 'Const Attenuation'
            WordWrap = True
          end
          object LightAmbientBtn: TJvOfficeColorButton
            Left = 87
            Top = 4
            Width = 48
            Height = 22
            TabOrder = 0
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object LightDiffuseBtn: TJvOfficeColorButton
            Left = 87
            Top = 28
            Width = 48
            Height = 22
            TabOrder = 1
            SelectedColor = clDefault
            HotTrackFont.Charset = DEFAULT_CHARSET
            HotTrackFont.Color = clWindowText
            HotTrackFont.Height = -11
            HotTrackFont.Name = 'Tahoma'
            HotTrackFont.Style = []
            Properties.NoneColorCaption = 'No Color'
            Properties.DefaultColorCaption = 'Automatic'
            Properties.CustomColorCaption = 'Other Colors...'
            Properties.NoneColorHint = 'No Color'
            Properties.DefaultColorHint = 'Automatic'
            Properties.CustomColorHint = 'Other Colors...'
            Properties.NoneColorFont.Charset = DEFAULT_CHARSET
            Properties.NoneColorFont.Color = clWindowText
            Properties.NoneColorFont.Height = -11
            Properties.NoneColorFont.Name = 'Tahoma'
            Properties.NoneColorFont.Style = []
            Properties.DefaultColorFont.Charset = DEFAULT_CHARSET
            Properties.DefaultColorFont.Color = clWindowText
            Properties.DefaultColorFont.Height = -11
            Properties.DefaultColorFont.Name = 'Tahoma'
            Properties.DefaultColorFont.Style = []
            Properties.CustomColorFont.Charset = DEFAULT_CHARSET
            Properties.CustomColorFont.Color = clWindowText
            Properties.CustomColorFont.Height = -11
            Properties.CustomColorFont.Name = 'Tahoma'
            Properties.CustomColorFont.Style = []
            Properties.FloatWindowCaption = 'Color Window'
            Properties.DragBarHint = 'Drag to float'
            OnColorChange = SurfaceColorBtnColorChange
            OnClick = SurfaceColorBtnClick
          end
          object LightPositionXEdit: TEdit
            Left = 70
            Top = 73
            Width = 54
            Height = 21
            TabOrder = 2
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object LightPositionXBtn: TUpDown
            Left = 124
            Top = 73
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 3
            OnClick = LightPositionXBtnClick
          end
          object LightPositionYEdit: TEdit
            Left = 70
            Top = 96
            Width = 54
            Height = 21
            TabOrder = 4
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object LightPositionYBtn: TUpDown
            Left = 124
            Top = 96
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 5
            OnClick = LightPositionYBtnClick
          end
          object LightPositionZEdit: TEdit
            Left = 70
            Top = 119
            Width = 54
            Height = 21
            TabOrder = 6
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object LightPositionZBtn: TUpDown
            Left = 124
            Top = 119
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 7
            OnClick = LightPositionZBtnClick
          end
          object ConstAttenuationEdit: TEdit
            Left = 70
            Top = 165
            Width = 54
            Height = 21
            TabOrder = 8
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object QuadraticAttenuationBtn: TUpDown
            Left = 124
            Top = 211
            Width = 17
            Height = 21
            Max = -32000
            TabOrder = 9
            OnClick = QuadraticAttenuationBtnClick
          end
          object QuadraticAttenuationEdit: TEdit
            Left = 70
            Top = 211
            Width = 54
            Height = 21
            TabOrder = 10
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object LinearAttenuationBtn: TUpDown
            Left = 124
            Top = 188
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 11
            OnClick = LinearAttenuationBtnClick
          end
          object LinearAttenuationEdit: TEdit
            Left = 70
            Top = 188
            Width = 54
            Height = 21
            TabOrder = 12
            Text = '0'
            OnExit = MatShininessEditExit
          end
          object ConstAttenuationBtn: TUpDown
            Left = 124
            Top = 165
            Width = 17
            Height = 21
            Min = -32000
            Max = 32000
            TabOrder = 13
            OnClick = ConstAttenuationBtnClick
          end
        end
      end
    end
  end
  object ColorDialog: TColorDialog
    Left = 328
    Top = 136
  end
end
