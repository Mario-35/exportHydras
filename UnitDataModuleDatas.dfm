object DataModuleDatas: TDataModuleDatas
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 914
  Top = 220
  Height = 390
  Width = 518
  object connectionPostgres: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = True
    Properties.Strings = (
      'AutoEncodeStrings=ON')
    BeforeConnect = connectionPostgresBeforeConnect
    SQLHourGlass = True
    HostName = '138.102.159.39'
    Port = 5432
    Database = 'agrhys_dev'
    User = 'adminpg'
    Password = 'pgAgrh!s08'
    Protocol = 'postgresql-9'
    LibraryLocation = 'C:\ExportHydras\libpq.dll'
    Left = 48
    Top = 16
  end
  object ReadOnlySql: TZReadOnlyQuery
    Connection = connectionPostgres
    Params = <>
    Left = 48
    Top = 88
  end
  object ZTableLogs: TZTable
    Connection = connectionPostgres
    SortedFields = 'ldate'
    SortType = stDescending
    Filter = 'laction='#39'CREATE_LOG'#39' AND lvaleur='#39'IMPORT'#39
    Filtered = True
    ReadOnly = True
    TableName = 'public.logs'
    IndexFieldNames = 'ldate Desc'
    Left = 40
    Top = 216
  end
  object connectionAdmin: TZConnection
    ControlsCodePage = cGET_ACP
    AutoEncodeStrings = True
    Properties.Strings = (
      'AutoEncodeStrings=ON')
    SQLHourGlass = True
    HostName = '138.102.159.39'
    Port = 5432
    Database = 'postgres'
    User = 'adminpg'
    Password = 'pgAgrh!s08'
    Protocol = 'postgresql-9'
    LibraryLocation = 'C:\ExportHydras\libpq.dll'
    Left = 168
    Top = 16
  end
  object Session1: TSession
    Left = 160
    Top = 96
  end
  object ReadOnlyAdminSql: TZReadOnlyQuery
    Connection = connectionAdmin
    Params = <>
    Left = 40
    Top = 152
  end
end
