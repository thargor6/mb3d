object BatchForm1: TBatchForm1
  Left = 197
  Top = 91
  Caption = 'Batch processing'
  ClientHeight = 539
  ClientWidth = 565
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 360
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 565
    Height = 462
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'M3P files that should be rendered to M3I'
      end
      item
        Caption = 'Status'
        Width = 100
      end>
    ColumnClick = False
    GridLines = True
    HotTrack = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    ShowWorkAreas = True
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = ListView1Change
    OnInsert = ListView1Insert
    OnKeyDown = ListView1KeyDown
    ExplicitHeight = 470
  end
  object Panel1: TPanel
    Left = 0
    Top = 462
    Width = 565
    Height = 77
    Align = alBottom
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ExplicitTop = 468
    object Button1: TButton
      Left = 201
      Top = 43
      Width = 126
      Height = 25
      Hint = 'Starts rendering all selected M3P files'
      Caption = 'Start batch rendering'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object CheckBox1: TCheckBox
      Left = 12
      Top = 7
      Width = 153
      Height = 17
      Hint = 
        'Select this if you want to overwrite existing M3I files with the' +
        ' same name.'#13#10'If not selected, the name will be modified so that ' +
        'no files will be overwritten.'
      Caption = 'Overwrite existing M3I files'
      Checked = True
      Enabled = False
      State = cbChecked
      TabOrder = 1
    end
    object Button2: TButton
      Left = 477
      Top = 47
      Width = 81
      Height = 25
      Caption = 'Close window'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 201
      Top = 6
      Width = 126
      Height = 25
      Hint = 'Click to select one and more M3P files to put into the list.'
      Caption = 'Open files'
      TabOrder = 3
      OnClick = Button3Click
    end
    object CheckBox2: TCheckBox
      Left = 12
      Top = 29
      Width = 161
      Height = 17
      Hint = 
        'If selected, the M3I files will be stored in the default M3I fol' +
        'der,'#13#10'  that is specified by the '#39'INI DIRS'#39' option.'#13#10'If not sele' +
        'cted, they are stored in the same folder as the M3P files.'
      Caption = 'Store M3I file in default folder'
      TabOrder = 4
    end
    object Button4: TButton
      Left = 344
      Top = 6
      Width = 126
      Height = 25
      Hint = 'Click to open the explorer and drag&&drop M3P files on the list.'
      Caption = 'Open explorer'
      TabOrder = 5
      OnClick = Button4Click
    end
    object SavePNGPreviewCBx: TCheckBox
      Left = 12
      Top = 51
      Width = 161
      Height = 17
      Hint = 
        'Store an additional corresponding *.PNG-file for simpler preview' +
        ' of the image'
      Caption = 'Store PNG-preview'
      Checked = True
      State = cbChecked
      TabOrder = 6
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 88
    Top = 48
    object Deleteselectedfilesfromlist1: TMenuItem
      Caption = 'Delete highlighted files from the list'
      OnClick = Deleteselectedfilesfromlist1Click
    end
    object Clearthewholelist1: TMenuItem
      Caption = 'Clear the whole list'
      OnClick = Clearthewholelist1Click
    end
  end
end
