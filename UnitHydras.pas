unit UnitHydras;

interface
  uses
    Classes, SysUtils, Forms,  strUtils, DBTables;

 type
  THydras=class
    private
      procedure LogLine(Indent: Integer; AMessage: string);
    public
      function getAllStations(domaine: string; StationsList: TStrings): boolean;
      function getAllSensors(domaine: string; SensorList: TStrings): boolean;
      function getAllStationsForAutomatic(domaine: string; StationsList: TStrings): boolean;
      function getAllJobs(StationsList: TStrings): boolean;

  end;



implementation

uses UnitConfiguration, UnitExport, UnitDataModuleDatas, UnitVariables;



procedure THydras.LogLine(Indent: Integer; AMessage: string);
  Begin
      export.LogLine(Indent, AMessage)
  End;

function THydras.getAllStations(domaine: string; StationsList: TStrings): boolean;
    Var
        fichier : string;
        localTableRoot : TTable;

    Begin
      Result := False;
      localTableRoot := TTable.Create(nil);
      Try
        LogLine(0, 'Lecture des stations pour : ' + domaine);
        fichier := includeTrailingPathDelimiter(domaine) + _HYDRAS_TABLE_STATIONS;
        If DataModuleDatas.ouvreTable(fichier, localTableRoot) Then
        Begin
          localTableRoot.first;
          while Not localTableRoot.Eof
            Do Begin
              StationsList.Values[CleanName(localTableRoot.FieldByName('NR').AsString)] := CleanName(localTableRoot.FieldByName('NAME').AsString);
              localTableRoot.next;
            End;
        End Else LogLine(1, _POSTGRES_DATABASE_NOT_CONNECTED);
      Finally
        localTableRoot.Free;
      End;
      Result := True;
    End;

function THydras.getAllSensors(domaine: string; SensorList: TStrings): boolean;
    Var
        fichier, ligne, unite : string;
        localTableRoot, localTableStations, localTableCapteurs : TTable;

    Begin
      Result := False;
      LogLine(0, 'Lecture des capteurs pour : ' + domaine);
      localTableRoot := TTable.Create(nil);
      localTableStations := TTable.Create(nil);
      localTableCapteurs := TTable.Create(nil);
      Try
        fichier := includeTrailingPathDelimiter(domaine) + _HYDRAS_TABLE_ROOT;
        If DataModuleDatas.ouvreTable(fichier, localTableRoot) Then
        Begin
          localTableRoot.first;
          while Not localTableRoot.Eof Do
          Begin
            If Not localTableRoot.Fields[2].IsNull Then
            Begin
              fichier :=  includeTrailingPathDelimiter(domaine) + localTableRoot.FieldValues['GB_MDATEI'] + '.DB';
              DataModuleDatas.ouvreTable(fichier, localTableStations);
              While Not localTableStations.Eof
                Do Begin
                  fichier := localTableStations.FieldByName('GBM_MSNR').AsString;
                  insert('.', fichier, 9);
                  Ligne := fichier;
                  fichier := includeTrailingPathDelimiter(domaine) + includeTrailingPathDelimiter(fichier) + _HYDRAS_TABLE_SENSOR;
                  If DataModuleDatas.ouvreTable(fichier, localTableCapteurs)
                    Then Begin
                      While Not localTableCapteurs.Eof
                        Do Begin
                          //SensorList.add(format('%s/%s : %s', [localTableStations.FieldByName('GBM_MSNR').AsString, localTableCapteurs.FieldByName('NR').AsString, localTableCapteurs.FieldByName('NAME').AsString]));
                          unite := trim(copy(localTableCapteurs.FieldByName('SS_1').AsString, 0, 6));
                          SensorList.Values[localTableCapteurs.FieldByName('NR').AsString] := localTableCapteurs.FieldByName('NAME').AsString + '|' + unite;
                          localTableCapteurs.next;
                        End;
                        localTableStations.next;
                    End else exit;
                End;
            End;
            localTableRoot.next;
         End;
        End Else LogLine(1, _POSTGRES_DATABASE_NOT_CONNECTED);
      Finally
        localTableRoot.Free;
        localTableStations.Free;
        localTableCapteurs.Free;
      End;
      Result := True;
    End;

function THydras.getAllStationsForAutomatic(domaine: string; StationsList: TStrings): boolean;
    Var
        fichier, ligne : string;
        localTableRoot, localTableStations, localTableCapteurs : TTable;

    Begin
      Result := False;
      LogLine(0, format('Lecture des stations pour : %s pour la configuration automatique', [domaine]));
      localTableRoot := TTable.Create(nil);
      localTableStations := TTable.Create(nil);
      localTableCapteurs := TTable.Create(nil);
      Try
        Fichier := includeTrailingPathDelimiter(domaine) + 'GB_DATEI.DB';
        If DataModuleDatas.ouvreTable(fichier, localTableRoot)
          Then Begin
            while Not localTableRoot.Eof
            Do Begin
              If Not localTableRoot.Fields[2].IsNull
                Then Begin
                  fichier :=  includeTrailingPathDelimiter(domaine) + localTableRoot.FieldValues['GB_MDATEI'] + '.DB';
                  DataModuleDatas.ouvreTable(fichier, localTableStations);
                  While Not localTableStations.Eof
                    Do Begin
                      fichier := localTableStations.FieldByName('GBM_MSNR').AsString;
                      insert('.', fichier, 9);
                      Ligne := fichier;
                      fichier := includeTrailingPathDelimiter(domaine) + includeTrailingPathDelimiter(fichier) + 'SS_DATEI.DB';
                      If DataModuleDatas.ouvreTable(fichier, localTableCapteurs)
                        Then Begin
                          While Not localTableCapteurs.Eof
                            Do Begin
                              StationsList.add(format('%s/%s : %s', [localTableStations.FieldByName('GBM_MSNR').AsString, localTableCapteurs.FieldByName('NR').AsString, localTableCapteurs.FieldByName('NAME').AsString]));
                              localTableCapteurs.next;
                            End;
                          localTableStations.next;
                        End else exit;
                    End;
                End;
          localTableRoot.next;
        End;
      End Else LogLine(1, '_DATABASENOTCONNECTED');
      Result := True;

      Finally
        localTableRoot.Free;
        localTableStations.Free;
        localTableCapteurs.Free;
      End;
    End;

function THydras.getAllJobs(StationsList: TStrings): boolean;
    Var
        fichier : string;
        localTableRoot : TTable;

    Begin
      Result := False;
      localTableRoot := TTable.Create(nil);
      Try
        LogLine(0, 'Lecture des jobs pour : ');
        If DataModuleDatas.ouvreTable(PATH_APPDATAS_HYDRAS + 'EXP_JOBS.DB', localTableRoot) Then
        Begin
          localTableRoot.first;
          while Not localTableRoot.Eof
            Do Begin
              StationsList.Add(localTableRoot.FieldByName('JOBNAME').AsString);
              localTableRoot.next;
            End;
        End Else LogLine(1, 'Table Non Trouv');
      Finally
        localTableRoot.Free;
      End;
      Result := True;
    End;










end.


