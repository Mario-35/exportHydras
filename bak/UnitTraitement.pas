unit UnitTraitement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ComCtrls, UnitVariables, strUtils,
  ExtCtrls, ZipForge, DBTables, Hydras;

type
  TFormTraitement = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure SearchFiles;
    function ZipFiles : Boolean;
    procedure Lancer(lst: TStrings; modeAuto: Boolean);
    procedure Stop(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);


    procedure FormShow(Sender: TObject);

  private
    one: boolean;
    compteur : Integer;
    tampon : Integer;
    schema : string;
    Domain : string;
    ligne : string;
    myFile : TextFile;
    scriptSql : TStringList;
    ZipListFiles : TStringList;
    procedure LogLine(Indent: Integer; AMessage: string);

    function  getDomainFromFileName(enTry: string): Boolean;
    function  getDomainFromFilePath(enTry: string): Boolean;
    function  getSchemaFromDomain(enTry: string): Boolean;
    function  importCsv(Filename: string; AUTO : Boolean) : Boolean;

    procedure sortir(Amessage: string);
  public
    procedure AddFiles(entry : Tstrings);
    procedure RefreshInfos(newState: TProcessType);

    { Public declarations }
  end;

var
  FormTraitement: TFormTraitement;

implementation

uses UnitConfiguration, UnitDataModuleDatas, UnitExport;

{$R *.dfm}

procedure TFormTraitement.LogLine(Indent: Integer; AMessage: string);
  Begin
      export.LogLine(Indent, AMessage)
  End;

procedure TFormTraitement.AddFiles(entry : Tstrings);
  var
    i : integer;

   Begin
      export.CheckListBoxLog.Items := entry;
      For i := 0 To export.CheckListBoxLog.Count - 1
        Do export.CheckListBoxLog.Checked[i] := true;
  End;

procedure TFormTraitement.SearchFiles;
  var
    i : integer;

   Begin
      export.CheckListBoxLog.items.Clear;
      FindFilePattern(export.CheckListBoxLog.items, FormConfiguration.DirectoryListBoxCsv.Directory, '.csv', True);
      For i := 0 To export.CheckListBoxLog.Count - 1
        Do export.CheckListBoxLog.Checked[i] := true;
      one := export.CheckListBoxLog.Count > 0;
      PROCESS := tpWait;
  End;

procedure TFormTraitement.FormCreate(Sender: TObject);
  Begin
    If FOLDER_MONITORING.IsActive
      Then FOLDER_MONITORING.Deactivate;
    RefreshInfos(tpNone);
    ZipListFiles := TStringList.Create;
  End;

procedure TFormTraitement.FormClose(Sender: TObject; var Action: TCloseAction);
    begin
      RefreshInfos(tpNone);
      export.ProgressBar.Visible := False;
      ZipListFiles.Free;
    end;

procedure TFormTraitement.RefreshInfos(newState: TProcessType);
  Procedure CacheTout;
    Begin
      export.BitBtnStop.Visible := False;
      export.BitBtnLancer.Visible := False;
    End;
  Begin
    PROCESS := newState;
    Case PROCESS of
        tpInit : Begin
          export.StatusBarMain.Panels[1].Text := 'Init';
          CacheTout;
          export.BitBtnStop.Visible := True;
          export.BitBtnStop.SetFocus;
        End;
         tpStart : Begin
          export.StatusBarMain.Panels[1].Text := 'Start';
          CacheTout;
          export.BitBtnStop.Visible := True;
          export.BitBtnStop.SetFocus;
        End;
        tpRun : Begin
          export.StatusBarMain.Panels[1].Text := 'Run';
          FormTraitement.caption := _PROCESS_ACTIVE;
          CacheTout;
          export.BitBtnStop.Visible := export.PageControlMain.ActivePage = export.TabSheetTraitement;
          If export.BitBtnStop.Visible Then export.BitBtnStop.SetFocus;
        End;
        tpWait : Begin
          export.StatusBarMain.Panels[1].Text := 'Wait';
          CacheTout;
          if one
            Then export.PageControlMain.ActivePage := export.TabSheetTraitement;
          export.BitBtnLancer.Visible := (export.PageControlMain.ActivePageIndex = 0) And one;
          If export.BitBtnLancer.Visible Then export.BitBtnLancer.SetFocus;
        End;
        tpPause : export.StatusBarMain.Panels[1].Text := 'Pause';
        tpStop : Begin
          export.StatusBarMain.Panels[1].Text := 'Stoppé';
          FormTraitement.caption := _PROCESS_STOP;
          CacheTout;
        End;
        tpError : export.StatusBarMain.Panels[1].Text := 'Erreur';
        tpDone : Begin
          export.StatusBarMain.Panels[1].Text := 'Fini';
          CacheTout;
        End;
    End;
    export.CheckListBoxLog.Visible := export.CheckListBoxLog.Count > 0;
    Application.ProcessMessages;




  End;


// ********************************************************************************************************************
// *                                               Domaines et Stations                                               *
// ********************************************************************************************************************

  { ========================================================= }
  {      Recherche le domaine a partir du nom de fichier      }
  { ========================================================= }

function  TFormTraitement.getDomainFromFileName(entry: string): Boolean;
  Var
    i : integer;

  Begin
    result := False;
    // Tout le test en majuscule pour supprimer les accents
    LogLine(1, format(_DOMAIN_SEARCH, [entry]));
    entry := UpperCase(entry);
    With FormConfiguration.ValueListEditorSchemas Do
      For i := 1 To RowCount -1
        Do begin
          If AnsiStartsStr(UpperCase(Cells[0,i]), entry) OR AnsiStartsStr(UpperCase(ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath((Cells[0,i]))))), entry) OR AnsiStartsStr(UpperCase(_HYDRAS_NAME_EXPORT + ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath((Cells[0,i]))))), entry)
          Then Begin
            domain := Cells[0,i];
            LogLine(2, format(_DOMAIN_SEARCH_TRUE, [domain]));
            Result :=True;
            Exit;
          End;
        End;
   LogLine(-2, format(_DOMAIN_SEARCH_FALSE, [entry]))
  End;

  function  TFormTraitement.getDomainFromFilePath(enTry: string): Boolean;
// Recherche le domaine a partir du chemin
  Var
    i,j : integer;
    StrTemp : TStringList;

  Begin
    result := False;
    // Tout le test en majuscule pour supprimer les accents
    LogLine(1, format(_DOMAIN_SEARCH, [entry]));
    StrTemp := TStringList.Create;
    Try
      StrTemp.Text := AnsiReplaceText(UpperCase(enTry), '\', #13+#10);
      For j := 0 To StrTemp.count -1 Do
        For i := 1 To FormConfiguration.ValueListEditorSchemas.RowCount -1 Do
          If AnsiStartsStr(UpperCase(FormConfiguration.ValueListEditorSchemas.Cells[0,i]), StrTemp[j])
          Then Begin
            domain := FormConfiguration.ValueListEditorSchemas.Cells[0,i];
            LogLine(2, format(_DOMAIN_SEARCH_TRUE, [domain]));
            Result :=True;
            Exit;
          End;
    Finally
      StrTemp.Free;
    End;
   LogLine(-2, format(_DOMAIN_SEARCH_FALSE, [entry]))
  End;

  function TFormTraitement.getSchemaFromDomain(enTry: string): Boolean;
    Begin
      result := False;
      LogLine(1, format(_SCHEMA_SEARCH, [entry]));
      If DataModuleDatas.IsSchemaExist(FormConfiguration.ValueListEditorSchemas.Values[enTry])
           Then Begin
            schema := FormConfiguration.ValueListEditorSchemas.Values[enTry];
            LogLine(2, format(_SCHEMA_SEARCH_TRUE, [schema]));
            Result := True;
            Exit;
          End;
    LogLine(-2, format(_SCHEMA_SEARCH_FALSE, [entry, FormConfiguration.ValueListEditorSchemas.Values[enTry]]))
  End;

// ********************************************************************************************************************
// *                                               Traitements ZIP                                                    *
// ********************************************************************************************************************


function TFormTraitement.ZipFiles : Boolean;
  Var
    archiver : TZipForge;
    i : Integer;

  Begin
    Result := False;
    If ZipListFiles.Count >= 0
      Then Begin
        archiver := TZipForge.Create(nil);
        Try
          With archiver
            Do Begin
              FileName := IncludeTrailingPathDelimiter(FOLDER_MONITORING.Folder) +  'import [' + AnsiReplaceText(AnsiReplaceText(AnsiReplaceText(DateTimeToStr(now), '/' , '-'), ':' , '-'), ' ' , '-')  + '].zip';
              LogLine(1, format(_ZIP_CREATE_ARCHIVE, [FileName]));
              OpenArchive(fmCreate);
              BaseDir := IncludeTrailingPathDelimiter(FOLDER_MONITORING.Folder);
              LogLine(1, Format(_ZIP_CREATE_BASEDIR, [BaseDir]));
              For i := 0 To ZipListFiles.Count - 1
                Do Begin
                  LogLine(2, format(_FILE_MOVE, [ZipListFiles[i]]));
                  MoveFiles(ZipListFiles[i]);
                  Result := True;
                End;
              CloseArchive();
              LogLine(1, _ZIP_CLOSE_ARCHIVE);
            End;
        Except
          On E: Exception
            Do Begin
              LogLine(2 , 'Exception: ' + E.Message);
              Result := False;
            End;
        End;
      End Else LogLine(-1, _ZIP_NO_FILE);
  End;

// ********************************************************************************************************************
// *                                                   Traitements                                                    *
// ********************************************************************************************************************

  procedure TFormTraitement.Stop(Sender: TObject);
    Begin
      If messagedlg('Annuler le traitement ',mtConfirmation , mbOKCancel, 0) = mrOk
        Then Begin
          caption := _PROCESS_STOP;
          LogLine(0, 'Arret de traitement');
          RefreshInfos(tpStop);
        End Else LogLine(0, 'Annulation do l''arret de traitement');
    End;

  procedure TFormTraitement.sortir(Amessage: string);
    Begin
      LogLine(1, _PROCESS_EXIT);
      RefreshInfos(tpSTop);
    End;

  procedure TFormTraitement.Lancer(lst: TStrings; modeAuto: Boolean);
    Var
      i : integer;
      Remember: Boolean;

    Begin
      Remember := FOLDER_MONITORING.IsActive;
      
      If FOLDER_MONITORING.IsActive
        Then FOLDER_MONITORING.Deactivate;

      RefreshInfos(tpStart);

      For i := 0 To lst.Count - 1
          Do If importCsv(lst[i], modeAuto)
              Then ZipListFiles.Add(lst[i]);

      ZipFiles;

      If Remember
        Then FOLDER_MONITORING.Activate;
    End;

  { ========================================================= }
  {    Importation d'un fichier CSV                           }
  { ========================================================= }


  function TFormTraitement.importCsv(Filename: string; AUTO : Boolean) : Boolean;
    Var
      i : integer;
      listAllStations, listAllCapteurs, listStations : TStringList;

    procedure GetStations;
      Var
        FTHydras : THydras;

      Begin
        FTHydras := THydras.Create;
        listStations := TStringList.Create;
        listAllStations := TStringList.Create;
        try
          FTHydras.getAllStations(IncludeTrailingPathDelimiter(domain), listAllStations);
        Finally
          FTHydras.Free;
        End;
      End;

      procedure UpdateStations(areaCode : string);
        var
          i : integer;
          localSql : TStringList;

        Begin
          localSql := TStringList.Create;
          Try
            localSql.Text := format('INSERT INTO %s.station (area_id, code, name) VALUES', [Schema]);
            For i := 0 To listStations.Count - 1
              Do localSql.Add(format('(%s, %s, %s),', [areaCode, QuotedStr(listStations.Names[i]), QuotedStr(listStations.ValueFromIndex[i])]));
            localSql[localSql.Count -1] := changeEndValues(localSql[localSql.Count -1], 'ON CONFLICT DO NOTHING;');
            If DataModuleDatas.isConnected And (PROCESS = tpRun)
              Then Begin
                If DEBUG
                  Then LogLine(0, localSql.Text);
                DataModuleDatas.connectionPostgres.ExecuteDirect(localSql.Text, i);
                LogLine(2, 'Ajout de ' + inttostr(i) + ' nouvelles stations');
              End;
          Finally
            localSql.Free;
          End;
        End;


    function GetSensors : string;
      Var
        FTHydras : THydras;
      Begin
        FTHydras := THydras.Create;
        listAllCapteurs := TStringList.Create;
        try
          FTHydras.getAllSensors(IncludeTrailingPathDelimiter(domain), listAllCapteurs);
        Finally
          FTHydras.Free;
        End;
      End;


      procedure UpdateSensors;
        var
          i : integer;
          localSql : TStringList;

        Begin
          localSql := TStringList.Create;
          Try
            localSql.Text := format('INSERT INTO %s.capteur (code, name) VALUES', [Schema]);
            For i := 0 To listAllCapteurs.Count - 1
              Do localSql.Add(format('(%s, %s),', [QuotedStr(listAllCapteurs.Names[i]), QuotedStr(listAllCapteurs.ValueFromIndex[i])]));
            localSql[localSql.Count -1] := changeEndValues(localSql[localSql.Count -1], 'ON CONFLICT DO NOTHING;');
            If DataModuleDatas.isConnected And (PROCESS = tpRun)
              Then Begin
                If DEBUG
                  Then LogLine(0, localSql.Text);
                DataModuleDatas.connectionPostgres.ExecuteDirect(localSql.Text, i);
                LogLine(2, 'Ajout de ' + inttostr(i) + ' nouveaux capteurs');
              End;
          Finally
            localSql.Free;
          End;
        End;

    function FormateToExport(entry: string): string;
      Begin
        export.ProgressBar.position := export.ProgressBar.Position + 1;
        result := '(''' + AnsiReplaceText(entry, ';', ''',''') + '''),';
      End;

    function verifieStation(entry: string): string;
      var
        cle : string;

      Begin
        cle := CleanName(Copy(entry, 0 , AnsiPos(';', entry) - 1));
        If listStations.IndexOfName(cle) = -1
          Then listStations.Values[cle] := listAllStations.Values[cle];
      End;

    procedure init;
      Begin
        LogLine(2, _POSTGRES_DATABASE_INIT_INSERT);
        compteur := 0;
        scriptSql.text := format('INSERT INTO %s.import (station, capteur, date_heure, valeur, info) VALUES', [schema]);
      End;

    procedure LaunchUpdate;
      Begin
          LogLine(2, _POSTGRES_DATABASE_EXEC_SQL);
          scriptSql[scriptSql.Count -1] := changeEndValues(scriptSql[scriptSql.Count -1], ';');
          DataModuleDatas.connectionPostgres.ExecuteDirect(scriptSql.Text);
          init;
      End;

    function GetAreaCode(entry : string) : string;
      Begin
        With DataModuleDatas
          Do Begin
            launchSql(format('select area_id FROM agrhys.area WHERE name = ''%s'';', [entry]));
            result :=  ReadOnlySql.FieldByname('area_id').AsString;
            If result = ''
              Then Begin
                connectionPostgres.ExecuteDirect(format('INSERT INTO %s.area (code, name) VALUES (1, ''%s'');', [Schema, entry]));
                launchSql(format('select area_id FROM agrhys.area WHERE name = ''%s'';', [entry]));
                result :=  ReadOnlySql.FieldByname('area_id').AsString;
              End;
          End;
        LogLine(2, Format('Get area code : %s', [result]));
      End;


    Begin
        result := False;
        RefreshInfos(tpInit);
        LogLine(0, format(_FILE_CSV_PROCESS, [Filename]));
        export.StatusBarMain.Panels[2].Text := format(_FILE_CSV_PROCESS, [Filename]);

        If AUTO
            Then LogLine(1, _PROCESS_MODE_AUTO)
            Else LogLine(1, _PROCESS_MODE_MANUEL);

        // addTask('Deconnection de tous les utilisateurs', False);

        If DataModuleDatas.isConnected
            Then LogLine(1, _POSTGRES_DATABASE_CONNECTED)
            Else sortir(_POSTGRES_DATABASE_NOT_CONNECTED);

        If PROCESS = tpStop Then exit;

        If FileExists(Filename)
            Then LogLine(1, format(_FILE_EXIST, [Filename]))
            Else sortir(format(_FILE_NOT_EXIST, [Filename]));

        If PROCESS = tpStop Then exit;

        If Not getDomainFromFileName(extractFileName(Filename))
          Then Begin
            If Not getDomainFromFilePath(extractFilePath(Filename))
              Then Sortir(_TEST_DOMAINS_NOT_FOUND_FILE);
          End;

        If PROCESS = tpStop Then exit;

        If Not getSchemaFromDomain(Domain)
          Then Sortir('Aucun schema pour ce domaine');
            
        If PROCESS = tpStop Then exit;

        If DataModuleDatas.isConnected
            Then LogLine(1, _POSTGRES_DATABASE_CONNECTED)
            Else sortir(_POSTGRES_DATABASE_NOT_CONNECTED);

        // FIN INIT

        If PROCESS = tpStop
            Then exit
            Else RefreshInfos(tpRun);

        export.ProgressBar.Visible := True;

        GetStations;

        GetSensors;

        UpdateSensors;

        If PROCESS = tpRun
            Then DataModuleDatas.connectionPostgres.ExecuteDirect(format('CREATE TABLE IF NOT EXISTS %s.import ( station text, capteur text, date_heure text, valeur text, info text);', [Schema]))
            Else exit;

        DataModuleDatas.connectionPostgres.StartTransaction;
        scriptSql := TStringList.Create;
        Try
            export.ProgressBar.Max := round(GetFileSize(Filename)  / 45);
            LogLine(1, _PROCESS_FILE_START);
            AssignFile(myFile, Filename);
            Reset(myFile);
            init;
            While Not Eof(myFile)
                Do Begin
                    ReadLn(myFile, ligne);
                    verifieStation(ligne);
                    scriptSql.Add(FormateToExport(ligne));
                    inc(compteur);
                    If (compteur = tampon) Then LaunchUpdate;
                End;
            LogLine(2, _PROCESS_FILE_END_OK);
            LaunchUpdate;
            CloseFile(myFile);
            export.ProgressBar.Position := export.ProgressBar.Max;

            If PROCESS = tpRun
                Then UpdateStations(GetAreaCode(extractFileName(ExcludeTrailingPathDelimiter(domain))));

            If (PROCESS = tpRun) AND DataModuleDatas.IsProcedureExist('_hydras_import')
                    Then If AUTO
                        Then DataModuleDatas.connectionPostgres.ExecuteDirect('SELECT * from public._hydras_import(''' + Schema + ''');')
                        Else DataModuleDatas.launchAndShowResultSql('SELECT * from public._hydras_import(''' + schema + ''');', 'Traitement du fichier csv : ' + Filename);
            
            If PROCESS = tpRun
                Then DataModuleDatas.connectionPostgres.Commit;

            If PROCESS = tpRun 
                Then RefreshInfos(tpDone);

            LogLine(1, _PROCESS_END_OK);
            Result := True;

        Finally
            scriptSql.Free;
            listAllStations.Free;
            listAllCapteurs.Free;
            listStations.Free;
        End;
    End;

procedure TFormTraitement.FormShow(Sender: TObject);
begin
  RefreshInfos(PROCESS);
end;

End.
