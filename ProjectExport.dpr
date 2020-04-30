program ProjectExport;

uses
  Forms,
  UnitVariables in 'UnitVariables.pas',
  UnitExport in 'UnitExport.pas' {Export},
  UnitConfiguration in 'UnitConfiguration.pas' {FormConfiguration},
  UnitDataModuleDatas in 'UnitDataModuleDatas.pas' {DataModuleDatas: TDataModule},
  UnitHydrasExplorer in 'UnitHydrasExplorer.pas' {FormHydrasExplorer},
  UnitListSelect in 'UnitListSelect.pas' {FormListSelect},
  UnitGridResult in 'UnitGridResult.pas' {FormResultGrid},
  UnitSplashScreen in 'UnitSplashScreen.pas' {SplashScreen},
  UnitHydras in 'UnitHydras.pas',
  UnitPostgres in 'UnitPostgres.pas',
  UnitFormSelectFiles in 'UnitFormSelectFiles.pas' {FormSelectFiles};

{$R *.res}

begin
  Application.Initialize;
  SplashScreen := TSplashScreen.Create(nil) ;
  SplashScreen.Show;
  SplashScreen.Update;
  Application.CreateForm(TExport, Export);
  Application.CreateForm(TDataModuleDatas, DataModuleDatas);
  Application.CreateForm(TFormResultGrid, FormResultGrid);
  Application.CreateForm(TFormConfiguration, FormConfiguration);
  SplashScreen.Hide;
  SplashScreen.Free;
  Application.Run;
End.
