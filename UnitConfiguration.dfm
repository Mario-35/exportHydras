object FormConfiguration: TFormConfiguration
  Left = 809
  Top = 135
  BorderStyle = bsToolWindow
  Caption = 'Configuration'
  ClientHeight = 578
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBas: TPanel
    Left = 0
    Top = 537
    Width = 704
    Height = 41
    Align = alBottom
    TabOrder = 0
    object BitBtnOk: TBitBtn
      Left = 520
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = SaveConfig
      Kind = bkOK
    end
    object BitBtnCancel: TBitBtn
      Left = 600
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = CancelConfig
      Kind = bkCancel
    end
  end
  object PageControlConfiguration: TPageControl
    Left = 0
    Top = 0
    Width = 704
    Height = 537
    ActivePage = TabSheetconfiguration
    Align = alClient
    TabOrder = 1
    OnChange = PageControlConfigurationChange
    object TabSheetconfiguration: TTabSheet
      Caption = 'Configuration Base de donn'#233'es'
      object PanelConnectionPostgres: TPanel
        Left = 8
        Top = 8
        Width = 329
        Height = 193
        TabOrder = 0
        object LabelPanelConnectionPostgres: TLabel
          Left = 1
          Top = 1
          Width = 327
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Connection '#224' la base postgres'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelHostname: TLabel
          Left = 10
          Top = 40
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Hostname'
          FocusControl = EditHostname
        end
        object LabelPort: TLabel
          Left = 10
          Top = 65
          Width = 60
          Height = 13
          Hint = 'Port (postgres 5432)'
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'P&ort'
          FocusControl = EditPort
        end
        object LabelUser: TLabel
          Left = 10
          Top = 90
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&User'
          FocusControl = EditUser
        end
        object LabelPassword: TLabel
          Left = 10
          Top = 115
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Password'
        end
        object LabelDatabase: TLabel
          Left = 10
          Top = 140
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Database'
          FocusControl = EditDatabase
        end
        object SpeedButtonGetDatabase: TSpeedButton
          Left = 289
          Top = 132
          Width = 24
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFE8E4DFDDD7D1CDC5BCB8ACA0AC9F90B4A89BC7BEB4D9D3CCDFDAD4E0DBD5
            D8D2CBE0DAD5F8F7F6FFFFFFFFFFFFFFFFFFFEFEFEFFFFFFEFEDEABDB2A7EAE7
            E3EBE9E5C4BAB09E8E7D968574A99B8DC8BFB6E7E3DFFEFDFDFCFBFBE9E5E2C6
            BCB3AC9F90D5CEC7FFFFFFFEFEFDFCFCFBFFFFFFCEC5BDBFB5AAFFFFFFEDEAE7
            BEB4AA98877592816FA89A8BCAC1B8EBE7E4FFFFFFFFFFFFEBE7E4CDC4BBAC9E
            91AA9C8DFFFFFFFEFEFEFDFCFCFFFFFFD2CBC3BEB3A9FEFEFEEEEBE8D2CBC3C0
            B6ABBFB4A9C6BDB4D0C9C1DCD6D1E6E2DDE9E5E2E2DDD8CEC6BEAC9E8FAEA093
            FFFFFFFFFFFEFCFCFBFFFFFFD5CDC6CBC3BAFAFAF9F0EEEBD3CBC4B0A497A495
            86AEA193C4BBB1DAD4CEE7E2DEE2DED8D2CAC2C2B8ADB9ADA1B8ACA0FFFFFFFF
            FFFFFDFCFCFFFFFFD6CFC8C4BAB0FFFFFEEDEAE8C0B5AB988776917F6DA69788
            C7BEB5E8E4E0FFFFFFFFFFFFEBE8E5CBC2BAADA092B9ADA1FFFFFFFFFFFFFCFC
            FBFFFFFFD1C9C1BBB0A4FFFFFFEBE8E5C0B6AB9E8E7E9C8C7BB0A396CDC5BDE9
            E5E2FDFDFDFEFDFDEAE7E3CCC4BCA99B8CAD9F92FFFFFFFFFFFEFCFCFBFFFFFF
            D2CAC3C0B6ABFCFCFBEEECE9DAD4CEC7BDB4C0B5AAC4BAB0CDC5BDD8D1CADED9
            D3DFD9D3D9D2CBCDC4BBB0A396AC9F91FFFFFFFEFEFEFDFCFCFFFFFFD7D1C9CC
            C4BBFCFBFBEFECEAC6BDB49E8E7E948371A69889C5BCB2E4E0DBF8F6F5F5F3F1
            DFDAD5C5BBB1B8ACA0BDB2A7FFFFFFFFFFFFFCFCFBFFFFFFD3CBC4BDB2A70262
            C70262C7BEB4A9978574907E6CA69788C7BEB5E8E4E1FFFFFFFFFEFFEBE7E4CD
            C4BCAA9C8EB1A497FFFFFFFFFFFFFCFCFB0262C70262C7B5ADA60262C70262C7
            C2BDB60262C70262C7C0B5AAD1CAC2E4DFDBF2F0EDF5F3F0E7E4E0CDC5BCA99B
            8CAC9F91FFFFFFFEFEFEFCFCFB0262C7208BFC0262C70262C76AB1FD0262C708
            7EFC0262C7B7AB9FC7BEB5D9D2CCE3DDD8E0DBD4D3CCC4C8BEB5B7AB9FB2A598
            FFFFFFFFFEFEFDFCFCF9FBFD0262C760AAF96FB4FD6AB1FD54A4FA0262C78C7D
            6DA69788C7BDB4E7E3DFFEFDFEFEFDFDE9E6E2C9C0B6B1A497BCB1A5FFFFFFFF
            FFFF0262C70262C70262C790C5FEA4D0FEA1CEFE87C0FEABD2FD0262C70262C7
            CBC3BAEBE8E5FFFFFFFFFFFFEAE7E3CBC3BAA99A8CAD9F92FFFFFFFFFFFF0262
            C70262C7ABD2FDABD2FDD4E9FED6EAFFAED4FD0262C70262C70262C7CCC4BBCF
            C7BFD7D0C9DFDAD4DFDBD5D2CBC3AEA193AC9F91FFFFFFFEFEFEFDFCFCF6F9FA
            0262C7A0CAF6D2E6FCE3F0FDAFD0F50262C7D5D4D5D5CEC7C5BCB2B5A89CA393
            84978674978675A49585B3A699B9ADA1FFFFFFFFFFFFFEFDFD0262C75FACFD02
            62C70A80FCABD2FD0262C77CB9FC0262C7F2F0EFEAE7E4E1DCD8D6CFC8C5BCB2
            B1A4979D8D7C9F8F7FCDC5BBFFFFFFFEFEFEFFFFFF0262C70262C7E4E3E20262
            C70262C7B5ABA10262C70262C7D2CBC4D5CDC7D2CBC3CDC4BCC4BAB0BEB3A8C8
            BEB4E1DCD7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFF0262C70262C7
            E7E3DFD1C9C1CBC2B9CBC2B9CBC2B9D0C8BFD0C8BFDBD5CFF3F1EFF3F1EFFFFF
            FFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          OnClick = SelectPostgresDatabase
        end
        object EditHostname: TEdit
          Left = 80
          Top = 35
          Width = 233
          Height = 21
          Hint = 'Hostname'
          TabOrder = 0
          OnExit = EditExit
        end
        object EditPort: TEdit
          Left = 80
          Top = 60
          Width = 49
          Height = 21
          Hint = 'Port'
          TabOrder = 1
          OnExit = EditExit
        end
        object EditUser: TEdit
          Left = 80
          Top = 85
          Width = 233
          Height = 21
          Hint = 'User'
          TabOrder = 2
          OnExit = EditExit
        end
        object EditDatabase: TEdit
          Left = 80
          Top = 135
          Width = 209
          Height = 21
          Hint = 'Database'
          TabOrder = 3
          OnExit = EditExit
        end
        object ButtonTestConnection: TButton
          Left = 80
          Top = 160
          Width = 233
          Height = 25
          Caption = 'Tester la connection'
          TabOrder = 4
          OnClick = TestPostgresConnection
        end
        object MaskEditPassword: TMaskEdit
          Left = 80
          Top = 110
          Width = 233
          Height = 21
          Hint = 'Password'
          PasswordChar = '#'
          TabOrder = 5
          Text = 'MaskEditPassword'
          OnExit = EditExit
        end
      end
      object PanelHydras: TPanel
        Left = 350
        Top = 8
        Width = 330
        Height = 50
        TabOrder = 1
        object LabelPanelHydras: TLabel
          Left = 1
          Top = 1
          Width = 328
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Repertoire Hydras'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object SpeedButtonPanelHydras: TSpeedButton
          Left = 303
          Top = 23
          Width = 24
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000232E0000232E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6ECECECECEC
            ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
            ECECECECECEFEFEFFCFCFCFFFFFFFFFFFFFFFFFFB2B6BA646C73666D74666D74
            666D74666D74666D74666D74666D74666D74666D74666D74666D74666D74666D
            74787B7EE0E0E0FFFFFFFFFFFFFFFFFF00ADE51DC9F71EC8F71EC9F71DC9F81D
            C8F71AC8F718C8F712C7F70FC7F708C6F703C5F700C5F700C4F700C5F8437FA1
            D8D8D8FFFFFFFFFFFFFFFFFF00B6EA30D5FE32D5FE32D5FE31D4FE30D5FF2DD4
            FE2AD3FF26D3FE22D2FE1DD1FE19D0FE14CEFF0FCEFE0BCFFF467E9FD8D8D8FF
            FFFFFFFFFFFFFFFF00B8EA38D7FF3AD6FF3BD7FE3AD7FF37D7FF35D6FE31D5FF
            2DD4FE28D4FE23D2FF1ED1FF18D0FE13CFFE0ED0FF467E9FD8D8D8FFFFFFFFFF
            FFFFFFFF00BCE948D9FE42D8FE43D8FF42D9FE40D8FF3CD7FE38D6FF34D6FE2E
            D4FE28D4FE22D2FE1CD1FE17D0FF11D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF
            2FBFEA73E2FF4FDBFE4ADBFE4ADAFE48D9FF43D9FF3FD7FE39D7FE34D5FE2ED5
            FF28D3FF20D2FE1AD0FE15D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF47C1E988
            E7FF7CE4FF57DCFE51DCFF4EDBFF4BDAFF46D9FF3FD8FF39D7FE33D5FF2CD4FF
            25D2FE1DD2FF17D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF58C4EA99EAFF98EA
            FE8CE7FF64DFFE54DCFF50DBFF4BDAFF45D9FE3ED7FF36D6FE2ED4FF28D3FF20
            D2FE19D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF68C6EAA9EEFFA8EDFFA3ECFF
            9CEBFF7EE4FF59DCFE4EDBFE49DAFE41D9FE39D6FF31D6FF2AD3FF22D3FE1CD2
            FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF65C3E8BCF2FFB5F0FFB1EFFFA9EDFFA0
            ECFF92E9FF7FE4FF61DFFF44D9FF32D6FE2FD5FE2AD4FF23D2FF1DD2FF467E9F
            D8D8D8FFFFFFFFFFFFFFFFFF51B6DE7BD5F2C1F3FFBEF2FFB4EFFFACEEFFA6ED
            FFA5EDFEA4ECFFA3ECFE88E7FE6BE0FE4FDAFE37D6FF28D4FF467D9FD8D8D8FF
            FFFFFFFFFFFFFFFFBED9ED41CBF851BEF081D0EEBAF2FFB8F3FFBBF4FFBCF5FF
            BEF5FFC1F6FFC3F6FFC0F5FFB2F3FF9BEFFF7DEAFF4C81A4DEDEDEFFFFFFFFFF
            FFFFFFFFBAD8ED81E5FF65DAFF40C6FF00ADF300A9EB00A5E100A3E000A1E000
            A0E0009FE000A0E000A1E000A3E0009CD697AFC1FBFBFBFFFFFFFFFFFFFFFFFF
            B8D7EDACF1FF9FEBFF91E9FF7CE3FF4AC5F000A6D400AEDB00AEDB00AFDC00B0
            DC00B0DC00B0DC00B1DD00AEDAEEEBE9FFFFFFFFFFFFFFFFFFFFFFFFDCEDF71D
            C1E874CCED65CAED4FC7ED7FBFD6F3F0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          Transparent = False
          OnClick = SpeedButtonPanelHydrasClick
        end
        object EditPanelHydras: TEdit
          Left = 5
          Top = 25
          Width = 295
          Height = 21
          Hint = 'HydrasFolder'
          TabOrder = 0
          Text = 'EditPanelHydras'
        end
      end
      object PanelRX: TPanel
        Left = 350
        Top = 69
        Width = 330
        Height = 50
        TabOrder = 2
        object SpeedButtonPanelRX: TSpeedButton
          Left = 303
          Top = 23
          Width = 24
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000232E0000232E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6ECECECECEC
            ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
            ECECECECECEFEFEFFCFCFCFFFFFFFFFFFFFFFFFFB2B6BA646C73666D74666D74
            666D74666D74666D74666D74666D74666D74666D74666D74666D74666D74666D
            74787B7EE0E0E0FFFFFFFFFFFFFFFFFF00ADE51DC9F71EC8F71EC9F71DC9F81D
            C8F71AC8F718C8F712C7F70FC7F708C6F703C5F700C5F700C4F700C5F8437FA1
            D8D8D8FFFFFFFFFFFFFFFFFF00B6EA30D5FE32D5FE32D5FE31D4FE30D5FF2DD4
            FE2AD3FF26D3FE22D2FE1DD1FE19D0FE14CEFF0FCEFE0BCFFF467E9FD8D8D8FF
            FFFFFFFFFFFFFFFF00B8EA38D7FF3AD6FF3BD7FE3AD7FF37D7FF35D6FE31D5FF
            2DD4FE28D4FE23D2FF1ED1FF18D0FE13CFFE0ED0FF467E9FD8D8D8FFFFFFFFFF
            FFFFFFFF00BCE948D9FE42D8FE43D8FF42D9FE40D8FF3CD7FE38D6FF34D6FE2E
            D4FE28D4FE22D2FE1CD1FE17D0FF11D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF
            2FBFEA73E2FF4FDBFE4ADBFE4ADAFE48D9FF43D9FF3FD7FE39D7FE34D5FE2ED5
            FF28D3FF20D2FE1AD0FE15D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF47C1E988
            E7FF7CE4FF57DCFE51DCFF4EDBFF4BDAFF46D9FF3FD8FF39D7FE33D5FF2CD4FF
            25D2FE1DD2FF17D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF58C4EA99EAFF98EA
            FE8CE7FF64DFFE54DCFF50DBFF4BDAFF45D9FE3ED7FF36D6FE2ED4FF28D3FF20
            D2FE19D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF68C6EAA9EEFFA8EDFFA3ECFF
            9CEBFF7EE4FF59DCFE4EDBFE49DAFE41D9FE39D6FF31D6FF2AD3FF22D3FE1CD2
            FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF65C3E8BCF2FFB5F0FFB1EFFFA9EDFFA0
            ECFF92E9FF7FE4FF61DFFF44D9FF32D6FE2FD5FE2AD4FF23D2FF1DD2FF467E9F
            D8D8D8FFFFFFFFFFFFFFFFFF51B6DE7BD5F2C1F3FFBEF2FFB4EFFFACEEFFA6ED
            FFA5EDFEA4ECFFA3ECFE88E7FE6BE0FE4FDAFE37D6FF28D4FF467D9FD8D8D8FF
            FFFFFFFFFFFFFFFFBED9ED41CBF851BEF081D0EEBAF2FFB8F3FFBBF4FFBCF5FF
            BEF5FFC1F6FFC3F6FFC0F5FFB2F3FF9BEFFF7DEAFF4C81A4DEDEDEFFFFFFFFFF
            FFFFFFFFBAD8ED81E5FF65DAFF40C6FF00ADF300A9EB00A5E100A3E000A1E000
            A0E0009FE000A0E000A1E000A3E0009CD697AFC1FBFBFBFFFFFFFFFFFFFFFFFF
            B8D7EDACF1FF9FEBFF91E9FF7CE3FF4AC5F000A6D400AEDB00AEDB00AFDC00B0
            DC00B0DC00B0DC00B1DD00AEDAEEEBE9FFFFFFFFFFFFFFFFFFFFFFFFDCEDF71D
            C1E874CCED65CAED4FC7ED7FBFD6F3F0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          Transparent = False
          OnClick = SpeedButtonPanelRXClick
        end
        object LabelRX: TLabel
          Left = 1
          Top = 1
          Width = 328
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Repertoire RX'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditPanelRX: TEdit
          Left = 5
          Top = 23
          Width = 295
          Height = 21
          Hint = 'HydrasFolder'
          TabOrder = 0
          Text = 'EditPanelRX'
        end
      end
      object PanelConnectionPostgresAdmin: TPanel
        Left = 8
        Top = 216
        Width = 329
        Height = 289
        TabOrder = 3
        object Label2: TLabel
          Left = 26
          Top = 65
          Width = 46
          Height = 13
          Alignment = taRightJustify
          Caption = '&Password'
        end
        object LabelAdmin: TLabel
          Left = 10
          Top = 40
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Admin'
          FocusControl = EditAdminUser
        end
        object LabelPocedures: TLabel
          Left = 1
          Top = 124
          Width = 327
          Height = 20
          Align = alBottom
          Alignment = taCenter
          Caption = 'Procedures identif'#233'es'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 1
          Top = 1
          Width = 327
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Connection '#224' la base admin'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MaskEditAdminPassword: TMaskEdit
          Left = 80
          Top = 60
          Width = 233
          Height = 21
          Hint = 'AdminPassword'
          PasswordChar = '#'
          TabOrder = 0
          Text = 'MaskEditPassword'
          OnExit = EditExit
        end
        object EditAdminUser: TEdit
          Left = 80
          Top = 35
          Width = 233
          Height = 21
          Hint = 'AdminUser'
          TabOrder = 1
          OnExit = EditExit
        end
        object ButtonTestConnectionAdwin: TButton
          Left = 80
          Top = 88
          Width = 233
          Height = 25
          Caption = 'Tester la connection admin'
          TabOrder = 2
          OnClick = ButtonTestConnectionAdwinClick
        end
        object CheckListBoxScripts: TCheckListBox
          Left = 1
          Top = 144
          Width = 327
          Height = 144
          Align = alBottom
          Color = 14869218
          ItemHeight = 13
          PopupMenu = PopupMenuProcedures
          TabOrder = 3
        end
        object Button1: TButton
          Left = 16
          Top = 96
          Width = 75
          Height = 25
          Caption = 'Button1'
          TabOrder = 4
        end
      end
    end
    object TabSheetImportCsv: TTabSheet
      Caption = 'Survellance et Importation'
      ImageIndex = 1
      DesignSize = (
        696
        509)
      object Splitter1: TSplitter
        Left = 0
        Top = 0
        Height = 509
      end
      object Panel1: TPanel
        Left = 8
        Top = 8
        Width = 329
        Height = 193
        TabOrder = 0
        object LabelParamImports: TLabel
          Left = 1
          Top = 1
          Width = 255
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Param'#233'trages d'#39'importation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LabelTampon: TLabel
          Left = 10
          Top = 40
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Tampon'
        end
        object SpinEditTampon: TSpinEdit
          Left = 80
          Top = 35
          Width = 81
          Height = 22
          Hint = 'csvBuffer'
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnExit = EditExit
        end
        object CheckBoxLaurhAtStartup: TCheckBox
          Left = 32
          Top = 64
          Width = 201
          Height = 17
          Hint = 'launchWindowsStartup'
          Caption = 'Lancer au demmarage de windows'
          TabOrder = 1
          OnExit = EditExit
        end
        object CheckBoxlaunchMonitoringStartup: TCheckBox
          Left = 32
          Top = 87
          Width = 273
          Height = 17
          Hint = 'launchMonitoringStartup'
          Caption = 'Lancer la surveillance au d'#233'marrage de l'#39'application'
          TabOrder = 2
          OnExit = EditExit
        end
        object CheckBoxLaunchImportAtStartup: TCheckBox
          Left = 32
          Top = 111
          Width = 273
          Height = 17
          Hint = 'launchImportAtStartup'
          Caption = 'Lancer l'#39'importation au d'#233'marrage de l'#39'application'
          TabOrder = 3
          OnExit = EditExit
        end
      end
      object PanelClean: TPanel
        Left = 360
        Top = 8
        Width = 329
        Height = 193
        TabOrder = 1
        object LabelClean: TLabel
          Left = 1
          Top = 1
          Width = 165
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Chaine a nettoyer'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ValueListEditorCleanStation: TValueListEditor
          Left = 1
          Top = 25
          Width = 327
          Height = 167
          Hint = 'cleanStation'
          Align = alClient
          TabOrder = 0
          TitleCaptions.Strings = (
            'Recherche'
            'Remplace')
          OnExit = UpdateValueList
          ColWidths = (
            78
            243)
        end
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 216
        Width = 329
        Height = 281
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Optioens de survillance du r'#233'p'#233'rtoire des csv '
        TabOrder = 2
        DesignSize = (
          329
          281)
        object GroupBox2: TGroupBox
          Left = 8
          Top = 47
          Width = 305
          Height = 170
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Evenements des fichiers '
          TabOrder = 1
          object ckbFilenameChange: TCheckBox
            Left = 22
            Top = 24
            Width = 250
            Height = 17
            Hint = 'FilenameChange'
            Caption = 'Changement du nom de fichier'
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnExit = EditExit
          end
          object ckbDirNameChange: TCheckBox
            Left = 22
            Top = 40
            Width = 250
            Height = 17
            Hint = 'DirNameChange'
            Caption = 'Changement du nom de R'#233'p'#233'rtoire'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnExit = EditExit
          end
          object ckbAttrChange: TCheckBox
            Left = 22
            Top = 56
            Width = 250
            Height = 17
            Hint = 'AttributesChange'
            Caption = 'Changement des attrbuts'
            TabOrder = 2
            OnExit = EditExit
          end
          object ckbSizeChange: TCheckBox
            Left = 22
            Top = 72
            Width = 250
            Height = 17
            Hint = 'SizeChange'
            Caption = 'Changement de la taillle du fichier'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnExit = EditExit
          end
          object ckbWriteTimeChange: TCheckBox
            Left = 22
            Top = 89
            Width = 250
            Height = 17
            Hint = 'WriteTimeChange'
            Caption = 'Changement de l'#39'heure d'#39#233'criture'
            Checked = True
            State = cbChecked
            TabOrder = 4
            OnExit = EditExit
          end
          object ckbAccessTimeChange: TCheckBox
            Left = 22
            Top = 105
            Width = 250
            Height = 17
            Hint = 'AccessTimeChange'
            Caption = 'Changement de l'#39'heure du dernier acc'#234'es'
            TabOrder = 5
            OnExit = EditExit
          end
          object ckbCreationTimeChange: TCheckBox
            Left = 22
            Top = 120
            Width = 250
            Height = 17
            Hint = 'CreationTimeChange'
            Caption = 'Changement de l'#39'heure de cr'#233'ation'
            TabOrder = 6
            OnExit = EditExit
          end
          object ckbSecurityAttrChanges: TCheckBox
            Left = 22
            Top = 137
            Width = 250
            Height = 17
            Hint = 'SecurityAttrChanges'
            Caption = 'Changement des attrbuts de s'#233'curit'#233
            TabOrder = 7
            OnExit = EditExit
          end
        end
        object ckbMonitorSubfolders: TCheckBox
          Left = 8
          Top = 25
          Width = 161
          Height = 17
          Hint = 'MonitorSubfolders'
          Caption = 'Survillance des sous repertoires'
          TabOrder = 0
          OnExit = EditExit
        end
      end
      object PanelCsv: TPanel
        Left = 366
        Top = 221
        Width = 329
        Height = 75
        TabOrder = 3
        object SpeedButton1: TSpeedButton
          Left = 303
          Top = 23
          Width = 23
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000232E0000232E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6ECECECECEC
            ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEC
            ECECECECECEFEFEFFCFCFCFFFFFFFFFFFFFFFFFFB2B6BA646C73666D74666D74
            666D74666D74666D74666D74666D74666D74666D74666D74666D74666D74666D
            74787B7EE0E0E0FFFFFFFFFFFFFFFFFF00ADE51DC9F71EC8F71EC9F71DC9F81D
            C8F71AC8F718C8F712C7F70FC7F708C6F703C5F700C5F700C4F700C5F8437FA1
            D8D8D8FFFFFFFFFFFFFFFFFF00B6EA30D5FE32D5FE32D5FE31D4FE30D5FF2DD4
            FE2AD3FF26D3FE22D2FE1DD1FE19D0FE14CEFF0FCEFE0BCFFF467E9FD8D8D8FF
            FFFFFFFFFFFFFFFF00B8EA38D7FF3AD6FF3BD7FE3AD7FF37D7FF35D6FE31D5FF
            2DD4FE28D4FE23D2FF1ED1FF18D0FE13CFFE0ED0FF467E9FD8D8D8FFFFFFFFFF
            FFFFFFFF00BCE948D9FE42D8FE43D8FF42D9FE40D8FF3CD7FE38D6FF34D6FE2E
            D4FE28D4FE22D2FE1CD1FE17D0FF11D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF
            2FBFEA73E2FF4FDBFE4ADBFE4ADAFE48D9FF43D9FF3FD7FE39D7FE34D5FE2ED5
            FF28D3FF20D2FE1AD0FE15D1FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF47C1E988
            E7FF7CE4FF57DCFE51DCFF4EDBFF4BDAFF46D9FF3FD8FF39D7FE33D5FF2CD4FF
            25D2FE1DD2FF17D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF58C4EA99EAFF98EA
            FE8CE7FF64DFFE54DCFF50DBFF4BDAFF45D9FE3ED7FF36D6FE2ED4FF28D3FF20
            D2FE19D2FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF68C6EAA9EEFFA8EDFFA3ECFF
            9CEBFF7EE4FF59DCFE4EDBFE49DAFE41D9FE39D6FF31D6FF2AD3FF22D3FE1CD2
            FF467E9FD8D8D8FFFFFFFFFFFFFFFFFF65C3E8BCF2FFB5F0FFB1EFFFA9EDFFA0
            ECFF92E9FF7FE4FF61DFFF44D9FF32D6FE2FD5FE2AD4FF23D2FF1DD2FF467E9F
            D8D8D8FFFFFFFFFFFFFFFFFF51B6DE7BD5F2C1F3FFBEF2FFB4EFFFACEEFFA6ED
            FFA5EDFEA4ECFFA3ECFE88E7FE6BE0FE4FDAFE37D6FF28D4FF467D9FD8D8D8FF
            FFFFFFFFFFFFFFFFBED9ED41CBF851BEF081D0EEBAF2FFB8F3FFBBF4FFBCF5FF
            BEF5FFC1F6FFC3F6FFC0F5FFB2F3FF9BEFFF7DEAFF4C81A4DEDEDEFFFFFFFFFF
            FFFFFFFFBAD8ED81E5FF65DAFF40C6FF00ADF300A9EB00A5E100A3E000A1E000
            A0E0009FE000A0E000A1E000A3E0009CD697AFC1FBFBFBFFFFFFFFFFFFFFFFFF
            B8D7EDACF1FF9FEBFF91E9FF7CE3FF4AC5F000A6D400AEDB00AEDB00AFDC00B0
            DC00B0DC00B0DC00B1DD00AEDAEEEBE9FFFFFFFFFFFFFFFFFFFFFFFFDCEDF71D
            C1E874CCED65CAED4FC7ED7FBFD6F3F0EDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
          ParentFont = False
          Transparent = False
          OnClick = SpeedButton1Click
        end
        object LabelCsv: TLabel
          Left = 1
          Top = 1
          Width = 259
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Repertoire des fichiers CSV'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EditPanelCsv: TEdit
          Left = 5
          Top = 27
          Width = 295
          Height = 21
          Hint = 'CsvFolder'
          TabOrder = 0
          Text = 'EditPanelCsv'
        end
        object CheckBoxZipAfterImport: TCheckBox
          Left = 5
          Top = 50
          Width = 273
          Height = 20
          Hint = 'ZipAfterImport'
          Caption = 'Zipper les fichiers apr'#232's importation r'#233'ussie'
          TabOrder = 1
          OnExit = EditExit
        end
      end
    end
    object TabSheetHydras: TTabSheet
      Caption = 'Hydras'
      ImageIndex = 3
      object PanelSchemas: TPanel
        Left = 8
        Top = 8
        Width = 329
        Height = 193
        TabOrder = 0
        object LabelSchemas: TLabel
          Left = 1
          Top = 1
          Width = 327
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Domaine Schemas'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object ValueListEditorSchemas: TValueListEditor
          Left = 1
          Top = 25
          Width = 327
          Height = 167
          Align = alClient
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goRowSelect, goThumbTracking]
          PopupMenu = PopupMenuDomaines
          TabOrder = 0
          TitleCaptions.Strings = (
            'Domain'
            'Schemas')
          OnDblClick = SelectPostgresSchema
          OnExit = ValueListEditorSchemasExit
          OnSelectCell = ValueListEditorSchemasSelectCell
          ColWidths = (
            150
            171)
        end
      end
      object PanelExportAuto: TPanel
        Left = 344
        Top = 8
        Width = 345
        Height = 489
        TabOrder = 1
        object LabelExportAuto: TLabel
          Left = 1
          Top = 1
          Width = 343
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Exportation automatique'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CheckListBoxExportSensors: TCheckListBox
          Left = 1
          Top = 25
          Width = 343
          Height = 439
          Align = alClient
          ItemHeight = 13
          PopupMenu = PopupMenuExportSensors
          TabOrder = 0
        end
        object PanelExportAutoBas: TPanel
          Left = 1
          Top = 464
          Width = 343
          Height = 24
          Align = alBottom
          TabOrder = 1
          object SpeedButtonSaveExport: TSpeedButton
            Left = 6
            Top = 0
            Width = 153
            Height = 22
            Caption = 'Sauvegarder l'#39'exportation'
            OnClick = SaveAutomaticExport
          end
          object SpeedButtonCopyFromExstant: TSpeedButton
            Left = 176
            Top = 0
            Width = 163
            Height = 22
            Caption = 'Copier une importation existante'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = SpeedButtonCopyFromExstantClick
          end
        end
      end
      object Panel2: TPanel
        Left = 7
        Top = 208
        Width = 330
        Height = 305
        TabOrder = 2
        object Label1: TLabel
          Left = 1
          Top = 1
          Width = 328
          Height = 24
          Align = alTop
          Alignment = taCenter
          Caption = 'Job Exportation automatique'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -19
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object CheckListBox1: TCheckListBox
          Left = 1
          Top = 25
          Width = 328
          Height = 255
          Align = alClient
          ItemHeight = 13
          PopupMenu = PopupMenuExportSensors
          TabOrder = 0
        end
        object Panel3: TPanel
          Left = 1
          Top = 280
          Width = 328
          Height = 24
          Align = alBottom
          TabOrder = 1
          object SpeedButton2: TSpeedButton
            Left = 6
            Top = 0
            Width = 153
            Height = 22
            Caption = 'Sauvegarder l'#39'exportation'
            OnClick = SpeedButton2Click
          end
          object SpeedButton3: TSpeedButton
            Left = 176
            Top = 0
            Width = 163
            Height = 22
            Caption = 'Copier une importation existante'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            OnClick = SpeedButtonCopyFromExstantClick
          end
        end
      end
    end
    object TabSheetIniFile: TTabSheet
      Caption = 'Fichier de configuration'
      ImageIndex = 1
      object ValueListEditorTemp: TValueListEditor
        Left = 0
        Top = 0
        Width = 696
        Height = 509
        Align = alClient
        TabOrder = 0
        ColWidths = (
          150
          540)
      end
    end
  end
  object PopupMenuDomaines: TPopupMenu
    Left = 356
    Top = 152
    object AjouterlesdomainesdepuisHydras1: TMenuItem
      Caption = 'Ajouter les domaines depuis Hydras'
      OnClick = AjouterDomainesDepuisHydras
    end
    object AddDirectoryToDomain1: TMenuItem
      Caption = 'Ajouter un repertoire en tant que domaine'
      OnClick = AddDirectoryForDomain
    end
    object Supprimercedomaine1: TMenuItem
      Caption = 'Supprimer ce domaine'
      OnClick = SupprimerDomaine
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Crationdunnouveauschma1: TMenuItem
      Caption = 'Cr'#233'ation d'#39'un nouveau sch'#233'ma'
      OnClick = CreateNewSchema
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 388
    Top = 152
  end
  object PopupMenuExportSensors: TPopupMenu
    Left = 420
    Top = 152
    object outslctionner1: TMenuItem
      Tag = 1
      Caption = 'Tout s'#233'l'#233'ctionner'
      OnClick = CheckListPopUpMenu
    end
    object Rienslctionner1: TMenuItem
      Tag = 2
      Caption = 'Rien s'#233'l'#233'ctionner'
      OnClick = CheckListPopUpMenu
    end
    object Inversiondelaslction1: TMenuItem
      Tag = 3
      Caption = 'Inversion de la s'#233'l'#233'ction'
      OnClick = CheckListPopUpMenu
    end
  end
  object PopupMenuProcedures: TPopupMenu
    Left = 28
    Top = 544
    object Verifier1: TMenuItem
      Caption = 'Verifier'
      OnClick = Verifier1Click
    end
    object ReCrer1: TMenuItem
      Caption = 'ReCr'#233'er'
      OnClick = ReCrer1Click
    end
  end
end
