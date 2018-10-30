#ifndef QdbIs64bit
#error "QdbIs64bit should be defined"
#endif

#ifndef QdbVersion
#error "QdbVersion should be defined"
#endif

#ifndef QdbSetupBaseName
#define QdbSetupBaseName "qdb-windows-32bit-setup"
#endif

#ifndef QdbOutputDir
#define QdbOutputDir "qdb"
#endif

#if QdbIs64bit == "1"
#define MyAppName "quasardb 64-bit"
#else
#define MyAppName "quasardb 32-bit"
#endif

#define MyAppPublisher "quasardb SAS"
#define MyAppURL "https://www.quasardb.net/"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
;AppVerName={#MyAppName} {#QdbVersion}
AppCopyright=Copyright (C) 2009-2018 quasardb SAS
AppId={{20FBA2FC-C0A4-4080-AAF1-151F170BC532}
AppName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppVersion={#QdbVersion}
Compression=lzma
DefaultDirName={pf}\quasardb
DefaultGroupName=quasardb
DisableDirPage=no
LicenseFile={#QdbOutputDir}\share\doc\qdb\LICENSE.txt
OutputBaseFilename={#QdbSetupBaseName}
OutputDir=.
SolidCompression=yes
WizardImageFile=WizardImage.bmp
WizardSmallImageFile=WizardSmallImage.bmp

#if QdbIs64bit == "1"
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: full;   Description: "Full installation"
Name: server; Description: "Server installation"
Name: client; Description: "Client installation"
Name: custom; Description: "Custom installation"; Flags: iscustom

[Components]
Name: qdbd;     Description: "Server (qdbd)";           Types: full server;
Name: utils;    Description: "Utilities (qdbsh...)";    Types: full client;
Name: api;      Description: "C API (qdb_api.dll)";     Types: full client;
Name: doc;      Description: "Documentation";           Types: full server client;

[Dirs]
Components: qdbd ;  Name: "{app}\share\qdb"; Flags: uninsneveruninstall
Components: qdbd ;  Name: "{app}\conf"; Flags: uninsneveruninstall
Components: qdbd ;  Name: "{code:GetQdbDir|log}"; Flags: uninsneveruninstall
Components: qdbd;   Name: "{code:GetQdbDir|db}"; Flags: uninsneveruninstall

[Files]
Components: api;      Source: "{#QdbOutputDir}\bin\qdb_api.dll";              DestDir: "{sys}";                         Flags: ignoreversion;
Components: qdbd;     Source: "{#QdbOutputDir}\bin\qdb_dbtool.exe";           DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: qdbd;     Source: "{#QdbOutputDir}\bin\qdb_service.exe";          DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: qdbd;     Source: "{#QdbOutputDir}\bin\qdbd.exe";                 DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: qdbd;     Source: "{#QdbOutputDir}\bin\qdb_cluster_keygen.exe";   DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: qdbd;     Source: "{#QdbOutputDir}\bin\qdb_user_add.exe";         DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: utils;    Source: "{#QdbOutputDir}\bin\qdb_max_conn.exe";         DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: utils;    Source: "{#QdbOutputDir}\bin\qdbsh.exe";                DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: utils;    Source: "{#QdbOutputDir}\bin\qdb-benchmark.exe";        DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: utils;    Source: "{#QdbOutputDir}\bin\qdb-railgun.exe";          DestDir: "{app}\bin";                     Flags: ignoreversion;
Components: doc;      Source: "{#QdbOutputDir}\share\doc\qdb\*";              DestDir: "{app}\doc";                     Flags: recursesubdirs;

[Run]
Components: qdbd;  StatusMsg: "Generating cluster key";   Filename: "{app}\bin\qdb_cluster_keygen.exe"; Parameters: "-p              ""{app}\share\qdb\cluster_public.key"" -s ""{app}\conf\cluster_private.key""";      Flags: runascurrentuser runhidden
Components: utils; StatusMsg: "Adding shell user";        Filename: "{app}\bin\qdb_user_add.exe";       Parameters: "-u qdbsh -p     ""{app}\conf\users.conf""              -s ""{app}\conf\qdbsh_private.key""";         Flags: runascurrentuser runhidden

Components: qdbd;     StatusMsg: "Install Server";       Filename: "{app}\bin\qdb_service.exe";          Parameters: "/install"; Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r LocalService:(OI)(CI)RX";  Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r Administrators:(OI)(CI)F"; Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Secure conf directory";          Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /inheritance:r";                    Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Grant access to log directory";  Filename: "{sys}\icacls.exe";  Parameters: """{code:GetQdbDir|log}"" /grant:r LocalService:(OI)(CI)F";      Flags: runascurrentuser runhidden
Components: qdbd;           StatusMsg: "Grant access to db directory";   Filename: "{sys}\icacls.exe";  Parameters: """{code:GetQdbDir|db}""  /grant:r LocalService:(OI)(CI)F";      Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Backup license";       Filename: "cmd"; Parameters: "/c ""move /Y ""{code:GetQdbLicenseFileDestination}"" ""{code:GetQdbLicenseFileDestination}.bak"" """; Check: ShouldCopyNewLicense();      Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Install license";      Filename: "cmd"; Parameters: "/c ""copy /Y ""{code:GetQdbLicenseFileSource}""      ""{code:GetQdbLicenseFileDestination}""     """; Check: ShouldCopyNewLicense();      Flags: runascurrentuser runhidden

Components: qdbd;     StatusMsg:  "Update Server Configuration";            Filename: "cmd"; Parameters: "/c ""copy /Y ""{app}\conf\qdbd.conf""      ""{app}\conf\qdbd.conf.bak""      && ""{app}\bin\qdbd.exe""      -c ""{app}\conf\qdbd.conf.bak""      --gen-config ""--log-directory={code:GetQdbDir|log}"" ""--root={code:GetQdbDir|db}"" ""--license-file={code:GetQdbLicenseFileToSet}"" > ""{app}\conf\qdbd.conf""     """; Check: FileExists(ExpandConstant('{app}\conf\qdbd.conf'));      Flags: runascurrentuser runhidden

Components: qdbd;     StatusMsg: "Create Server Configuration";           Filename: "cmd"; Parameters: "/c """"{app}\bin\qdbd.exe""      --gen-config --security=true ""--cluster-private-file={app}\conf\cluster_private.key"" ""--user-list={app}\conf\users.conf"" ""--log-directory={code:GetQdbDir|log}"" ""--root={code:GetQdbDir|db}"" ""--license-file={code:GetQdbLicenseFileToSet}"" > ""{app}\conf\qdbd.conf""     """; Check: not FileExists(ExpandConstant('{app}\conf\qdbd.conf'));      Flags: runascurrentuser runhidden

Components: qdbd;     StatusMsg: "Start Server";         Filename: "sc.exe"; Parameters: "start qdbd";      Flags: runhidden

[UninstallRun]
Components: qdbd;     StatusMsg: "Stop Server";          Filename: "sc.exe"; Parameters: "stop qdbd";      Flags: runhidden

Components: qdbd;     StatusMsg: "Remove Server";        Filename: "{app}\bin\qdb_service.exe";      Parameters: "/remove"; Flags: runascurrentuser runhidden

[Registry]
Components: qdbd;     Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdbd";       ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdbd.conf"

[Icons]
Components: utils;  Name: "{group}\quasardb shell"; Filename: "{app}\bin\qdbsh.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Code]
var
  QdbDirPage: TInputDirWizardPage;
  QdbLicensePage: TInputFileWizardPage;

function GetQdbDir(Param: string): string;
begin
  Case Param of
    'db':  Result := QdbDirPage.Values[0];
    'log': Result := QdbDirPage.Values[1];
  end
end;

function GetQdbLicenseFileSource(Param: string) : string;
begin
  Result := QdbLicensePage.Values[0]
end;

function GetQdbLicenseFileDestination(Param: string) : string;
begin
  if QdbLicensePage.Values[0] <> '' then
    Result := ExpandConstant('{app}\conf\qdb_license.txt')
  else
    Result := '';
end;

function GetQdbLicenseFileToSet(Param: string) : string;
begin
  if GetQdbLicenseFileDestination('') = '' then
    Result := ' ' {<- HACK: the command line flag --license-file cannot be empty}
  else
    Result := GetQdbLicenseFileDestination('');
end;

function ShouldCopyNewLicense() : boolean;
begin
  Result := (GetQdbLicenseFileSource('') <> '') and (GetQdbLicenseFileSource('') <> GetPreviousData('LicenseFile', ''));
end;

procedure InitializeWizard;
begin
  QdbLicensePage := CreateInputFilePage(wpSelectDir, 'License file', 'Do you have a license file?', 'Select a quasardb license file. Leave the box empty for Community Edition.');
  QdbLicensePage.Add('Location of quasardb license:', 'Text files|*.txt|All files|*.*', '.txt');
  QdbDirPage := CreateInputDirPage(wpSelectDir, 'Data directories', 'Where to store quasardb files?', 'Select the directories in which quasardb data will be stored, then click Next.', False, 'New Folder');
  QdbDirPage.Add('Database files');
  QdbDirPage.Add('Log files');
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'DbDir', QdbDirPage.Values[0]);
  SetPreviousData(PreviousDataKey, 'LogDir', QdbDirPage.Values[1]);
  SetPreviousData(PreviousDataKey, 'LicenseFile', GetQdbLicenseFileDestination(''));
end;

function NextButtonClick(CurPageID: Integer): boolean;
begin
  if CurPageID = wpSelectDir then
  begin
    QdbLicensePage.Values[0] := GetPreviousData('LicenseFile', '');
    QdbDirPage.Values[0] := GetPreviousData('DbDir', ExpandConstant('{app}\db'));
    QdbDirPage.Values[1] := GetPreviousData('LogDir', ExpandConstant('{app}\log'));
  end;

  Result := True;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: string): string;
var
  S: string;
begin
  S := MemoDirInfo + NewLine + NewLine;

  S := S + 'License' + NewLine;
  if QdbLicensePage.Values[0] = '' then
  begin
    S := S + Space + 'Community Edition' + NewLine + NewLine;
  end
  else
  begin
    S := S + Space + QdbLicensePage.Values[0] + NewLine + NewLine;
  end;

  S := S + 'Database location' + NewLine;
  S := S + Space + QdbDirPage.Values[0] + NewLine + NewLine;
  S := S + 'Log files location' + NewLine;
  S := S + Space + QdbDirPage.Values[1] + NewLine + NewLine;

  S := S + MemoComponentsInfo + NewLine + NewLine;
  S := S + MemoGroupInfo;
  Result := S;
end;
