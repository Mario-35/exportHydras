unit UnitHydrasExplorer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, ComCtrls, DB, DBCtrls, UnitVariables,
  Buttons, DBTables ;



type
  TFormHydrasExplorer = class(TForm)
    DataSourceRegions: TDataSource;
    DataSourceStations: TDataSource;
    DataSourceCapteurs: TDataSource;
    DataSourceRoot: TDataSource;
    OpenDialog1: TOpenDialog;
    PanelContent: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    PanelStation: TPanel;
    LabelRegions: TLabel;
    DBGridRoot: TDBGrid;
    Panel2: TPanel;
    LabelCapteurs: TLabel;
    DBGridStations: TDBGrid;
    PanelStations: TPanel;
    LabelStations: TLabel;
    DBGridRegions: TDBGrid;
    PanelHaut: TPanel;
    SpeedButton1: TSpeedButton;
    LabelPath: TLabel;
    EditPath: TEdit;



    procedure ouvreRegion(Region: String);
    procedure DBGridRootCellClick(Column: TColumn);
    procedure DBGridStationsCellClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  _PATH : string;
  localTableRoot : TTable;
  localTableRegions : TTable;
  localTableStations : TTable;
  FormHydrasExplorer: TFormHydrasExplorer;

implementation

uses UnitConfiguration, UnitDataModuleDatas;

{$R *.dfm}


procedure TFormHydrasExplorer.ouvreRegion(Region: String);
begin
  DataModuleDatas.ouvreTable(IncludeTrailingPathDelimiter(Region) + _HYDRAS_TABLE_ROOT, localTableRegions);
end;

procedure TFormHydrasExplorer.DBGridRootCellClick(Column: TColumn);
begin
  If DBGridRoot.DataSource = DataSourceRoot
    Then Begin
      DataSourceRegions.DataSet := nil;
      DBGridRegions.DataSource := nil;
      If localTableRoot.FieldByName('GB_MDATEI').IsNull then exit;
      If DataModuleDatas.ouvreTable(_PATH + localTableRoot.FieldValues['GB_MDATEI'] + '.DB', localTableRegions)
        Then Begin
          DataSourceRegions.DataSet := localTableRegions;
          DBGridRegions.DataSource := DataSourceRegions;
        End;
    End;
end;

procedure TFormHydrasExplorer.DBGridStationsCellClick(Column: TColumn);
var
  temp: string;

begin
    if Not localTableRegions.Fields[0].IsNull
    Then Begin
      DataSourceStations.DataSet := nil;
      DBGridStations.DataSource := nil;
      If localTableRegions.FieldByName('GBM_MSNR').IsNull then exit;
      temp := localTableRegions.FieldValues['GBM_MSNR'];
      insert('.', temp, 9);
      If DataModuleDatas.ouvreTable(IncludeTrailingPathDelimiter(_PATH + temp) + _HYDRAS_TABLE_SENSOR, localTableStations)
        Then Begin
          DataSourceStations.DataSet := localTableStations;
          DBGridStations.DataSource := DataSourceStations;
        End;
    End;
end;

procedure TFormHydrasExplorer.FormCreate(Sender: TObject);
  begin
    localTableRoot := TTable.Create(nil);
    localTableStations := TTable.Create(nil);
    localTableRegions := TTable.Create(nil);
  end;

procedure TFormHydrasExplorer.SpeedButton1Click(Sender: TObject);
  Begin
    With OpenDialog1
    Do Begin
        DefaultExt := 'DB';
        Filename := _HYDRAS_TABLE_ROOT;
        Filter := _HYDRAS_TABLE_ROOT;
        Options := [ofReadOnly, OfPathMustExist, ofFileMustExist];

        If Execute
        Then Begin
          EditPath.Text  := ExtractFileName(ExcludeTrailingPathDelimiter(ExtractFilePath(Filename)));
          _PATH := IncludeTrailingPathDelimiter(ExtractFilePath(Filename));

          DataModuleDatas.ouvreTable(Filename, localTableRoot);
          DataSourceRoot.DataSet := localTableRoot;
          DBGridRoot.DataSource := DataSourceRoot;
        End;
    End;
  End;

procedure TFormHydrasExplorer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    localTableRoot.Free;
    localTableRegions.Free;
    localTableStations.Free;
end;

end.
