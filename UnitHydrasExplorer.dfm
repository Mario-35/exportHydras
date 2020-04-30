object FormHydrasExplorer: TFormHydrasExplorer
  Left = 843
  Top = 335
  Width = 1305
  Height = 675
  Caption = 'FormHydrasExplorer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelContent: TPanel
    Left = 0
    Top = 41
    Width = 1289
    Height = 595
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 251
      Top = 1
      Width = 5
      Height = 593
    end
    object Splitter2: TSplitter
      Left = 499
      Top = 1
      Width = 5
      Height = 593
    end
    object PanelStation: TPanel
      Left = 1
      Top = 1
      Width = 250
      Height = 593
      Align = alLeft
      TabOrder = 0
      object LabelRegions: TLabel
        Left = 1
        Top = 1
        Width = 248
        Height = 20
        Align = alTop
        Alignment = taCenter
        Caption = 'Root / Area'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBGridRoot: TDBGrid
        Left = 1
        Top = 21
        Width = 248
        Height = 571
        Align = alClient
        DataSource = DataSourceRegions
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = DBGridRootCellClick
      end
    end
    object Panel2: TPanel
      Left = 504
      Top = 1
      Width = 784
      Height = 593
      Align = alClient
      TabOrder = 1
      object LabelCapteurs: TLabel
        Left = 1
        Top = 1
        Width = 782
        Height = 16
        Align = alTop
        Alignment = taCenter
        Caption = 'Stations / Capteurs'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBGridStations: TDBGrid
        Left = 1
        Top = 17
        Width = 782
        Height = 575
        Align = alClient
        DataSource = DataSourceCapteurs
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
    object PanelStations: TPanel
      Left = 256
      Top = 1
      Width = 243
      Height = 593
      Align = alLeft
      TabOrder = 2
      object LabelStations: TLabel
        Left = 1
        Top = 1
        Width = 241
        Height = 20
        Align = alTop
        Alignment = taCenter
        Caption = 'Regions'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DBGridRegions: TDBGrid
        Left = 1
        Top = 21
        Width = 241
        Height = 571
        Align = alClient
        DataSource = DataSourceStations
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnCellClick = DBGridStationsCellClick
      end
    end
  end
  object PanelHaut: TPanel
    Left = 0
    Top = 0
    Width = 1289
    Height = 41
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 346
      Top = 8
      Width = 23
      Height = 22
      OnClick = SpeedButton1Click
    end
    object LabelPath: TLabel
      Left = 7
      Top = 12
      Width = 41
      Height = 13
      Caption = 'Chemin :'
    end
    object EditPath: TEdit
      Left = 48
      Top = 8
      Width = 297
      Height = 21
      TabOrder = 0
      Text = 'EditPath'
    end
  end
  object DataSourceRegions: TDataSource
    Left = 26
    Top = 131
  end
  object DataSourceStations: TDataSource
    Left = 410
    Top = 147
  end
  object DataSourceCapteurs: TDataSource
    Left = 658
    Top = 155
  end
  object DataSourceRoot: TDataSource
    Left = 178
    Top = 99
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'DB'
    FileName = 'GB_DATEI.DB'
    Filter = 'GB_DATEI.DB'
    Options = [ofReadOnly, ofEnableSizing, ofDontAddToRecent]
    Left = 716
    Top = 32
  end
end
