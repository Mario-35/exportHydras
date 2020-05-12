unit UnitPostGres;

interface
  uses
    Classes, SysUtils, Forms,  strUtils, DBTables, UnitVariables, ZipForge, UnitHydras;

 type
  TPostGres=class
    private
      schema : string;
      Domain : string;
      procedure LogLine(Indent: Integer; AMessage: string);
      function  ZipFiles(lst: TStrings) : Boolean;
      function  getDomainFromFileName(enTry: string): Boolean;
      function  getDomainFromFilePath(enTry: string): Boolean;
      function  getSchemaFromDomain(enTry: string): Boolean;
      function  importCsv(Filename: string) : Boolean;
      procedure sortir(Amessage: string);

    public
      procedure Lancer;
      procedure RefreshInfos(newState: TProcessType);

    published
      constructor Create;
      Destructor  Destroy; override;

  end;

implementation

uses UnitConfiguration, UnitExport, UnitDataModuleDatas ;

procedure TPostGres.LogLine(Indent: Integer; AMessage: string);
  Begin
      export.LogLine(Indent, AMessage)
  End;

constructor TPostGres.Create;
  Begin
    Inherited;
    RefreshInfos(tpNone);
  End;

destructor TPostGres.Destroy;
    begin
      RefreshInfos(tpNone);
      inherited;
    end;

procedure TPostGres.RefreshInfos(newState: TProcessType);
  Begin
     export.RefreshStatus(newState);
  End;


// ********************************************************************************************************************
// *                                               Domaines et Stations                                               *
// ********************************************************************************************************************

  { ========================================================= }
  {      Recherche le domaine a partir du nom de fichier      }
  { ========================================================= }

function  TPostGres.getDomainFromFileName(entry: string): Boolean;
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

  function  TPostGres.getDomainFromFilePath(enTry: string): Boolean;
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

  function TPostGres.getSchemaFromDomain(enTry: string): Boolean;
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


function TPostGres.ZipFiles(lst: TStrings) : Boolean;
  Var
    archiver : TZipForge;
    i : Integer;

  Begin
    Result := False;
    If lst.Count >= 0
      Then Begin
        RefreshInfos(tpZip);
        archiver := TZipForge.Create(nil);
        Try
          With archiver
            Do Begin
              FileName := IncludeTrailingPathDelimiter(FOLDER_MONITORING.Folder) +  'import [' + AnsiReplaceText(AnsiReplaceText(AnsiReplaceText(DateTimeToStr(now), '/' , '-'), ':' , '-'), ' ' , '-')  + '].zip';
              LogLine(1, format(_ZIP_CREATE_ARCHIVE, [FileName]));
              OpenArchive(fmCreate);
              BaseDir := IncludeTrailingPathDelimiter(FOLDER_MONITORING.Folder);
              LogLine(1, Format(_ZIP_CREATE_BASEDIR, [BaseDir]));
              For i := 0 To lst.Count - 1
                Do Begin
                  LogLine(2, format(_FILE_MOVE, [lst[i]]));
                  MoveFiles(lst[i]);
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


  procedure TPostGres.sortir(Amessage: string);
    Begin
      LogLine(1, _PROCESS_EXIT);
      RefreshInfos(tpSTop);
    End;

  procedure TPostGres.Lancer;
    Var
       ZipListFiles : TStringList;

    Begin
      ZipListFiles := TStringList.Create;
      Try
        RefreshInfos(tpStart);
        While export.ListBoxFilesQueue.Items.Count > 0
          Do Begin
            If PROCESS <> tpStop
              Then If importCsv(export.ListBoxFilesQueue.Items[0])
                Then Begin
                  ZipListFiles.Add(export.ListBoxFilesQueue.Items[0]);
                  export.ListBoxFilesQueue.Items.Delete(0);
                  export.UpdateQueueFiles;
                End;
          End;
      Finally
        If (PROCESS <> tpStop) AND (CONFIG.Values['ZipAfterImport'] = 'True')
          Then ZipFiles(ZipListFiles);
        ZipListFiles.Free;
        RefreshInfos(tpDone);
      End;
    End;

  { ========================================================= }
  {    Importation d'un fichier CSV                           }
  { ========================================================= }


  function TPostGres.importCsv(Filename: string) : Boolean;
    Var
      compteur, compteurMax : integer;
      ligne : string;
      listAllStations, listAllCapteurs, listStations, scriptSql : TStringList;
      myFile : TextFile;

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
          localSql, mySplit : TStringList;

        Begin
          localSql := TStringList.Create;
          mySplit := TStringList.Create;
          Try
            localSql.Text := format('INSERT INTO %s.sensor (code, name, unite) VALUES', [Schema]);
            For i := 0 To listAllCapteurs.Count - 1
              Do begin
                mySplit.Text := AnsiReplaceText(listAllCapteurs.ValueFromIndex[i]+' ','|',#13#10);
                localSql.Add(format('(%s, %s, %s),', [QuotedStr(listAllCapteurs.Names[i]), QuotedStr(mySplit[0]), QuotedStr(trim(mySplit[1]))]));
              End;
            localSql[localSql.Count -1] := changeEndValues(localSql[localSql.Count -1], 'ON CONFLICT DO NOTHING;');
            If DataModuleDatas.isConnected And (PROCESS = tpRun)
              Then Begin
                If DEBUG
                  Then LogLine(0, localSql.Text);
                DataModuleDatas.connectionPostgres.ExecuteDirect(localSql.Text, i);
                LogLine(2, 'Ajout de ' + inttostr(i) + ' nouveaux sensors');
              End;
          Finally
            localSql.Free;
            mySplit.Free;
          End;
        End;

    function FormateToExport(entry: string): string;
      Begin
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
        scriptSql.text := 'INSERT INTO import (station, sensor, date_heure, valeur, info) VALUES';
      End;

    procedure LaunchUpdate;
      Begin
          If PROCESS <> tpRun
            Then exit;
          LogLine(2, _POSTGRES_DATABASE_EXEC_SQL);
          scriptSql[scriptSql.Count -1] := changeEndValues(scriptSql[scriptSql.Count -1], ';');
          DataModuleDatas.connectionPostgres.ExecuteDirect(scriptSql.Text);
          init;
      End;

    function GetAreaCode(entry : string) : string;
      Begin
        With DataModuleDatas
          Do Begin
            launchSql(format('select id FROM %s.area WHERE name = %s;', [schema, quotedStr(entry)]));
            result :=  ReadOnlySql.FieldByname('id').AsString;
            If result = ''
              Then Begin
                connectionPostgres.ExecuteDirect(format('INSERT INTO %s.area (code, name) VALUES (1, %s);', [Schema, quotedStr(entry)]));
                launchSql(format('select id FROM %s.area WHERE name = %s;', [schema, quotedStr(entry)]));
                result :=  ReadOnlySql.FieldByname('id').AsString;
              End;
          End;
        LogLine(2, Format('Get area code : %s', [result]));
      End;


    Begin
        result := False;
        RefreshInfos(tpInit);
        LogLine(0, format(_FILE_CSV_PROCESS, [Filename]));
        export.StatusBarMain.Panels[2].Text := format(_FILE_CSV_PROCESS, [Filename]);



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
        ligne := CONFIG.Values['csvBuffer'];
        If ligne = ''
          Then compteurMax := 50000
          Else compteurMax := StrToInt(Renvoi_Chiffre(ligne));


        If PROCESS = tpStop
            Then exit
            Else RefreshInfos(tpRun);

        GetStations;

        GetSensors;

        UpdateSensors;

        If PROCESS = tpRun
            Then DataModuleDatas.connectionPostgres.ExecuteDirect(format('SELECT public."_hydras_create_table"(%s, %s);', [quotedStr('import'), quotedStr(CONFIG.Values['User'])]))
            Else exit;


        DataModuleDatas.connectionPostgres.StartTransaction;
        scriptSql := TStringList.Create;
        Try
            LogLine(1, _PROCESS_FILE_START);
            AssignFile(myFile, Filename);
            Reset(myFile);
            init;
            Try
              While Not Eof(myFile) And (PROCESS = tpRun)
                Do Begin
                    ReadLn(myFile, ligne);
                    verifieStation(ligne);
                    scriptSql.Add(FormateToExport(ligne));
                    inc(compteur);
                    If (compteur = compteurMax) Then LaunchUpdate;
                End;
              LogLine(2, _PROCESS_FILE_END_OK);
              LaunchUpdate;
            Finally
              CloseFile(myFile);
            End;

            If PROCESS = tpRun
                Then UpdateStations(GetAreaCode(extractFileName(ExcludeTrailingPathDelimiter(domain))));

            If (PROCESS = tpRun) AND DataModuleDatas.IsProcedureExist('_hydras_import')
                    Then DataModuleDatas.connectionPostgres.ExecuteDirect(format('SELECT * from public._hydras_import(%s);', [QuotedStr(Schema)]));
   //                     Else DataModuleDatas.launchAndShowResultSql('SELECT * from public._hydras_import(''' + schema + ''');', 'Traitement du fichier csv : ' + Filename);
            
            If PROCESS = tpRun
                Then DataModuleDatas.connectionPostgres.Commit
                Else DataModuleDatas.connectionPostgres.Rollback;

            If PROCESS = tpRun
                Then Begin
                  LogLine(1, _PROCESS_END_OK);
                  RefreshInfos(tpDone);
                  Result := True;
                End Else Begin
                    RefreshInfos(tpStop);
                    Result := False;
                End;

        Finally
            scriptSql.Free;
            listAllStations.Free;
            listAllCapteurs.Free;
            listStations.Free;
        End;
    End;


End.
