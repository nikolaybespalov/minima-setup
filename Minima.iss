; Script for creating an installer for Minima 

#include "Common.iss"
#include "Utils.iss"
#include "DataFolderPage.iss"
#include "SelectJREPage.iss"

[Setup]
AppId={{2E08023A-2B80-4BDE-9DAA-FE40606656B4}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf}\{#MyAppName}
DefaultGroupName={#MyAppName}
SetupIconFile=favicon.ico
UninstallDisplayIcon={app}\favicon.ico
UninstallDisplayName={#MyAppName}
DisableProgramGroupPage=yes
DisableWelcomePage=no
OutputBaseFilename=minima-{#MyAppVersion}-setup
Compression=lzma
ArchitecturesInstallIn64BitMode=x64
WizardImageAlphaFormat=defined

[Files]
Source: "WinSW-x64.exe"; DestDir: "{app}"; DestName: minima.exe; Check: IsWin64 
Source: "WinSW-x86.exe"; DestDir: "{app}"; DestName: minima.exe; Check: not IsWin64
Source: "favicon.ico"; DestDir: "{app}";
Source: "minima.jar"; DestDir: "{app}";
Source: "minima.xml"; DestDir: "{app}"; AfterInstall: processMinimaXml
Source: "7za.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall;
Source: "minima32.bmp"; DestDir: "{tmp}"; Flags: dontcopy
Source: "java32.bmp"; DestDir: "{tmp}"; Flags: dontcopy

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Icons]
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: {#MyAppURL}
Name: "{group}\MiniDapp Hub"; Filename: "http://localhost:9004"

[Run]
;; Extracting Java
Filename: "{tmp}\7za.exe"; Parameters: "x ""{tmp}\{#JreOutputFile}"" -o""{tmp}\"" * -aoa"; StatusMsg: "Extracting Java..."; Flags: runhidden;
Filename: "{tmp}\7za.exe"; Parameters: "x ""{tmp}\jre.tar"" -o""{app}\"" * -r -aoa"; StatusMsg: "Extracting Java..."; Flags: runhidden;
;; Run as Service
Filename: "{app}\minima.exe"; Parameters: "install"; StatusMsg: "Installing the service..."; Flags: runhidden;
Filename: "{app}\minima.exe"; Parameters: "start"; StatusMsg: "Starting the service..."; Flags: runhidden;
Filename: "http://localhost:9004"; Flags: shellexec runasoriginaluser postinstall; Description: "Open MiniDapp Hub."

[UninstallRun]
Filename: "{app}\minima.exe"; Parameters: "stop"; Flags: runhidden;
Filename: "{app}\minima.exe"; Parameters: "uninstall"; Flags: runhidden;

[UninstallDelete]
Type: files; Name: "{app}\minima.exe"
Type: filesandordirs; Name: "{app}\{#JreOutputFolder}"
Type: dirifempty; Name: "{app}\{#JreOutputFolder}"
Type: dirifempty; Name: "{app}"

[Code]
var
  DownloadPage: TDownloadWizardPage;
  DataFolderPage: TWizardPage;
  SelectJREPage: TWizardPage;

procedure InitializeWizard();
begin
  FakePage := CreateInputDirPage(wpWelcome, '', '', '', False, '');
  FakePage.Add('');

  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), nil);

  DataFolderPage := CreateDataFolderPage();

  SelectJREPage := CreateSelectJREPage(DataFolderPage.ID);
end;

function InitializeSetup(): Boolean;
begin
  result := true;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
var
  S: String;
begin
  { Fill the 'Ready Memo' with the normal settings and the custom settings }
  S := S + MemoDirInfo + NewLine;
  S := S + NewLine;

  S := S + 'Data folder location:' + NewLine;
  S := S + Space + DataFolderLocation + NewLine;
  S := S + NewLine;

  S := S + 'Java location:' + NewLine;
  S := S + Space + JavaLocation + NewLine;
  S := S + NewLine;

  S := S + 'Java options:' + NewLine;
  S := S + Space + JavaOptions + NewLine;
  S := S + NewLine;

  Result := S;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if (CurPageID = wpReady) and DownloadJavaCheckBox.Checked then begin
    DownloadPage.Clear;
    if IsWin64 then
    begin
      DownloadPage.Add(ExpandConstant('{#JreLink64}'), ExpandConstant('{#JreOutputFile}'), ExpandConstant('{#JreLink64Sha}'));
    end
    else
      DownloadPage.Add(ExpandConstant('{#JreLink86}'), ExpandConstant('{#JreOutputFile}'), ExpandConstant('{#JreLink86Sha}'));
    begin
    end;

    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end else
    Result := True;
end;

