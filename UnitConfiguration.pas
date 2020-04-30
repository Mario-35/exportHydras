// ********************************************
// *  Unité configuration                     *
// *  @Inrae 2020                             *
// *  by mario Adam mario.adam@inrae.fr       *
// ********************************************

unit UnitConfiguration;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, ValEdit, ComCtrls, strUtils,
  Menus, Spin, Mask, Types, ZipForge, UnitVariables, CheckLst,
   DB, DBGrids, DBTables, FileCtrl, UnitHydras;

type
  TFormConfiguration = class(TForm)
    PanelBas: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    PageControlConfiguration: TPageControl;
    TabSheetconfiguration: TTabSheet;
    TabSheetIniFile: TTabSheet;
    PanelConnectionPostgres: TPanel;
    LabelPanelConnectionPostgres: TLabel;
    LabelHostname: TLabel;
    LabelPort: TLabel;
    LabelUser: TLabel;
    LabelPassword: TLabel;
    LabelDatabase: TLabel;
    EditHostname: TEdit;
    EditPort: TEdit;
    EditUser: TEdit;
    EditDatabase: TEdit;
    ButtonTestConnection: TButton;
    SpeedButtonGetDatabase: TSpeedButton;
    TabSheetImportCsv: TTabSheet;
    Panel1: TPanel;
    LabelParamImports: TLabel;
    LabelTampon: TLabel;
    SpinEditTampon: TSpinEdit;
    PanelClean: TPanel;
    LabelClean: TLabel;
    ValueListEditorCleanStation: TValueListEditor;
    CheckBoxLaurhAtStartup: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ckbFilenameChange: TCheckBox;
    ckbDirNameChange: TCheckBox;
    ckbAttrChange: TCheckBox;
    ckbSizeChange: TCheckBox;
    ckbWriteTimeChange: TCheckBox;
    ckbAccessTimeChange: TCheckBox;
    ckbCreationTimeChange: TCheckBox;
    ckbSecurityAttrChanges: TCheckBox;
    ckbMonitorSubfolders: TCheckBox;
    MaskEditPassword: TMaskEdit;
    CheckBoxlaunchMonitoringStartup: TCheckBox;
    PopupMenuDomaines: TPopupMenu;
    AjouterlesdomainesdepuisHydras1: TMenuItem;
    AddDirectoryToDomain1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Supprimercedomaine1: TMenuItem;
    N1: TMenuItem;
    Crationdunnouveauschma1: TMenuItem;
    ValueListEditorTemp: TValueListEditor;
    TabSheetHydras: TTabSheet;
    PanelSchemas: TPanel;
    LabelSchemas: TLabel;
    ValueListEditorSchemas: TValueListEditor;
    PanelHydras: TPanel;
    EditPanelHydras: TEdit;
    LabelPanelHydras: TLabel;
    PanelRX: TPanel;
    SpeedButtonPanelRX: TSpeedButton;
    EditPanelRX: TEdit;
    LabelRX: TLabel;
    PopupMenuExportSensors: TPopupMenu;
    outslctionner1: TMenuItem;
    Rienslctionner1: TMenuItem;
    Inversiondelaslction1: TMenuItem;
    PanelExportAuto: TPanel;
    LabelExportAuto: TLabel;
    CheckListBoxExportSensors: TCheckListBox;
    PanelExportAutoBas: TPanel;
    SpeedButtonSaveExport: TSpeedButton;
    PanelConnectionPostgresAdmin: TPanel;
    MaskEditAdminPassword: TMaskEdit;
    Label2: TLabel;
    LabelAdmin: TLabel;
    EditAdminUser: TEdit;
    ButtonTestConnectionAdwin: TButton;
    LabelPocedures: TLabel;
    CheckListBoxScripts: TCheckListBox;
    Label3: TLabel;
    PopupMenuProcedures: TPopupMenu;
    Verifier1: TMenuItem;
    ReCrer1: TMenuItem;
    SpeedButtonCopyFromExstant: TSpeedButton;
    CheckBoxLaunchImportAtStartup: TCheckBox;
    SpeedButtonPanelHydras: TSpeedButton;
    PanelCsv: TPanel;
    SpeedButton1: TSpeedButton;
    EditPanelCsv: TEdit;
    LabelCsv: TLabel;
    CheckBoxZipAfterImport: TCheckBox;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Label1: TLabel;
    CheckListBox1: TCheckListBox;
    Panel3: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Button1: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PageControlConfigurationChange(Sender: TObject);

// ********************************************************************************************************************
// *                                              Fichier de config et sauvegarde                                     *
// ********************************************************************************************************************
    procedure ReadConfig;
    procedure RefreshConfig;
    procedure SaveConfig(Sender: TObject);
    procedure CancelConfig(Sender: TObject);
    procedure AddToStartup;
    function  ExistInRegisTry(Nom, Valeur : String) : Boolean;

// ********************************************************************************************************************
// *                                              Editions  et fichiers                                               *
// ********************************************************************************************************************
    function  testColor(Test: Boolean): Tcolor;
    function  boolToString(Entry: boolean): string;
    procedure EditUpdate(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure SelectDirectory(FileNameStart: TEdit; myFilter : string);
    procedure UpdateValueList(Sender: TObject);
    procedure CheckListPopUpMenu(Sender: TObject);
    procedure SpeedButtonPanelHydrasClick(Sender: TObject);
    procedure SpeedButtonPanelRXClick(Sender: TObject);

// ********************************************************************************************************************
// *                                                       Hydras                                                     *
// ********************************************************************************************************************
    function  IsDomainExistInHydrasInstalled(Entry: string): boolean;
    function  getPathAppData: string;
    procedure LoadAutomaticExport(entry: String);
    procedure SaveAutomaticExport(Sender: TObject);
    procedure AjouterDomainesDepuisHydras(Sender: TObject);
    procedure SupprimerDomaine(Sender: TObject);
    procedure AddDirectoryForDomain(Sender: TObject);

// ********************************************************************************************************************
// *                                                      Postgres                                                    *
// ********************************************************************************************************************
    procedure CreateNewSchema(Sender: TObject);
    procedure GetListOfSchemas(Entry: TStringList);
    procedure TestPostgresConnection(Sender: TObject);
    procedure SelectPostgresDatabase(Sender: TObject);
    procedure SelectPostgresSchema(Sender: TObject);
    procedure ValueListEditorSchemasExit(Sender: TObject);
    procedure ValueListEditorSchemasSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);


// ********************************************************************************************************************
// *                                            Actions et traitements                                                *
// ********************************************************************************************************************

    procedure ButtonTestConnectionAdwinClick(Sender: TObject);
    procedure Verifier1Click(Sender: TObject);
    procedure ReCrer1Click(Sender: TObject);
    procedure SpeedButtonCopyFromExstantClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    procedure LogLine(Indent: Integer; AMessage: string);
    function readEnTry(Entry: string; DefaultValue: string): string; Overload;
    function readEnTry(Entry: string; DefaultValue: integer): integer; Overload;
  public
    { Public declarations }
  End;

Const
    wm_GetTraitement = WM_USER + 100;
    WM_ICONTRAY =  WM_USER + 1;

var
  FormConfiguration: TFormConfiguration;

implementation

uses UnitDataModuleDatas, UnitExport, UnitListSelect, RegisTry, IniFiles;

{$R *.dfm}


procedure TFormConfiguration.FormCreate(Sender: TObject);
  Begin
    PageControlConfiguration.ActivePageIndex := 0;
    ReadConfig;

    FormConfiguration.CheckBoxLaurhAtStartup.Checked := FormConfiguration.existInRegisTry(_CONFIG_REGISTRY_REGKEYNAME , application.exename);

    EditHostname.Text := CONFIG.Values['Hostname'];
    EditPort.Text := CONFIG.Values['Port'];
    EditUser.Text := CONFIG.Values['User'];
    MaskEditPassword.Text := CONFIG.Values['Password'];
    EditDatabase.Text := CONFIG.Values['Database'];

    If FileExists(CONFIG.Values['HydrasFolder'])
      Then EditPanelHydras.Text := CONFIG.Values['HydrasFolder']
      Else ExtractFilePath(Application.Exename);

    If FileExists(CONFIG.Values['HydrasRxFolder'])
      Then EditPanelRX.Text := CONFIG.Values['HydrasRxFolder']
      Else ExtractFilePath(Application.Exename);

    If FileExists(CONFIG.Values['CsvFolder'])
      Then EditPanelHydras.Text := CONFIG.Values['CsvFolder']
      Else ExtractFilePath(Application.Exename);

    ValueListEditorSchemas.Strings.Text := AnsiReplaceText(CONFIG.Values['domains'], ';', #13+#10);
    ValueListEditorCleanStation.Strings.Text := AnsiReplaceText(CONFIG.Values['cleanStation'], ';', #13+#10);

    DataModuleDatas.paramDatabase(DataModuleDatas.connectionPostgres, EditHostname.Text, EditPort.Text, EditUser.Text, MaskEditPassword.Text, EditDatabase.Text);

    DataModuleDatas.paramDatabase(DataModuleDatas.connectionAdmin, EditHostname.Text, EditPort.Text, EditAdminUser.Text, MaskEditAdminPassword.Text, EditDatabase.Text);

    RefreshConfig;



  End;

procedure TFormConfiguration.FormShow(Sender: TObject);
  Begin
    If FOLDER_MONITORING.IsActive
      Then FOLDER_MONITORING.Deactivate;
  End;

procedure TFormConfiguration.FormClose(Sender: TObject; var Action: TCloseAction);
  begin
    RefreshConfig;
  end;


procedure TFormConfiguration.FormResize(Sender: TObject);
  Begin
    BitBtnCancel.Left := PanelBas.Width -(BitBtnCancel.Width + 10);
    BitBtnOk.Left := BitBtnCancel.Left -(BitBtnOk.Width + 10);
  End;

procedure TFormConfiguration.PageControlConfigurationChange(Sender: TObject);
  Begin
    If PageControlConfiguration.ActivePage = TabSheetIniFile
      Then ValueListEditorTemp.Strings := CONFIG;
    If PageControlConfiguration.ActivePage = TabSheetHydras
      Then LoadAutomaticExport(_HYDRAS_NAME_EXPORT);
  End;

// ********************************************************************************************************************
// *                                              Fichier de config et sauvegarde                                     *
// ********************************************************************************************************************
  { ============================================= }
  {       Chargement de la configuration          }
  { ============================================= }

procedure TFormConfiguration.ReadConfig;
  Begin
    LogLine(0, _CONFIG_READ);

    readEnTry ('Hostname',  DataModuleDatas.connectionPostgres.HostName);
    readEnTry ('Port',      IntToStr(DataModuleDatas.connectionPostgres.Port));
    readEnTry ('User',      DataModuleDatas.connectionPostgres.User);
    readEnTry ('Password',  DataModuleDatas.connectionPostgres.Password);
    readEnTry ('Database',  DataModuleDatas.connectionPostgres.Database);
    readEnTry ('AdminUser',      DataModuleDatas.connectionAdmin.User);
    readEnTry ('AdminPassword',  DataModuleDatas.connectionAdmin.Password);

    if fileExists(_HYDRAS_FILE)
      Then readEnTry ('HydrasFolder', ExtractFilePath(_HYDRAS_FILE))
      Else readEnTry ('HydrasFolder', ExtractFilePath(Application.Exename));

    if fileExists(_HYDRASRX_FILE)
      Then readEnTry ('HydrasRxFolder', ExtractFilePath(_HYDRASRX_FILE))
      Else readEnTry ('HydrasRxFolder', ExtractFilePath(Application.Exename));

    readEnTry ('CsvFolder', 'C:\export');
    readEnTry ('AppDataFolder', getPathAppData);
    readEnTry ('csvBuffer', '50000');
    readEnTry ('cleanStation', '_B_=;_C_=;_V_=;');

    EditUpdate(EditHostname);
    EditUpdate(EditPort);
    EditUpdate(EditUser);
    EditUpdate(EditHostname);
    EditUpdate(MaskEditPassword);
    EditUpdate(EditDatabase);
    EditUpdate(EditAdminUser);
    EditUpdate(MaskEditAdminPassword);

    EditUpdate(SpinEditTampon);
    EditUpdate(CheckBoxLaurhAtStartup);
    EditUpdate(CheckBoxlaunchMonitoringStartup);
    EditUpdate(CheckBoxLaunchImportAtStartup);
    EditUpdate(CheckBoxZipAfterImport);


    EditUpdate(ckbFilenameChange);
    EditUpdate(ckbDirNameChange);
    EditUpdate(ckbAttrChange);
    EditUpdate(ckbSizeChange);
    EditUpdate(ckbWriteTimeChange);
    EditUpdate(ckbAccessTimeChange);
    EditUpdate(ckbCreationTimeChange);
    EditUpdate(ckbSecurityAttrChanges);
    EditUpdate(ckbMonitorSubfolders);

    EditUpdate(EditPanelHydras);
    EditUpdate(EditPanelRX);
    EditUpdate(EditPanelCsv);
  End;

  procedure TFormConfiguration.SaveConfig(Sender: TObject);
  Begin
    LogLine(0, _CONFIG_SAVE);
    CONFIG.SaveToFile(FILE_CONFIG);
  End;

  procedure TFormConfiguration.CancelConfig(Sender: TObject);
  Begin
    ReadConfig;
  End;

  procedure TFormConfiguration.AddToStartup;
  var
    Registre: TRegisTry;
    nomdelakey: string;
    programme:string;

  Begin
    // on définie le nom de la clé qui sera dans le registre
    nomdelakey := 'EXPORTHYDRAS';
    // on définie le chemin de destination du programme
    programme := applicaTion.exename;
    // on crée la clé dans la registre
    Registre := TRegisTry.Create;
    Registre.RootKey := HKEY_LOCAL_MACHINE;
    Registre.OpenKey(_CONFIG_REGISTRY_PATH, True);
    If CheckBoxLaurhAtStartup.Checked
      Then Registre.WriteString(nomdelakey,programme)
      Else Registre.DeleteValue(nomdelakey);
    Registre.CloseKey;
    Registre.Free;
  End;

  function TFormConfiguration.ExistInRegisTry(Nom, Valeur : String) : Boolean;
  var
    Reg: TRegisTry;

  Begin
    Result := False;
    If DEBUG
      Then LogLine(1, Format(_CONFIG_REGISTRY_TEST, [Nom, Valeur ]));
    Reg := TRegisTry.Create;
    With Reg
    Do Begin
      Try
        RootKey := HKEY_LOCAL_MACHINE;
        If OpenKey(_CONFIG_REGISTRY_PATH, True)
          Then Result := (ReadString(Nom) = Valeur)
          Else If DEBUG
            Then LogLine(-1, _CONFIG_REGISTRY_FOUND);
        CloseKey;
      Finally
        Free;
      End;
    End;
    If DEBUG
      Then LogLine(1, format(_Result, [boolToString(Result)]));
  End;

  { ==================================================== }
  {       Raffraichissement de la configuration          }
  { ==================================================== }

procedure TFormConfiguration.RefreshConfig;

  function  verifDir(Dir:  string): boolean;
    Begin
      Result := (directoryexists(Dir) AND (IncludeTrailingPathDelimiter(Dir) <> ExtractFilePath(Application.ExeName)))
    End;


  function  domainsHaveSchemas: boolean;
    Var
      j : integer;

    Begin
      Result := True;
      LogLine(1, _TEST_DOMAINS);
      For j := 1 To ValueListEditorSchemas.RowCount -1
      Do Begin
        TEMP_STRING := IncludeTrailingPathDelimiter(ValueListEditorSchemas.Cells[0,j]);
        If Not FileExists(TEMP_STRING + _HYDRAS_TABLE_ROOT)
        Then Begin
          LogLine(-2, format(_TEST_DOMAIN_ERR ,[TEMP_STRING]));
          Result := False;
        End Else LogLine(2, format(_TEST_DOMAIN_OK ,[TEMP_STRING]));
      End;
    End;


  Begin
    LogLine(0, _CONFIG_REFRESH);
    // Attention le sens el l'ordre des des tests est tres important
    POSTGRES_OK := DataModuleDatas.testDatabase(DataModuleDatas.connectionPostgres, EditHostname.Text, EditPort.Text, EditUser.Text, MaskEditPassword.Text, EditDatabase.Text);
    POSTGRES_ADMIN_OK := DataModuleDatas.testDatabase(DataModuleDatas.connectionAdmin, EditHostname.Text, EditPort.Text, EditAdminUser.Text, MaskEditAdminPassword.Text, EditDatabase.Text);
    HYDRAS_OK := verifDir(EditPanelHydras.Text);
    HYDRASRX_OK := verifDir(EditPanelRX.Text);
    CSVDIR_OK := verifDir(EditPanelRX.Text);

    PanelConnectionPostgres.Color := testColor(POSTGRES_OK);
    PanelConnectionPostgresAdmin.Color := testColor(POSTGRES_ADMIN_OK);

    PanelRX.Color := testColor(HYDRASRX_OK);
    PanelHydras.Color := testColor(HYDRAS_OK);
    PanelCsv.Color := testColor(CSVDIR_OK);
    SpeedButtonGetDatabase.Enabled := POSTGRES_OK;
    Crationdunnouveauschma1.Enabled := POSTGRES_ADMIN_OK;

    If CONFIG.Values['launchMonitoringStartup'] = 'True'
      Then export.RefreshStatus(tpMonitor);

    If POSTGRES_OK And DataModuleDatas.isConnected And domainsHaveSchemas
      Then PanelSchemas.Color := _OKCOLOR
      Else PanelSchemas.Color := _ERRCOLOR;

    CheckListBoxScripts.Items.Clear;

    If POSTGRES_OK
      Then DataModuleDatas.GetAllProcedure(CheckListBoxScripts.items);
  End;

// ********************************************************************************************************************
// *                                              Editions  et fichiers                                               *
// ********************************************************************************************************************


function  TFormConfiguration.testColor(Test: Boolean): Tcolor;
  Begin
      If Test
        Then Result := _OKCOLOR
        Else Result := _ERRCOLOR;
  End;

function TFormConfiguration.boolToString(Entry: boolean): string;
  Begin
    If Entry
      Then Result := 'True'
      Else Result := 'False';
  End;

  { ==================================================== }
  {       Fonction d'édition d'un composant              }
  { ==================================================== }


procedure TFormConfiguration.EditUpdate(Sender: TObject);
  var
    temp: string;

  Begin
      If DEBUG Then
        Logline(1, 'EditUpdate : ' + Sender.ClassName);

      If Sender.ClassName = 'TEdit'
        Then TEdit(Sender).Text := readEnTry(TEdit(Sender).Hint, TEdit(Sender).Text);

      If Sender.ClassName = 'TMaskEdit'
        Then TMaskEdit(Sender).Text := readEnTry(TMaskEdit(Sender).Hint, TMaskEdit(Sender).Text);

      If Sender.ClassName = 'TDirectoryListBox'
      Then Begin
        temp := readEnTry(TDirectoryListBox(Sender).Hint, TDirectoryListBox(Sender).Directory);
        If directoryexists(temp)
          Then TDirectoryListBox(Sender).Directory := temp
          Else TDirectoryListBox(Sender).Directory := ExtractFilePath(Application.Exename);
      End;

      If Sender.ClassName = 'TSpinEdit'
        Then TSpinEdit(Sender).Value := readEnTry(TSpinEdit(Sender).Hint, TSpinEdit(Sender).Value);

      If Sender.ClassName = 'TCheckBox'
        Then TCheckBox(Sender).Checked := (readEnTry(TCheckBox(Sender).Hint, 'True') = 'True');
  End;

  { ============================================================ }
  {      Lecture d'une entrée dans la configuration (string)     }
  { ============================================================ }

function TFormConfiguration.readEntry(entry: string; DefaultValue: string): string;
  Begin
    Result := CONFIG.Values[Entry];
    If Result = ''
      Then Result := DefaultValue;

    If DEBUG
      Then Begin
        logline(1, format(_READ_ENTRY, [Entry]));
        logline(2, format(_DEFAULT_VALUE, [DefaultValue]));
        logline(2, format(_Result, [Result]));
      End;
  End;

  { ============================================================ }
  {      Lecture d'une entrée dans la configuration (Integer)    }
  { ============================================================ }

function TFormConfiguration.readEnTry(Entry: string; DefaultValue: integer): integer;
  Var
    tmp : string;

  Begin
    tmp := CONFIG.Values[Entry];
    If tmp = ''
      Then Result := DefaultValue
      Else Result := StrToInt(Renvoi_Chiffre(tmp));

    If Result = 0
      Then Result := DefaultValue;
  End;

  { ========================================================== }
  {       Fonction de mise a jour a la sortie d'un composant   }
  { ========================================================== }

procedure TFormConfiguration.EditExit(Sender: TObject);
  function EncodePWDEx(Data, SecurityString: string; MinV: Integer = 0; MaxV: Integer = 5): string;
    Var
        i, x: integer;
        s1, s2, ss: string;

    function MakeRNDString(Chars: string; Count: Integer): string;
      Var
        i, x: integer;

      Begin
        Result := '';
        For i := 0 to Count - 1 Do
        Begin
            x := Length(chars) - Random(Length(chars));
            Result := Result + chars[x];
            chars := Copy(chars, 1,x - 1) + Copy(chars, x + 1,Length(chars));
        End;
      End;


    Begin
        If minV > MaxV Then
        Begin
            i := minv;
            minv := maxv;
            maxv := i;
        End;

        If MinV < 0 Then MinV := 0;
        If MaxV > 100 Then MaxV := 100;
        Result := '';
        If Length(SecurityString) < 16 Then
            Exit;
        For i := 1 To Length(SecurityString) Do
        Begin
            s1 := Copy(SecurityString, i + 1,Length(securitystring));
            If Pos(SecurityString[i], s1) > 0 Then
                Exit;
            If Pos(SecurityString[i], _CODE64) <= 0 Then
                Exit;
        End;
        s1 := _CODE64;
        s2 := '';
        For i := 1 to Length(SecurityString) Do
        Begin
            x := Pos(SecurityString[i], s1);
            If x > 0 Then
                s1 := Copy(s1, 1,x - 1) + Copy(s1, x + 1,Length(s1));
        End;
        ss := securitystring;
        For i := 1 To Length(Data) Do
        Begin
            s2 := s2 + ss[Ord(Data[i]) mod 16 + 1];
            ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
            s2 := s2 + ss[Ord(Data[i]) div 16 + 1];
            ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
        End;
        Result := MakeRNDString(s1, Random(MaxV - MinV) + minV + 1);
        For i := 1 To Length(s2) Do
            Result := Result + s2[i] + MakeRNDString(s1, Random(MaxV - MinV) + minV);
    End;

Begin
     If Sender.ClassName = 'TEdit' Then
      CONFIG.Values[TEdit(Sender).Hint] := TEdit(Sender).Text;

     If Sender.ClassName = 'TMaskEdit' Then
      CONFIG.Values[TMaskEdit(Sender).Hint] := EncodePWDEx(TMaskEdit(Sender).Text, 'np2kB508CGxXm/SV');

     If Sender.ClassName = 'TDirectoryListBox' Then
          CONFIG.Values[TDirectoryListBox(Sender).Hint] := TDirectoryListBox(Sender).Directory;

     if Sender.ClassName = 'TSpinEdit' Then
        CONFIG.Values[TEdit(Sender).Hint] := IntToStr(TSpinEdit(Sender).value);

     if Sender.ClassName = 'TCheckBox' Then
        CONFIG.Values[TCheckBox(Sender).Hint] := boolToString(TCheckBox(Sender).Checked);
End;

procedure TFormConfiguration.SelectDirectory(FileNameStart: TEdit; myFilter : string);
  Begin
    With OpenDialog1 Do
    Begin
        DefaultExt := ExtractFileExt(myFilter);
        Filename := myFilter;
        Filter := myFilter;
        InitialDir := FileNameStart.Text;
        Options := [ofReadOnly, OfPathMustExist, ofFileMustExist];
        If Execute Then
          FileNameStart.Text := includeTrailingPathDelimiter(ExtractFilePath(Filename));
    End;
  End;

procedure TFormConfiguration.UpdateValueList(Sender: TObject);
  Begin
    CONFIG.Values[TValueListEditor(Sender).Hint] := AnsiReplaceText(TValueListEditor(Sender).Strings.Text, #13+#10, ';');
  End;

procedure TFormConfiguration.CheckListPopUpMenu(Sender: TObject);
  var
    i : Integer;

  Begin
     for i := 0 To CheckListBoxExportSensors.Items.Count - 1
      Do Begin
        Case TMenuItem(sender).Tag  of
          1 : CheckListBoxExportSensors.Checked[i] := True;
          2 : CheckListBoxExportSensors.Checked[i] := False;
          3 : CheckListBoxExportSensors.Checked[i] := Not CheckListBoxExportSensors.Checked[i];
        End;
      End;
  End;

procedure TFormConfiguration.SpeedButtonPanelHydrasClick(Sender: TObject);
  Begin
    SelectDirectory(EditPanelHydras, ExtractFileName(_HYDRAS_FILE));
    RefreshConfig;
  End;

procedure TFormConfiguration.SpeedButtonPanelRXClick(Sender: TObject);
begin
    SelectDirectory(EditPanelRX, ExtractFileName(_HYDRASRX_FILE));
    RefreshConfig;
end;

// ********************************************************************************************************************
// *                                                       Hydras                                                     *
// ********************************************************************************************************************

  { ==================================================== }
  { Test si le domain existe dans hydras installé sur PC }
  { ==================================================== }

function  TFormConfiguration.IsDomainExistInHydrasInstalled(Entry: string): boolean;
  Var
    localTableRoot : TTable;

  Begin
    LogLine(1, _TEST_DOMAIN + ' : ' + Entry );
    Result := False;
    localTableRoot := TTable.Create(nil);
    Try
      If DataModuleDatas.ouvreTable(FormConfiguration.getPathAppData + _HYDRAS_TABLE_APPDATA_ROOT, localTableRoot)
      Then  Begin
        With localTableRoot
        Do Begin
          first;
          While Not Eof
          Do Begin
            If upperCase(fieldByName('WS_NAME').AsString) = upperCase(Entry)
              Then Result := True;
            Next;
          End;
        End;
      End Else LogLine(-2, _HYDRAS_TABLE_NOT_OPEN);
    Finally
        localTableRoot.Close;
        localTableRoot.Free;
        LogLine(1, format(_Result, [boolToString(Result)]));
        Screen.Cursor:=crdefault;
    End;
  End;

  { ==================================================== }
  { Renvoi le chemin dans AppDatas d'hydras              }
  { ==================================================== }

function TFormConfiguration.getPathAppData: string;
  Begin
    Result := SysUtils.GetEnvironmentVariable('APPDATA');
    if Result <> ''
      Then Result := IncludeTrailingPathDelimiter(extractFilePath(Result)) + 'Local\VirtualStore\Program Files (x86)\OTT\HYDRAS3\';
  End;

  { ========================================================= }
  { Charge l'exportation automatique ExportHydras si presente }
  { ========================================================= }

procedure TFormConfiguration.LoadAutomaticExport(entry: String);
var
  i : integer;
  Recherche, DomainePath : string;
  localTableRoot, localTableExport : TTable;
  FTHydras : THydras;

begin
  Screen.Cursor:=crHourGlass;
  CheckListBoxExportSensors.Items.Clear;

  localTableRoot := TTable.Create(nil);
  localTableExport := TTable.Create(nil);
  FTHydras := THydras.Create;
  try
    DomainePath := IncludeTrailingPathDelimiter(ValueListEditorSchemas.hint);
    If FTHydras.getAllStationsForAutomatic(DomainePath, CheckListBoxExportSensors.Items)
      Then If DataModuleDatas.ouvreTable(ValueListEditorSchemas.hint + _HYDRAS_TABLE_AUTOEXPO, localTableRoot) Then
    Begin
      If localTableRoot.Locate('NAME', entry, []) Then
      Begin
        PanelExportAuto.Color := _OKCOLOR;
        If DataModuleDatas.ouvreTable(ValueListEditorSchemas.hint + format('EXPO%s.DB', [localTableRoot.FieldByName('INDEX').AsString]), localTableExport) Then
          for i := 0 To CheckListBoxExportSensors.Items.Count -1 Do
            Begin
               Recherche := Trim(Copy(CheckListBoxExportSensors.Items[i], 0, AnsiPos(':', CheckListBoxExportSensors.Items[i]) - 1));
               CheckListBoxExportSensors.Checked[i] := localTableExport.Locate('SENSOR', Recherche,[]);
            End;
        End Else PanelExportAuto.Color := _ERRCOLOR;
    End
    Finally
        localTableExport.Close;
        localTableExport.Free;
        localTableRoot.Close;
        localTableRoot.Free;
        FTHydras.Free;
        Screen.Cursor:=crdefault;
    End;
end;


  { ============================================================================ }
  { Sauve l'exportation automatique ExportHydras en fonction de ce qui est coché }
  { ============================================================================ }

procedure TFormConfiguration.SaveAutomaticExport;
var
  i : integer;
  recherche, domainName : string;
  trouve : boolean;
  localTableRoot, localTableExport : TTable;

begin
  Screen.Cursor:=crHourGlass;
  LogLine(0 , 'Sauvegarde de l''exportation automatique');
  domainName := extractFileName(ExcludeTrailingPathDelimiter(ValueListEditorSchemas.hint));

  localTableRoot := TTable.Create(nil);
  localTableExport := TTable.Create(nil);
  try
    If DataModuleDatas.ouvreTable(ValueListEditorSchemas.hint + _HYDRAS_TABLE_AUTOEXPO, localTableRoot) Then
    Begin
      If localTableRoot.Locate('NAME', _HYDRAS_NAME_EXPORT, []) Then
      Begin
        If DataModuleDatas.ouvreTable(ValueListEditorSchemas.hint + format('EXPO%s.DB', [localTableRoot.FieldByName('INDEX').AsString]), localTableExport) Then
        Begin
            localTableExport.First;
            LogLine(1 , 'Effacement des données');
            While Not localTableExport.Eof Do
              localTableExport.Delete;
        End;
      End Else
      Begin
        i := 0;
        trouve := true;
        While trouve Do
        Begin
          inc(i);
          recherche := Format('%.3d', [i]);
          trouve := localTableRoot.locate('INDEX', recherche, []);
        End;
        with localTableExport do
        begin
          TableName := format(ValueListEditorSchemas.hint +'EXPO%s.DB', [recherche]);
          LogLine(1 , format('Nom du fichier %s', [TableName]));
          with FieldDefs do
          begin
            Clear;
            Add('SENSOR', ftString, 25, False);
            Add('REGION', ftString, 12, False);
            Add('PATH', ftString, 200, False);
            Add('FILENAME', ftString, 50, False);
            Add('EXPOTYPE', ftInteger);
            Add('VALTYPE', ftInteger);
            Add('SRCTYPE', ftInteger);
            Add('REPLACE', ftBoolean);
            Add('PARAMS', ftString, 80, False);
            Add('EXTRA', ftString, 20, False);
          End;
          CreateTable;
          Open;
          Active := True;
          LogLine(1 , 'Table crée');
        End;
        with localTableRoot do
        begin
          Insert;
          FieldByName('NAME').AsString := _HYDRAS_NAME_EXPORT ;
          FieldByName('INDEX').AsString := recherche ;
          Post;
        End;
      End;
      With localTableExport Do
      Begin
        For i := 0 To CheckListBoxExportSensors.Items.Count -1 Do
          If CheckListBoxExportSensors.Checked[i] Then
          Begin
            Insert;
            FieldByName('SENSOR').AsString := Trim(Copy(CheckListBoxExportSensors.Items[i], 0, AnsiPos(':', CheckListBoxExportSensors.Items[i]) - 1));
            FieldByName('REGION').AsString := '999999999999';
            FieldByName('PATH').AsString := IncludeTrailingPathDelimiter(CONFIG.Values['CsvFolder']);
            FieldByName('FILENAME').AsString := format('%s%s.csv', [_HYDRAS_NAME_EXPORT, domainName]) ;
            FieldByName('EXPOTYPE').AsInteger := 0;
            FieldByName('VALTYPE').AsInteger := 0;
            FieldByName('SRCTYPE').AsInteger := 0;
            FieldByName('REPLACE').AsBoolean := False;
            FieldByName('PARAMS').AsString := 'FTTTTFTF; 00FFTFFFFFFFFFF    FS';
            FieldByName('EXTRA').AsString := '';
            Post;
          End;
        LogLine(1 , 'Sauvegarde Ok');
      End;
    End;
    Finally
        localTableExport.Close;
        localTableExport.Free;
        localTableRoot.Close;
        localTableRoot.Free;
        Screen.Cursor:=crdefault;
    End;
End;

  { ==================================================== }
  { Ajoute les domaines trouvé dans l'application hydras }
  { ==================================================== }

procedure TFormConfiguration.AjouterDomainesDepuisHydras(Sender: TObject);
  var
    Temp : integer;
    TempStr : string;
    localTableRoot : TTable;

  begin
    Screen.Cursor := crHourGlass;
    localTableRoot := TTable.Create(nil);
    Try
      DataModuleDatas.ouvreTable(FormConfiguration.getPathAppData + _HYDRAS_TABLE_APPDATA_ROOT, localTableRoot);
      With localTableRoot Do
      Begin
        first;
        Next;
        While Not Eof Do
        Begin
          TempStr := fieldByName('WS_PATH').AsString;
          If Not ValueListEditorSchemas.FindRow(TempStr, Temp)
            Then ValueListEditorSchemas.InsertRow(TempStr, _POSTGRES_DATABASE_NO_SCHEMA, true);
          Next;
        End;
        first;
      End;
    Finally
        localTableRoot.Close;
        localTableRoot.Free;
        Screen.Cursor:=crdefault;
    End;
  End;


procedure TFormConfiguration.SupprimerDomaine(Sender: TObject);
  var
    Temp : Integer;

  Begin
    If messagedlg('Effacer les informations pour' +#13+#10 + ValueListEditorSchemas.hint ,mtConfirmation  , [mbYes, mbCancel] , 0) = mrYes
      Then If ValueListEditorSchemas.FindRow(ValueListEditorSchemas.hint, Temp)
          Then ValueListEditorSchemas.DeleteRow(Temp);
    RefreshConfig;
  End;

  { ==================================================== }
  { Ajoute un répértoire en tant que domaine             }
  { ==================================================== }

  procedure TFormConfiguration.AddDirectoryForDomain(Sender: TObject);
  var
    TempStr: string;
    Temp : Integer;

  Begin
    With OpenDialog1
    Do Begin
        DefaultExt := 'DB';
        Filename := _HYDRAS_TABLE_ROOT;
        Filter := _HYDRAS_TABLE_ROOT;
        Options := [ofReadOnly, OfPathMustExist, ofFileMustExist];

        If Execute
        Then Begin
          TempStr := ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(Filename)));
          If ValueListEditorSchemas.FindRow(TempStr, Temp)
            Then ShowMessage('Doublon')
            Else ValueListEditorSchemas.InsertRow(TempStr, _POSTGRES_DATABASE_NO_SCHEMA, true);
        End;
    End;
  End;

// ********************************************************************************************************************
// *                                                      Postgres                                                    *
// ********************************************************************************************************************

  { ============================================================== }
  { Création d'un nouweau domaine en oppelant la procedure stockée }
  { ============================================================== }

procedure TFormConfiguration.CreateNewSchema(Sender: TObject);
  var
    value : string;

  Begin
    If DataModuleDatas.isAdminConnected
      Then Begin
        If DataModuleDatas.IsSchemaExist(ValueListEditorSchemas.Cells[1, ValueListEditorSchemas.Tag])
          Then value := ''
          Else value := ValueListEditorSchemas.Cells[1, ValueListEditorSchemas.Tag];

        value := inputbox('Nouveau schéma', 'Entrez le nom du schéma', value);
        If value <> ''
          Then With DataModuleDatas.connectionAdmin
            Do Begin
              Try
                If DataModuleDatas.IsProcedureExist('_hydras_create_schema')
                  Then ExecuteDirect(format('SELECT * from public._hydras_create_schema(''%s'', ''%s'');', [value, DataModuleDatas.connectionPostgres.User]));
              Except
                On E: Exception Do
                LogLine(2 , 'Exception : ' + E.Message);
              End;
              Disconnect;
            End;
      End;
      RefreshConfig;
  End;

  { ============================================================== }
  { Création d'un nouweau domaine en oppelant la procedure stockée }
  { ============================================================== }

procedure TFormConfiguration.GetListOfSchemas(entry: TStringList);
  var
    i : integer;

  Begin
    If DataModuleDatas.isConnected
      Then Begin
        DataModuleDatas.connectionPostgres.GetSchemaNames(entry);
        For i := entry.Count - 1 DownTo 0
          Do If (enTry[i] = 'information_schema') OR AnsiStartsStr('pg_', enTry[i])
            Then enTry.Delete(i);
      End Else LogLine(1, _POSTGRES_DATABASE_NOT_CONNECTED);
  End;


procedure TFormConfiguration.TestPostgresConnection(Sender: TObject);
  Begin
    If DataModuleDatas.testDatabase(DataModuleDatas.connectionPostgres , EditHostname.Text, EditPort.Text, EditUser.Text, MaskEditPassword.Text, EditDatabase.Text)
      Then messagedlg(_POSTGRES_CONNECTION_OK, mtInformation , [mbOK] , 0)
      Else messagedlg(_POSTGRES_CONNECTION_ERROR, mtError  , [mbOK] , 0);
      RefreshConfig;
  End;


procedure TFormConfiguration.SelectPostgresDatabase(Sender: TObject);
  var
      StrTemp : TStringList;

  Begin
    If DataModuleDatas.isConnected
      Then Begin
        StrTemp := TStringList.Create;
        Application.CreateForm(TFormListSelect, FormListSelect);
        FormListSelect.Caption := _POSTGRES_DATABASE_CHOICE;
        Try
          DataModuleDatas.connectionPostgres.GetCatalogNames(StrTemp);
          FormListSelect.ListBoxItems.Items := StrTemp;
          if FormListSelect.ShowModal = mrOk
            Then EditDatabase.Text := FormListSelect.ListBoxItems.Items[FormListSelect.ListBoxItems.itemIndex];
        Finally
          FormListSelect.Free;
          StrTemp.Free;
        End;
    End Else LogLine(1, _POSTGRES_DATABASE_NOT_CONNECTED);
    RefreshConfig;
  End;

procedure TFormConfiguration.ValueListEditorSchemasExit(Sender: TObject);
  Begin
      CONFIG.Values['domains'] := AnsiReplaceText(ValueListEditorSchemas.Strings.Text, #13+#10, ';');
  End;

procedure TFormConfiguration.ValueListEditorSchemasSelectCell( Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  Begin
      ValueListEditorSchemas.hint := ValueListEditorSchemas.Cells[0, ARow];
      ValueListEditorSchemas.Tag := ARow;
      If PageControlConfiguration.ActivePage = TabSheetHydras
        Then LoadAutomaticExport(_HYDRAS_NAME_EXPORT);;
  End;


procedure TFormConfiguration.SelectPostgresSchema(Sender: TObject);
  var
      StrTemp : TStringList;

  Begin
    If POSTGRES_OK AND DataModuleDatas.isConnected
      Then Begin
        StrTemp := TStringList.Create;
        Application.CreateForm(TFormListSelect, FormListSelect);
        FormListSelect.Caption := _POSTGRES_DATABASE_SCHEMA;
        Try
          GetListOfSchemas(StrTemp);
          FormListSelect.ListBoxItems.Items := StrTemp;
          If FormListSelect.ShowModal = mrOk
            Then If FormListSelect.ListBoxItems.itemIndex >= 0
              Then ValueListEditorSchemas.Values[ValueListEditorSchemas.hint] := FormListSelect.ListBoxItems.Items[FormListSelect.ListBoxItems.itemIndex];
        Finally
          FormListSelect.Free;
          StrTemp.Free;
          RefreshConfig;
        End;
      End Else LogLine(1, _POSTGRES_DATABASE_NOT_CONNECTED);
  End;

procedure TFormConfiguration.LogLine(Indent: Integer; AMessage: string);
    Begin
        Export.LogLine(Indent, AMessage);
    End;

// ********************************************************************************************************************
// *                                            Actions et traitements                                                *
// ********************************************************************************************************************

procedure TFormConfiguration.ButtonTestConnectionAdwinClick(Sender: TObject);
begin
    If DataModuleDatas.testDatabase(DataModuleDatas.connectionAdmin, EditHostname.Text, EditPort.Text, EditAdminUser.Text, MaskEditAdminPassword.Text, EditDatabase.Text)
      Then messagedlg(_POSTGRES_CONNECTION_OK, mtInformation , [mbOK] , 0)
      Else messagedlg(_POSTGRES_CONNECTION_ERROR, mtError  , [mbOK] , 0);
      RefreshConfig;
end;

procedure TFormConfiguration.Verifier1Click(Sender: TObject);
  var
    i : integer;
    script : string;

begin
  LogLine(0, 'Verification existance des scripts');
  LIST_FILES2.Clear;
  FindFilePattern(LIST_FILES2, FILE_SQL, '.sql', False);

  CheckListBoxScripts.items.Clear;

  If DataModuleDatas.isAdminConnected
    Then Begin
      LogLine(0, 'Liste des procedures ');
      DataModuleDatas.connectionAdmin.GetStoredProcNames('_hydras%',CheckListBoxScripts.items);
      application.ProcessMessages;
      For i := 0 To LIST_FILES2.Count -1
        Do Begin
          script := Trim(lowerCase(AnsiReplaceText(extractFileName(LIST_FILES2[i]), extractFileExt(LIST_FILES2[i]),'')));
          If CheckListBoxScripts.Items.IndexOf(script) = -1
            Then Begin
              TEMP_LIST.LoadFromFile(LIST_FILES2[i]);
              LogLine(1, format('Creation du script %s dans : %s', [script, LIST_FILES2[i]]));
              DataModuleDatas.connectionAdmin.ExecuteDirect(TEMP_LIST.Text);
            End;
        End;
      DataModuleDatas.connectionAdmin.ReConnect;
    End;
end;

procedure TFormConfiguration.ReCrer1Click(Sender: TObject);
  var
    i : integer;

begin
LIST_FILES2.Clear;
  FindFilePattern(LIST_FILES2, FILE_SQL, '.sql', False);
  LogLine(0, 'Re-création des procedures');
  If DataModuleDatas.isAdminConnected
    Then For i := 0 To LIST_FILES2.Count -1
        Do Begin
          TEMP_LIST.LoadFromFile(LIST_FILES2[i]);
           LogLine(1, format('Creation du script de : %s', [LIST_FILES2[i]]));
           DataModuleDatas.connectionAdmin.ExecuteDirect(TEMP_LIST.Text);
        End;
end;

procedure TFormConfiguration.SpeedButtonCopyFromExstantClick(Sender: TObject);
var
  DomainePath : string;
  localTableRoot : TTable;

begin
  localTableRoot := TTable.Create(nil);
  try
    DomainePath := IncludeTrailingPathDelimiter(ValueListEditorSchemas.hint);
    If DataModuleDatas.ouvreTable(ValueListEditorSchemas.hint + _HYDRAS_TABLE_AUTOEXPO, localTableRoot) Then
    Begin
      Application.CreateForm(TFormListSelect, FormListSelect);
      FormListSelect.Caption := _HYDRAS_SELECT_AUTOEXPORT;
      While Not localTableRoot.Eof
        Do Begin
          FormListSelect.ListBoxItems.Items.Add(localTableRoot.FieldByName('NAME').AsString);
          localTableRoot.Next;
        End;
      If FormListSelect.ShowModal = mrOk
        Then If FormListSelect.ListBoxItems.itemIndex >= 0
          Then LoadAutomaticExport(FormListSelect.ListBoxItems.Items[FormListSelect.ListBoxItems.itemIndex]);
    End
    Finally
        localTableRoot.Free;
        FormListSelect.Free;
        RefreshConfig;
    End;
end;
procedure TFormConfiguration.SpeedButton1Click(Sender: TObject);
begin
    SelectDirectory(EditPanelCsv, ExtractFileName(CONFIG.Values['CsvFolder']));
    RefreshConfig;
end;

procedure TFormConfiguration.SpeedButton2Click(Sender: TObject);
    Var
        fichier : string;
        localTableRoot : TTable;

    Begin
      localTableRoot := TTable.Create(nil);
      Try
        LogLine(0, 'Lecture des jobs pour : ');
        If DataModuleDatas.ouvreTable(PATH_APPDATAS_HYDRAS + 'EXP_JOBS.DB', localTableRoot) Then
        Begin
          localTableRoot.first;
          while Not localTableRoot.Eof
            Do Begin
              CheckListBox1.Items.Add(localTableRoot.FieldByName('JOBNAME').AsString);
              localTableRoot.next;
            End;
        End Else LogLine(1, 'Table Non Trouv');
      Finally
        localTableRoot.Free;
      End;
    End;

End.


