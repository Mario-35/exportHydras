// ********************************************
// *  Unité Main export                       *
// *  @Inrae 2020                             *
// *  by mario Adam mario.adam@inrae.fr       *
// ********************************************

unit UnitExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ValEdit, StrUtils,
  Buttons, ZAbstractConnection, ZConnection, Menus, ComCtrls, Mask, DBCtrls, UnitVariables,  ShellAPI,
  CheckLst, FolderMon, UnitPostGres, UnitHydras, ImgList, ToolWin;

Const
  wm_GetTraitement = WM_USER + 100;
  WM_ICONTRAY =  WM_USER + 1;

  ConnectNormal = 0;
  ConnectSSLAuto = 1;
  ConnectSTARTTLS = 2;
  ConnectDirectSSL = 3;
  ConnectTryTLS = 4;


type
  TExport = class(TForm)
    StatusBarMain: TStatusBar;
    Mnu: TPopupMenu;
    HideForm: TMenuItem;
    ShowForm: TMenuItem;
    Quitter: TMenuItem;
    TimerStart: TTimer;
    BitBtnStop: TBitBtn;
    ImageOnOff: TImageList;
    PopupMenuLogs: TPopupMenu;
    RichEditLog: TRichEdit;
    PanelUp: TPanel;
    ToolBarExport: TToolBar;
    ToolButtonHome: TToolButton;
    ToolButtonConfig: TToolButton;
    ToolButtonExplorer: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButtonAbout: TToolButton;
    ToolButtonExit: TToolButton;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    LabelMonitoring: TLabel;
    RichEditLogs: TRichEdit;
    ListBoxFilesQueue: TListBox;
    Actuel1: TMenuItem;

    procedure RefreshStatus(newState: TProcessType);
    procedure HideFormClick(Sender: TObject);
    procedure ShowFormClick(Sender: TObject);

    procedure Exit1MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
    procedure ShowFormDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure HideFormDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure QuitterDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure TimerStartTimer(Sender: TObject);
    procedure BitBtnStopClick(Sender: TObject);

    procedure StartMonitoring;
    procedure ToolButtonConfigClick(Sender: TObject);
    procedure ToolButtonExitClick(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure ToolButtonExplorerClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);

  private
    TrayIconData: TNotifyIconData;
    ligne: string;
    procedure HandlePopupItem(Sender: TObject);

// ********************************************************************************************************************
// *                                                      Folder Monitoring                                           *
// ********************************************************************************************************************
    procedure HandleFolderChange(ASender: TFolderMon; AFolderItem: TFolderItemInfo);
    procedure HandleFolderMonActivated(ASender: TObject);
    procedure HandleFolderMonDeactivated(ASender: TObject);
    procedure DirectoryWatch1Change(Sender: TObject);

    procedure CleanQueueFiles;
  public
    procedure AddInQueueFiles(FileName : String);
    procedure WmICONTRAY(var Msg: TMessage); message WM_ICONTRAY;
    Procedure MinimizeClick(Sender:TObject);
    procedure DrawBar(ACanvas: TCanvas);
    procedure LogLine(Indent: Integer; AMessage: string);
    procedure UpdateQueueFiles;

  end;

var
  Export: TExport;

implementation

uses UnitConfiguration, UnitDataModuleDatas, UnitHydrasExplorer, Registry, IniFiles, UnitSplashScreen,
  UnitFormSelectFiles, UnitListSelect;

{$R *.dfm}



procedure TExport.FormCreate(Sender: TObject);
    var
      i : integer;
        Item: TMenuItem;

    Begin
   //    DEBUG := True;

        ToolBarExport.Top := 0;
        ToolBarExport.Left := 0;
        ToolBarExport.Height := 35;
        ToolBarExport.Width := 230;
        LabelMonitoring.Left := ToolBarExport.Width;
        LabelMonitoring.Top := 0;
        LabelMonitoring.Width := Export.Width - ToolBarExport.Width;
        LabelMonitoring.Height := ToolBarExport.Height;
        Mnu.OwnerDraw:=True;
        With TrayIconData
          Do Begin
            cbSize := SizeOf(TrayIconData);
            Wnd := Handle;
            uID := 0;
            uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
            uCallbackMessage := WM_ICONTRAY;
            hIcon := Application.Icon.Handle;
            StrPCopy(szTip, Application.Title);
          End;
        Shell_NotifyIcon(NIM_ADD, @TrayIconData);
        Application.OnMinimize:= MinimizeClick;

        StatusBarMain.Panels[0].Text := 'ver : ' + APP_VERSION;

        FILE_LOGFILE := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Logs\' + '[' + Application.Title  + '] ' + formatdatetime('dd-mm-yyyy', now) +  '.log';
        LogLine(0, 'Demmarrage version : ' + APP_VERSION + _CR);
        If DEBUG
          Then LogLine(1, 'mode debug');

        RichEditLog.Align := alClient;
        RichEditLogs.Align := alClient;

        BitBtnStop.Left := Round(Export.Width / 2) - Round(BitBtnStop.Width / 2);
        BitBtnStop.top := Export.Height - Round(Export.Height / 4);

        FindFilePattern(TEMP_LIST, IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)), '.log', True);
        For i := 0 To TEMP_LIST.Count - 1
          Do Begin
            Item := TMenuItem.Create(PopupMenuLogs);
            Item.Caption := extractFileName(TEMP_LIST[i]);
            Item.OnClick := HandlePopupItem;
            PopupMenuLogs.Items.Add(Item);
          End;
        Self.PopupMenu := PopupMenuLogs;

    End;

procedure TExport.QuitterClick(Sender: TObject);
    Begin
        Application.Terminate;
    End;

procedure TExport.FormDestroy(Sender: TObject);
  Begin
    LogLine(0, 'Sortie de programme');
    Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
  End;

procedure TExport.LogLine(Indent: Integer; AMessage: string);
    Var
        F: TextFile;

    Begin
        AssignFile(F, FILE_LOGFILE);
        If FileExists(FILE_LOGFILE)
          Then Append(F)
          Else Rewrite(F);
        Try
            ligne := Format('[%s] %s %s', [TimeToStr(Now), StringOfChar(_TAB, abs(indent)), AMessage]);
            WriteLn(F, ligne);
        finally
            CloseFile(F);
            Application.ProcessMessages;
        end;

        With RichEditLog
          Do Begin
            SelAttributes.Color := clBlue;
            // RichEdit1.SelAttributes.Style := [fsBold];
            SelText := '['+ TimeToStr(Now) + ']' + StringOfChar(_TAB, abs(indent));
            If indent = 0
              Then SelAttributes.Color := clBlack
              Else If indent > 0
                Then SelAttributes.Color := clGreen
                Else SelAttributes.Color := clRed;
            SelText := #32 + AMessage + #13;

            //SetFocus;
            SelStart := GetTextLen;
            Perform(EM_SCROLLCARET, 0, 0);
        End;
    end;


// ********************************************************************************************************************
// *                                                         Systray                                                  *
// ********************************************************************************************************************

procedure TExport.DrawBar(ACanvas: TCanvas);
  // Dessine dans la notification
  var
    lf : TLogFont;
    tf : TFont;
    Begin
        With ACanvas do
        Begin
            Brush.Color := clGray;
            FillRect(Rect(0,0,20,92));
            Font.Name := 'Tahoma';
            Font.Size := 7;
            Font.Style := Font.Style - [fsBold];
            Font.Color := clWhite;
            tf := TFont.Create;
            Try
                tf.Assign(Font);
                GetObject(tf.Handle, sizeof(lf), @lf);
                lf.lfEscapement := 900;
                lf.lfHeight := Font.Height - 2;
                tf.Handle := CreateFontIndirect(lf);
                Font.Assign(tf);
            Finally
                tf.Free;
            End;
                TextOut(2, 58, 'HydrasExport');
        End;
    End;



procedure TExport.Exit1MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
  begin
    Width := 190;
  end;

Procedure TExport.MinimizeClick(Sender:TObject);
begin
  Self.Hide;
end;

procedure TExport.HideFormClick(Sender: TObject);
begin
  Self.Hide;
end;

procedure TExport.ShowFormClick(Sender: TObject);
begin
  Self.Show;
end;

procedure TExport.WmICONTRAY(var Msg: TMessage);
    Var
     p : TPoint;

    Begin
        Case Msg.lParam Of
            WM_LBUTTONDOWN:
                Begin
                    self.Show;
                end;
            WM_RBUTTONDOWN:
                begin
                    SetForegroundWindow(Handle);
                    GetCursorPos(p);
                    Mnu.Popup(p.x, p.y);
                    PostMessage(Handle, WM_NULL, 0, 0);
                end;
        end;
    end;

procedure TExport.ShowFormDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    Begin
        If Selected Then
            ACanvas.Brush.Color := clHighlight
        Else
            ACanvas.Brush.Color := clMenu;

        ARect.Left := 25;
        ACanvas.FillRect(ARect);
        DrawText(ACanvas.Handle, PChar('Show Form'), -1, ARect, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
    End;

procedure TExport.HideFormDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    Begin
        If Selected Then
            ACanvas.Brush.Color := clHighlight
        Else
            ACanvas.Brush.Color := clMenu;

        ARect.Left := 25;
        ACanvas.FillRect(ARect);

        DrawText(ACanvas.Handle, PChar('Hide Form'), -1, ARect, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
    End;

procedure TExport.QuitterDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    Begin
        If Selected Then
            ACanvas.Brush.Color := clHighlight
        Else
            ACanvas.Brush.Color := clMenu;

        ARect.Left := 25;
        ACanvas.FillRect(ARect);
        DrawText(ACanvas.Handle, PChar('Exit'), -1, ARect, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_NOCLIP);
        DrawBar(ACanvas);
    End;


procedure TExport.TimerStartTimer(Sender: TObject);
    Var
      FTPostGres : TPostGres;

    Begin
      CleanQueueFiles;
      If (FOLDER_MONITORING.IsActive) AND (PROCESS in [tpNone, tpWait, tpDone, tpMonitor]) AND (ListBoxFilesQueue.Items.Count > 0)
        Then Begin
          LogLine(0, _PROCESS_START_TIMER);
          FTPostGres := TPostGres.Create;
        Try
          LogLine(1, _PROCESS_MODE_AUTO);
          FTPostGres.Lancer;
        Finally
          FTPostGres.Free;
        End;
      End;
    End;



  procedure TExport.RefreshStatus(newState: TProcessType);
    Begin
      PROCESS := newState;
      BitBtnStop.Visible := False;
      Case PROCESS of
        tpInit : Begin
          StatusBarMain.Panels[1].Text := 'Initialisation';
          BitBtnStop.Visible := True;
          BitBtnStop.SetFocus;
        End;
        tpStart : Begin
          StatusBarMain.Panels[1].Text := 'Démarrage';
          BitBtnStop.Visible := True;
          BitBtnStop.SetFocus;
        End;
        tpRun : Begin
          StatusBarMain.Panels[1].Text := 'Execution ...';
          BitBtnStop.Visible := PROCESS = tpRun;
          If BitBtnStop.Visible Then BitBtnStop.SetFocus;
        End;
        tpWait : StatusBarMain.Panels[1].Text := 'Traitement en Attente';
        tpPause : StatusBarMain.Panels[1].Text := 'Traitement en pause';
        tpStop : Begin
          StatusBarMain.Panels[1].Text := 'Traitement stoppé';
        End;
        tpError : StatusBarMain.Panels[1].Text := 'Erreur';
        tpDone :  StatusBarMain.Panels[1].Text := 'Terminé';
        tpZip :  StatusBarMain.Panels[1].Text := 'Zip fichier(s)';
        tpMonitor : Begin
          if FOLDER_MONITORING.Folder = ''
            Then StartMonitoring
            Else FOLDER_MONITORING.Activate;
          StatusBarMain.Panels[1].Text := 'Ecoute en cours';
        End;
    End;

    Application.ProcessMessages;
  End;

procedure TExport.BitBtnStopClick(Sender: TObject);
begin
    If messagedlg('Annuler le traitement ',mtConfirmation , mbOKCancel, 0) = mrOk
      Then Begin
        LogLine(0, 'Arret de traitement');
        RefreshStatus(tpStop);
      End Else LogLine(0, 'Annulation do l''arret de traitement');
end;
// ********************************************************************************************************************
// *                                                      Folder Monitoring                                           *
// ********************************************************************************************************************

procedure TExport.UpdateQueueFiles;
  Begin
      ListBoxFilesQueue.Visible := (ListBoxFilesQueue.Items.Count > 0);
      ListBoxFilesQueue.Height :=   ListBoxFilesQueue.Items.Count * 13;
      If ListBoxFilesQueue.Height > (RichEditLog.Height div 2 ) Then ListBoxFilesQueue.Height := (RichEditLog.Height div 2 );
      ListBoxFilesQueue.Top := (StatusBarMain.top - ListBoxFilesQueue.Height) - 2;
      ListBoxFilesQueue.left := (RichEditLog.Width - ListBoxFilesQueue.Width) - 2;
  End;

procedure TExport.AddInQueueFiles(FileName : String);
  var
    tmp : string;
     i : integer;

  Begin
      If (ExtractFileExt(FileName) = '.csv')
      Then Begin
        If AnsiPos(FileName, ListBoxFilesQueue.Items.Text) = 0
          Then Begin
            ListBoxFilesQueue.Items.Add(FileName);
            LogLine(1 , 'Ajout du fichier dans la queue : ' + tmp);
          End;
      End;
      CleanQueueFiles;
      UpdateQueueFiles;
  End;


procedure TExport.CleanQueueFiles;
  var
    tmp : string;
     i : integer;

  Begin
    For i := 0 To ListBoxFilesQueue.Items.count - 1
      Do If Not FileExists(ListBoxFilesQueue.Items[i])
        Then ListBoxFilesQueue.Items[i] := '';
    Supprime_Ligne_Blanche(ListBoxFilesQueue.Items);
  End;

procedure TExport.HandleFolderChange(ASender: TFolderMon; AFolderItem: TFolderItemInfo);
  var
    tmp : string;
     i : integer;

  Begin
      tmp := IncludeTrailingPathDelimiter(ASender.Folder) + AFolderItem.Name;
      LogLine(0,FOLDER_ACTION_NAMES[AFolderItem.Action] + ' Fichier : ' + tmp);
      If FOLDER_MONITORING.IsActive
        Then Begin
          TimerStart.Enabled := False;
          AddInQueueFiles(tmp);
          TimerStart.Enabled := (ListBoxFilesQueue.Items.count > 0) AND (FOLDER_MONITORING.IsActive) AND (PROCESS in [tpNone, tpWait, tpDone, tpMonitor]);
        End;
  End;

procedure TExport.HandleFolderMonActivated(ASender: TObject);
  Begin
    LogLine(1, format(_MONITORING_DIR_START, [FOLDER_MONITORING.Folder]));
    LabelMonitoring.Caption := format(_MONITORING_DIR_START, [FOLDER_MONITORING.Folder]);
  End;

procedure TExport.HandleFolderMonDeactivated(ASender: TObject);
  Begin
    LogLine(1, format(_MONITORING_DIR_STOP, [FOLDER_MONITORING.Folder]));
     LabelMonitoring.Caption := format(_MONITORING_DIR_STOP, [FOLDER_MONITORING.Folder]);
     TimerStart.Enabled := False;
  End;

procedure TExport.DirectoryWatch1Change(Sender: TObject);
  Begin
    LogLine(0, 'Fichier ' + Sender.ClassName);
  End;

procedure TExport.StartMonitoring;
  var
    vMonitoredChanges: TChangeTypes;

  Begin
    If FOLDER_MONITORING.IsActive Then
      FOLDER_MONITORING.Deactivate;

    FOLDER_MONITORING.OnActivated := HandleFolderMonActivated;
    FOLDER_MONITORING.OnDeactivated := HandleFolderMonDeactivated;
    FOLDER_MONITORING.OnFolderChange := HandleFolderChange;

      FOLDER_MONITORING.Folder := CONFIG.Values['CsvFolder'];
      vMonitoredChanges := [];
      if TestBool(CONFIG.Values['FilenameChange'])
        Then Include(vMonitoredChanges, ctFileName);
      if TestBool(CONFIG.Values['DirNameChange'])
        Then Include(vMonitoredChanges, ctDirName);
      if TestBool(CONFIG.Values['AttributesChange'])
        Then Include(vMonitoredChanges, ctAttr);
      if TestBool(CONFIG.Values['SizeChange'])
        Then Include(vMonitoredChanges, ctSize);
      if TestBool(CONFIG.Values['WriteTimeChange'])
        Then Include(vMonitoredChanges, ctLastWriteTime);
      if TestBool(CONFIG.Values['AccessTimeChange'])
        Then Include(vMonitoredChanges, ctLastAccessTime);
      if TestBool(CONFIG.Values['CreationTimeChange'])
        Then Include(vMonitoredChanges, ctCreationTime);
      if TestBool(CONFIG.Values['SecurityAttrChanges'])
        Then Include(vMonitoredChanges, ctSecurityAttr);

      FOLDER_MONITORING.MonitoredChanges := vMonitoredChanges;
      FOLDER_MONITORING.MonitorSubFolders := TestBool(CONFIG.Values['MonitorSubfolders']);
      FOLDER_MONITORING.Activate;
  End;

procedure TExport.ToolButtonConfigClick(Sender: TObject);
begin
  FormConfiguration.ShowModal;
end;

procedure TExport.ToolButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TExport.ToolButtonAboutClick(Sender: TObject);
begin
  Application.CreateForm(TSplashScreen, SplashScreen);
  SplashScreen.ButtonOk.Visible := True;
  SplashScreen.Showmodal;
  SplashScreen.Free;
end;

procedure TExport.ToolButtonExplorerClick(Sender: TObject);
begin
    Application.CreateForm(TFormHydrasExplorer, FormHydrasExplorer);
    FormHydrasExplorer.Showmodal;
    FormHydrasExplorer.Free;
end;



procedure TExport.ToolButton2Click(Sender: TObject);
  var
      i : Integer;
      FTPostGres : TPostGres;

  Begin
        Application.CreateForm(TFormSelectFiles, FormSelectFiles);
        FormSelectFiles.Caption := _FILES_SELECT;
        Try
          FindFilePattern(FormSelectFiles.CheckListBoxLog.Items, CONFIG.Values['CsvFolder'], '.csv', True);
          If (FormSelectFiles.CheckListBoxLog.Items.Count > 0) Then
          Begin
            For i := 0 To FormSelectFiles.CheckListBoxLog.Items .Count - 1
              Do FormSelectFiles.CheckListBoxLog.Checked[i] := true;
            PROCESS := tpWait;
            If FormSelectFiles.ShowModal = mrOk
              Then Begin
                For i := 0 To FormSelectFiles.CheckListBoxLog.Items .Count - 1
                  Do If FormSelectFiles.CheckListBoxLog.Checked[i]
                    Then AddInQueueFiles(FormSelectFiles.CheckListBoxLog.Items[i]);

                If (PROCESS in [tpNone, tpWait, tpDone, tpMonitor]) AND (ListBoxFilesQueue.Items.Count > 0)
                  Then Begin
                    FTPostGres := TPostGres.Create;
                    Try
                      LogLine(1, _PROCESS_MODE_MANUEL);
                      FTPostGres.Lancer;
                    Finally
                      FTPostGres.Free;
                    End;
                End;
              End;
          End Else messagedlg(_FILES_NOT_EXIST, mtInformation , [mbOK] , 0);
        Finally
          FormSelectFiles.Free;
        End;
end;

procedure TExport.HandlePopupItem(Sender: TObject);
  Var
    S : string;

  begin
    S := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Logs') + TMenuItem(Sender).Caption;
      If FileExists(S)
          Then Begin
            RichEditLogs.Lines.LoadFromFile(S);
            ACTUAL_LOG := False;
          End Else ACTUAL_LOG := True;
    RichEditLogs.Visible := Not ACTUAL_LOG;
    RichEditLog.Visible := ACTUAL_LOG;
end;

end.
