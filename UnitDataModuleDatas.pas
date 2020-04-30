// ********************************************
// *  Unité ModuleDatas                       *
// *  @Inrae 2020                             *
// *  by mario Adam mario.adam@inrae.fr       *
// ********************************************

unit UnitDataModuleDatas;

interface

uses
  SysUtils, Classes, ZAbstractConnection, ZConnection, DB, DBTables, strUtils, ZAbstractRODataset, ZDataset, ZAbstractDataset, ZAbstractTable, UnitVariables, Forms;

type
  TDataModuleDatas = class(TDataModule)
    connectionPostgres: TZConnection;
    ReadOnlySql: TZReadOnlyQuery;
    ZTableLogs: TZTable;
    connectionAdmin: TZConnection;
    Session1: TSession;
    ReadOnlyAdminSql: TZReadOnlyQuery;
    procedure launchAndShowResultSql(script : string; titre : string);
    procedure launchSql(script : string);
    procedure launchAdminSql(script : string);
    function isConnected: Boolean;
    function isAdminConnected: Boolean;
    function testDatabase(DB: TZConnection; tHostname: string; tPort: string; tUser: string; tPassword: string; tDatabase: string) : Boolean;
    procedure paramDatabase(DB: TZConnection;tHostname: string; tPort: string; tUser: string; tPassword: string; tDatabase: string);
    procedure DataModuleDestroy(Sender: TObject);
    function DeconnectAllUsers: Boolean;
    function DecodePWDEx(Data, SecurityString: string): string;
    procedure connectionPostgresBeforeConnect(Sender: TObject);
    function ouvreTable(Fichier: string; DbTable: TTable): Boolean;
    procedure DataModuleCreate(Sender: TObject);
    function IsProcedureExist(entry: string): boolean;
    function IsSchemaExist(entry: string): boolean;
    procedure GetAllProcedure(lst: TStrings);

  private
    { Private declarations }
    procedure LogLine(Indent: Integer; AMessage: string);
  public
    { Public declarations }
  end;

var
  DataModuleDatas: TDataModuleDatas;

implementation

  uses UnitExport, UnitGridResult;



{$R *.dfm}

  procedure TDataModuleDatas.GetAllProcedure(lst: TStrings);
    Begin
      If isAdminConnected
        Then Begin
          launchAdminSql(format('SELECT proname FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON pronamespace = n.oid WHERE nspname = %s;', [quotedStr('public')]));
          While Not ReadOnlyAdminSql.eof
            Do Begin
              lst.add(ReadOnlyAdminSql.FieldByname('proname').AsString);
              ReadOnlyAdminSql.Next;
            End;
        End;
    End;

  function TDataModuleDatas.IsProcedureExist(entry: string): boolean;
    Begin
      If isAdminConnected
        Then Begin
          launchAdminSql(format('SELECT proname as result FROM pg_catalog.pg_namespace n JOIN pg_catalog.pg_proc p ON pronamespace = n.oid WHERE nspname = %s and proname = %s;', [quotedStr('public'), quotedStr(entry)]));
          Result := (ReadOnlyAdminSql.FieldByname('result').AsString = entry);
        End Else Result := False;
      If Result
        Then LogLine(1, format('La procedure %s existe', [entry]))
        Else LogLine(1, format('Procedure %s non trouvé', [entry]));
    End;

  function TDataModuleDatas.IsSchemaExist(entry: string): boolean;
    Begin
      If isAdminConnected
        Then Begin
          launchAdminSql(format('select count(*) AS result from information_schema.schemata where catalog_name = %s and schema_name=%s and schema_owner <> %s', [quotedStr(connectionPostgres.Database), quotedStr(entry), quotedStr('postgres')]));
          Result := (ReadOnlyAdminSql.FieldByname('result').AsInteger = 1);
        End Else Result := False;
      If Result
        Then LogLine(1, format('La schema %s existe', [entry]))
        Else LogLine(1, format('Schema %s non trouvé', [entry]));
    End;

function TDataModuleDatas.ouvreTable(Fichier: string; DbTable: TTable): Boolean;
  Var
    Err: boolean;

  Begin
    result := False;
    With DbTable Do
    Begin
      filtered := false;
      filter := '';
      If (TableName = fichier) AND Active Then
        LogLine(2, format(_HYDRAS_TABLE_ALREADY_OPEN, [Fichier]))
      Else
      Begin
        LogLine(1, format(_HYDRAS_TABLE_OPEN, [Fichier]));
        Active := false;
        Err := false;
        If fileExists(fichier) Then
        Begin
          TableName := fichier;
          try
            Active := true;
          Except
            On E: Exception Do
              Begin
                LogLine(2 , _EXCEPTION + E.Message);
                LogLine(2 , _HYDRAS_DELETE_LOCK) ;
                DeleteFiles(ExtractFilePath(fichier), '.lck');
                try
                  Active := true;
                  Except
                    On E: Exception Do
                    Begin
                      LogLine(2 , _EXCEPTION + E.Message);
                      Err := true;
                    End;
                  End;
              End;
          End;
          If Err
            Then LogLine(-1, _HYDRAS_OPEN_ERROR);
        End Else
        Begin
          LogLine(-1, format(_FILE_NOT_EXIST, [Fichier]));
          exit;
        End;
      End;
      result := Active;
    End;
  End;

  function TDataModuleDatas.DecodePWDEx(Data, SecurityString: string): string;
    Var
        i, x, x2: integer;
        s1, s2, ss: string;

    Begin
        Result := #1;
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
        ss := securitystring;
        For i := 1 to Length(Data) Do
            If Pos(Data[i], ss) > 0 Then s2 := s2 + Data[i];
        Data := s2;
        s2   := '';
        If Length(Data) mod 2 <> 0 Then
            Exit;
        For i := 0 To Length(Data) div 2 - 1 Do
        Begin
            x := Pos(Data[i * 2 + 1], ss) - 1;
            If x < 0 Then
                Exit;
            ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
            x2 := Pos(Data[i * 2 + 2], ss) - 1;
            If x2 < 0 Then
                Exit;
            x  := x + x2 * 16;
            s2 := s2 + chr(x);
            ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
        End;
        Result := s2;
    end;

procedure TDataModuleDatas.LogLine(Indent: Integer; AMessage: string);
    Begin
        Export.LogLine(Indent, AMessage);
    end;

procedure TDataModuleDatas.paramDatabase(DB: TZConnection; tHostname: string; tPort: string; tUser: string; tPassword: string; tDatabase: string);
  Begin
      With DB Do
      Begin
        Disconnect;
        Tag := 0;
        If (tHostname = '') OR (tPort = '') OR (tUser = '') OR (tPassword = '') OR (tDatabase = '') Then exit;
        HostName := tHostname;
        Port := strToInt(tPort);
        User := tUser;
        Password := DecodePWDEx(tPassword, _PWDEx);
        if DEBUG Then LogLine(1, 'Password : ' + Password);
        Database := tDatabase;
        Tag := 1;
      End;
  End;

function TDataModuleDatas.testDatabase(DB: TZConnection; tHostname: string; tPort: string; tUser: string; tPassword: string; tDatabase: string) : Boolean;
Begin
      result := False;
      With DB Do
      Begin
        If DEBUG Then LogLine(1, _POSTGRES_CONNECTION_TEST);
        paramDatabase(DB, tHostname, tPort, tUser, tPassword, tDatabase);
        Try
          Connect;
        Except
          On E: Exception Do
            LogLine(2 , _EXCEPTION + E.Message);
        End;
        result := Connected;
        Disconnect;
      End;
End;

function TDataModuleDatas.DeconnectAllUsers: Boolean;
  Begin
    result := false;
    LogLine(2, _POSTGRES_DATABASE_KILL_USER);
    If isAdminConnected Then
      Begin
        connectionPostgres.Disconnect;
        Try
          connectionAdmin.ExecuteDirect('SELECT pg_terminate_backend (pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = ' + quotedStr(connectionPostgres.Database) + ';');
        Except
            On E: Exception Do
              LogLine(2 , _EXCEPTION + E.Message);
        End;
        LogLine(3, _POSTGRES_DATABASE_KILL_USER_OK );
        result := true;
      End Else LogLine(3, _POSTGRES_DATABASE_ERROR_LOG_ADMIN );
    end;

procedure TDataModuleDatas.launchSql(script : string);
    begin
      With connectionPostgres Do
      Begin
        If isConnected Then
        Begin
            ReadOnlySql.SQL.Text := script;
            Try
              ReadOnlySql.Active := true;
            Except
              On E: Exception Do
                LogLine(2 , _EXCEPTION + E.Message);
            End;
        End;
      End;
    End;

procedure TDataModuleDatas.launchAdminSql(script : string);
    begin
      With connectionAdmin Do
      Begin
        If isConnected Then
        Begin
            ReadOnlyAdminSql.SQL.Text := script;
            Try
              ReadOnlyAdminSql.Active := true;
            Except
              On E: Exception Do
                LogLine(2 , _EXCEPTION + E.Message);
            End;
        End;
      End;
    End;

procedure TDataModuleDatas.launchAndShowResultSql(script : string; titre : string);
    begin
      With connectionPostgres Do
      Begin
        If isConnected Then
        Begin
            ReadOnlySql.SQL.Text := script;
            Try
              ReadOnlySql.Active := true;
            Except
              On E: Exception Do
                LogLine(2 , _EXCEPTION + E.Message);
            End;
            FormResultGrid.caption := titre;
            FormResultGrid.ShowModal;
        End;
      End;
    End;

procedure TDataModuleDatas.DataModuleDestroy(Sender: TObject);
begin
   connectionPostgres.Disconnect;
end;

function TDataModuleDatas.isConnected: Boolean;
  Begin
      Result := false;
      With connectionPostgres Do
      Begin
        If Not Connected Then
        Begin
          If Tag = 0 Then exit;
          try
            Connect;
          Except
            On E: Exception Do
              LogLine(-1 , _EXCEPTION + E.Message);
          End;
          If Connected
            Then LogLine(1,  Format(_POSTGRES_CONNECTION_RESULT, [User, 'OK']))
            Else LogLine(-1, Format(_POSTGRES_CONNECTION_RESULT, [User, 'non valide']));

        End Else LogLine(1, Format(_POSTGRES_CONNECTION_ALREADY, [User]));
        Result := Connected;
      End;
  End;

function TDataModuleDatas.isAdminConnected: Boolean;
  Begin
      Result := false;
      With connectionAdmin Do
      Begin
        If Not Connected Then
        Begin
          If Tag = 0 Then exit;
          try
            Connect;
          Except
            On E: Exception Do
              LogLine(-1 , _EXCEPTION + E.Message);
          End;
          If Connected
            Then LogLine(1,  Format(_POSTGRES_CONNECTION_RESULT_ADMIN, ['OK']))
            Else LogLine(-1, Format(_POSTGRES_CONNECTION_RESULT_ADMIN, ['non valide']));

        End Else LogLine(1, Format(_POSTGRES_CONNECTION_ALREADY, ['Admin']));
        Result := Connected;

      End;
  End;


procedure TDataModuleDatas.connectionPostgresBeforeConnect(Sender: TObject);
begin
    with (Sender as TZConnection) Do
      if DEBUG Then LogLine(0, Format(_POSTGRES_CONNECTION_LOG, [Hostname, Port, User, Password, Database]));
end;

procedure TDataModuleDatas.DataModuleCreate(Sender: TObject);
begin
  Session.NetFileDir := ExtractFilePath(Application.ExeName);
end;

end.
