object MainForm: TMainForm
  Left = 0
  Top = 0
  ActiveControl = btnFileOpen
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MainForm'
  ClientHeight = 290
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object grpAudioControl: TGroupBox
    Left = 184
    Top = 164
    Width = 216
    Height = 91
    Caption = 'Play Control'
    TabOrder = 8
    object trackBarAudioVolume: TTrackBar
      Left = 56
      Top = 16
      Width = 157
      Height = 24
      Max = 100
      ParentShowHint = False
      Frequency = 5
      Position = 80
      PositionToolTip = ptBottom
      SelEnd = 80
      ShowHint = True
      TabOrder = 0
      ThumbLength = 12
      OnChange = trackBarAudioVolumeChange
    end
    object btnAudioPlay: TButton
      Left = 8
      Top = 60
      Width = 48
      Height = 25
      Caption = 'Play'
      TabOrder = 4
      OnClick = btnAudioPlayClick
    end
    object btnAudioStop: TButton
      Left = 160
      Top = 60
      Width = 48
      Height = 25
      Caption = 'Stop'
      TabOrder = 6
      OnClick = btnAudioStopClick
    end
    object trackBarAudioPosition: TTrackBar
      Left = 56
      Top = 37
      Width = 157
      Height = 24
      Enabled = False
      Max = 100
      ParentShowHint = False
      Frequency = 5
      PositionToolTip = ptBottom
      ShowHint = True
      TabOrder = 2
      ThumbLength = 12
      OnEndDrag = trackBarAudioPositionEndDrag
    end
    object txtAudioVolume: TStaticText
      Left = 8
      Top = 20
      Width = 42
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Volume:'
      FocusControl = trackBarAudioVolume
      TabOrder = 1
    end
    object txtPosition: TStaticText
      Left = 8
      Top = 41
      Width = 42
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Position:'
      FocusControl = trackBarAudioPosition
      TabOrder = 3
    end
    object btnAudioPause: TButton
      Left = 84
      Top = 60
      Width = 48
      Height = 25
      Caption = 'Pause'
      TabOrder = 5
      OnClick = btnAudioPauseClick
    end
  end
  object grpAudioInfo: TGroupBox
    Left = 184
    Top = 8
    Width = 216
    Height = 101
    Caption = 'Audio Info'
    TabOrder = 1
    object txtAudioTitle: TStaticText
      Left = 4
      Top = 14
      Width = 208
      Height = 18
      AutoSize = False
      TabOrder = 0
    end
    object txtAudioArtist: TStaticText
      Left = 4
      Top = 29
      Width = 208
      Height = 18
      AutoSize = False
      TabOrder = 1
    end
    object txtAudioAlbum: TStaticText
      Left = 4
      Top = 45
      Width = 208
      Height = 18
      AutoSize = False
      TabOrder = 2
    end
    object txtAudioTrack: TStaticText
      Left = 4
      Top = 61
      Width = 23
      Height = 18
      AutoSize = False
      TabOrder = 3
    end
    object txtAudioComment: TStaticText
      Left = 4
      Top = 77
      Width = 208
      Height = 18
      AutoSize = False
      TabOrder = 4
    end
  end
  object grpFileControl: TGroupBox
    Left = 8
    Top = 8
    Width = 170
    Height = 247
    Caption = 'File List'
    TabOrder = 0
    object btnFileOpen: TButton
      Left = 6
      Top = 14
      Width = 48
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = btnFileOpenClick
    end
    object btnFileClose: TButton
      Left = 61
      Top = 14
      Width = 48
      Height = 25
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnFileCloseClick
    end
    object lvPlayList: TListView
      Left = 2
      Top = 48
      Width = 166
      Height = 197
      Align = alBottom
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Checkboxes = True
      Columns = <
        item
          Caption = 'Name'
          Width = 150
        end>
      ColumnClick = False
      FlatScrollBars = True
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ShowWorkAreas = True
      TabOrder = 3
      ViewStyle = vsReport
      OnDblClick = lvPlayListDblClick
    end
    object btnFileClear: TButton
      Left = 116
      Top = 14
      Width = 48
      Height = 25
      Caption = 'Clear'
      TabOrder = 2
      OnClick = btnFileClearClick
    end
  end
  object btnTestSound: TButton
    Left = 416
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Sound Test'
    TabOrder = 2
    OnClick = btnTestSoundClick
  end
  object btnTestMusic: TButton
    Left = 416
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Music Test'
    TabOrder = 3
    OnClick = btnTestMusicClick
  end
  object btnTestEffect: TButton
    Left = 416
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Effect Test'
    TabOrder = 4
    OnClick = btnTestEffectClick
  end
  object btnTestWaveGen: TButton
    Left = 416
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Wave Gen'
    TabOrder = 5
    OnClick = btnTestWaveGenClick
  end
  object radioGrpWaveGen: TRadioGroup
    Left = 406
    Top = 139
    Width = 95
    Height = 116
    Caption = 'Wave Gen'
    ItemIndex = 3
    Items.Strings = (
      'Tone'
      'Square Wave'
      'White Noise'
      'Pink Noise')
    TabOrder = 7
  end
  object btnGetInfo: TButton
    Left = 8
    Top = 258
    Width = 75
    Height = 25
    Caption = 'Info'
    TabOrder = 9
    OnClick = btnGetInfoClick
  end
  object cbbDeviceTypeList: TComboBox
    Left = 89
    Top = 261
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    OnChange = cbbDeviceTypeListChange
  end
  object cbbDeviceList: TComboBox
    Left = 217
    Top = 261
    Width = 285
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
  end
  object radiogrpPlayMode: TRadioGroup
    Left = 184
    Top = 111
    Width = 216
    Height = 51
    Caption = 'Play Mode'
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      'Single'
      'Sequence'
      'Random'
      'Repeat'
      'Repeat All')
    TabOrder = 6
    OnClick = radiogrpPlayModeClick
  end
  object dlgOpen: TOpenDialog
    Filter = 'mp3 file (*.mp3;*.mp2)|*.mp3; *.mp2|ogg file (*.ogg)|*.ogg'
    Options = [ofReadOnly, ofOverwritePrompt, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofCreatePrompt, ofShareAware, ofNoDereferenceLinks, ofEnableIncludeNotify, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Left = 64
    Top = 104
  end
  object timer: TTimer
    Interval = 500
    OnTimer = timerTimer
    Left = 64
    Top = 204
  end
  object XPManifest1: TXPManifest
    Left = 132
    Top = 204
  end
end
