#ifndef QdbIs64bit
#error "QdbIs64bit should be defined"
#endif

#ifndef QdbVersion
#error "QdbVersion should be defined"
#endif

#ifndef QdbSetupBaseName
#if QdbIs64bit == "1"
#define QdbSetupBaseName "qdb-windows-64bit-setup"
#else
#define QdbSetupBaseName "qdb-windows-32bit-setup"
#endif
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
AppCopyright=Copyright (C) 2009-2019 quasardb SAS
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
Name: qdbd;   Description: "Server (qdbd)";                     Types: full server;
Name: utils;  Description: "Utilities (qdbsh...)";              Types: full client;
Name: api;    Description: "C API (qdb_api.dll)";               Types: full client;
Name: doc;    Description: "Documentation";                     Types: full server client;

#if QdbIs64bit == "1"
Name: api_rest;  Description: "REST API (qdb_rest)";     Types: full server;
Name: dashboard; Description: "Dashboard";               Types: full server;
#endif

[Dirs]
Components: qdbd;  Name: "{app}\share\qdb"; Flags: uninsneveruninstall
Components: qdbd;  Name: "{app}\conf"; Flags: uninsneveruninstall
Components: qdbd;  Name: "{code:GetQdbDir|log}"; Flags: uninsneveruninstall
Components: qdbd;  Name: "{code:GetQdbDir|db}"; Flags: uninsneveruninstall

#if QdbIs64bit == "1"
Components: api_rest;  Name: "{app}\share\qdb"; Flags: uninsneveruninstall
Components: api_rest;  Name: "{app}\conf"; Flags: uninsneveruninstall
Components: api_rest;  Name: "{code:GetQdbDir|log}"; Flags: uninsneveruninstall
#endif

[Files]
Components: api;       Source: "{#QdbOutputDir}\bin\qdb_api.dll";              DestDir: "{sys}";         Flags: ignoreversion;
Components: qdbd;      Source: "{#QdbOutputDir}\bin\qdb_dbtool.exe";           DestDir: "{app}\bin";     Flags: ignoreversion;
Components: qdbd;      Source: "{#QdbOutputDir}\bin\qdb_service.exe";          DestDir: "{app}\bin";     Flags: ignoreversion;
Components: qdbd;      Source: "{#QdbOutputDir}\bin\qdbd.exe";                 DestDir: "{app}\bin";     Flags: ignoreversion;
Components: qdbd;      Source: "{#QdbOutputDir}\bin\qdb_cluster_keygen.exe";   DestDir: "{app}\bin";     Flags: ignoreversion;
Components: qdbd;      Source: "{#QdbOutputDir}\bin\qdb_user_add.exe";         DestDir: "{app}\bin";     Flags: ignoreversion;
Components: utils;     Source: "{#QdbOutputDir}\bin\qdb_max_conn.exe";         DestDir: "{app}\bin";     Flags: ignoreversion;
Components: utils;     Source: "{#QdbOutputDir}\bin\qdbsh.exe";                DestDir: "{app}\bin";     Flags: ignoreversion;
Components: utils;     Source: "{#QdbOutputDir}\bin\qdb_csv_generator.exe";    DestDir: "{app}\bin";     Flags: ignoreversion;
Components: utils;     Source: "{#QdbOutputDir}\bin\qdb_export.exe";           DestDir: "{app}\bin";     Flags: ignoreversion;
Components: utils;     Source: "{#QdbOutputDir}\bin\qdb_import.exe";           DestDir: "{app}\bin";     Flags: ignoreversion;
Components: doc;       Source: "{#QdbOutputDir}\share\doc\qdb\*";              DestDir: "{app}\doc";     Flags: recursesubdirs;

#if QdbIs64bit == "1"
Components: api_rest;  Source: "{#QdbOutputDir}\bin\qdb_rest.exe";             DestDir: "{app}\bin";     Flags: ignoreversion;
Components: api_rest;  Source: "{#QdbOutputDir}\bin\qdb_rest_service.exe";     DestDir: "{app}\bin";     Flags: ignoreversion;
Components: api_rest;  Source: "{#QdbOutputDir}\bin\openssl.exe";              DestDir: "{app}\bin";     Flags: deleteafterinstall;
Components: api_rest;  Source: "{#QdbOutputDir}\bin\libeay32.dll";             DestDir: "{app}\bin";     Flags: deleteafterinstall;
Components: api_rest;  Source: "{#QdbOutputDir}\bin\ssleay32.dll";             DestDir: "{app}\bin";     Flags: deleteafterinstall;
Components: api_rest;  Source: "{#QdbOutputDir}\etc\openssl.conf";             DestDir: "{app}";         Flags: deleteafterinstall;
Components: dashboard; Source: "{#QdbOutputDir}\assets\*";                     DestDir: "{app}\assets";  Flags: recursesubdirs;

Components: api_rest;  Source: "{#QdbOutputDir}\etc\qdb_rest.conf.sample";     DestDir: "{app}\conf";    Flags: recursesubdirs;       AfterInstall: ConfigureQdbRestDefault(ExpandConstant('{app}\conf\qdb_rest.conf.sample'))
#endif

[Run]
Components: utils; StatusMsg: "Adding shell user";          Filename: "cmd"; Parameters: "/c ""move /Y ""{app}\conf\users.conf"" ""{app}\conf\users.conf.bak""";  AfterInstall: AddUsers(); Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Generating cluster key";         Filename: "{app}\bin\qdb_cluster_keygen.exe"; Parameters: "-p              ""{app}\share\qdb\cluster_public.key"" -s ""{app}\conf\cluster_private.key""";      Flags: runascurrentuser runhidden

Components: qdbd;     StatusMsg: "Install Server";              Filename: "{app}\bin\qdb_service.exe";          Parameters: "/install"; Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r LocalService:(OI)(CI)RX";  Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r Administrators:(OI)(CI)F"; Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Secure conf directory";          Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /inheritance:r";                    Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Grant access to log directory";  Filename: "{sys}\icacls.exe";  Parameters: """{code:GetQdbDir|log}"" /grant:r LocalService:(OI)(CI)F";      Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Grant access to db directory";   Filename: "{sys}\icacls.exe";  Parameters: """{code:GetQdbDir|db}""  /grant:r LocalService:(OI)(CI)F";      Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Backup license";       Filename: "cmd"; Parameters: "/c ""move /Y ""{code:GetQdbLicenseFileDestination}"" ""{code:GetQdbLicenseFileDestination}.bak"" """; Check: ShouldCopyNewLicense();      Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Install license";      Filename: "cmd"; Parameters: "/c ""copy /Y ""{code:GetQdbLicenseFileSource}""      ""{code:GetQdbLicenseFileDestination}""     """; Check: ShouldCopyNewLicense();      Flags: runascurrentuser runhidden
 
Components: qdbd;  StatusMsg: "Backup Server Configuration"; Filename: "cmd"; Parameters: "/c ""move /Y ""{app}\conf\qdbd.conf"" ""{app}\conf\qdbd.conf.bak"" "" "; Check: FileExists(ExpandConstant('{app}\conf\qdbd.conf'));  Flags: runascurrentuser runhidden
Components: qdbd;  StatusMsg: "Create Server Configuration"; Filename: "cmd"; Parameters: "/c "" ""{app}\bin\qdbd.exe"" --gen-config {code:GetQdbSecurityOption} --rocksdb-max-open-files=65536 ""--log-directory={code:GetQdbDir|log}"" ""--rocksdb-root={code:GetQdbDir|db}"" ""--license-file={code:GetQdbLicenseFileToSet}"" > ""{app}\conf\qdbd.conf"" "" "; AfterInstall: ConfigureQdbdDefault(ExpandConstant('{app}\conf\qdbd.conf'));      Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Start Server";                Filename: "sc.exe"; Parameters: "start qdbd";      Flags: runhidden

#if QdbIs64bit == "1"
Components: api_rest; StatusMsg: "Install REST API";                Filename: "{app}\bin\qdb_rest_service.exe";     Parameters: "/install"; Flags: runascurrentuser runhidden

Components: api_rest;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r LocalService:(OI)(CI)RX";  Flags: runascurrentuser runhidden
Components: api_rest;  StatusMsg: "Grant access to conf directory"; Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /grant:r Administrators:(OI)(CI)F"; Flags: runascurrentuser runhidden
Components: api_rest;  StatusMsg: "Secure conf directory";          Filename: "{sys}\icacls.exe";  Parameters: """{app}\conf"" /inheritance:r";                    Flags: runascurrentuser runhidden

Components: api_rest;  StatusMsg: "Grant access to log directory";  Filename: "{sys}\icacls.exe";  Parameters: """{code:GetQdbDir|log}"" /grant:r LocalService:(OI)(CI)F";      Flags: runascurrentuser runhidden

Components: api_rest; StatusMsg: "Backup REST API Configuration";   Filename: "cmd"; Parameters: "/c ""move /Y ""{app}\conf\qdb_rest.conf"" ""{app}\conf\qdb_rest.conf.bak"" "" ";          Check: FileExists(ExpandConstant('{app}\conf\qdb_rest.conf'));                Flags: runascurrentuser runhidden 
Components: api_rest; StatusMsg: "Create REST API Configuration";   Filename: "cmd"; Parameters: "/c ""copy /Y ""{app}\conf\qdb_rest.conf.sample"" ""{app}\conf\qdb_rest.conf"" "" "; AfterInstall: ConfigureQdbRestDefault(ExpandConstant('{app}\conf\qdb_rest.conf'));  Flags: runascurrentuser runhidden 
Components: api_rest; StatusMsg: "Create REST API Certificate";     Filename: "{app}\bin\openssl.exe";  Parameters: "req -config ""{app}\openssl.conf"" -newkey rsa:4096 -nodes -sha512 -x509 -days 3650 -nodes -out ""{app}\conf\qdb_rest.cert.pem"" -keyout ""{app}\conf\qdb_rest.key.pem"" -subj /C=FR/L=Paris/O=Quasardb/CN=Quasardb"; Check: not FileExists(ExpandConstant('{app}\conf\api-rest.cert.pem')); Flags: runascurrentuser runhidden

Components: api_rest; StatusMsg: "Start REST API";       Filename: "sc.exe"; Parameters: "start qdb_rest";  Flags: runhidden
#endif

[UninstallRun]
Components: qdbd;     StatusMsg: "Stop Server";         Filename: "sc.exe"; Parameters: "stop qdbd";                                          Flags: runhidden
Components: qdbd;     StatusMsg: "Remove Server";       Filename: "{app}\bin\qdb_service.exe";        Parameters: "/remove";                  Flags: runascurrentuser runhidden

#if QdbIs64bit == "1"
Components: api_rest; StatusMsg: "Stop REST API";        Filename: "sc.exe"; Parameters: "stop qdb_rest";                           Flags: runhidden
Components: api_rest; StatusMsg: "Remove REST API";      Filename: "{app}\bin\qdb_rest_service.exe";        Parameters: "/remove";  Flags: runascurrentuser runhidden
#endif

[Registry]
Components: qdbd;     Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdbd";       ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdbd.conf"

#if QdbIs64bit == "1"
Components: api_rest; Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdb_rest";   ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdb_rest.conf"
#endif

[Icons]
Components: utils;  Name: "{group}\quasardb shell"; Filename: "{app}\bin\qdbsh.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Code]
var
  QdbDirPage: TInputDirWizardPage;
  QdbLicensePage: TInputFileWizardPage;
  
  QdbAddUserPage: TInputQueryWizardPage;
  AddUserPageID: Integer;
  
  QdbSecurityPage: TInputOptionWizardPage;
  QdbSecurityPageID: Integer;
  
  QdbDashboardInfoPage: TOutputMsgMemoWizardPage;

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

function SetSecurity() : string;
begin
  if QdbSecurityPage.Values[0] = True then
    Result := 'True'
  else
    Result := 'False'
end;

function GetSecurity() : boolean;
begin
  if GetPreviousData('SecurityEnabled', 'False') = 'False' then
    Result := False
  else
    Result := True
end;

function IsSecurityEnabled() : boolean;
begin
  Result := QdbSecurityPage.Values[0];
end;

function GetQdbSecurityOption(Param: string) : string;
begin
  if IsSecurityEnabled() = true then
    Result := '--security=true' 
  else
    Result := '--security=false'
end;

function DashboardUrl() : string;
begin
  if IsSecurityEnabled() = true then
    Result := 'https://localhost:40443'
  else
    Result := 'http://localhost:40080/#anonymous'
end;

function QdbDashboardInfoText() : string;
var
  Text: String;
begin
  Text := 'You are now able to access the dashboard '
  if IsSecurityEnabled() = true then
    Text := Text + 'with your user secret information';
  Text := Text + ' at ' + DashboardUrl();
  Result := Text
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := False;
  if PageID = AddUserPageID then
    Result := not IsSecurityEnabled();
end;

procedure InitializeWizard;
begin
  QdbLicensePage := CreateInputFilePage(wpSelectDir, 'License file', 'Do you have a license file?', 'Select a quasardb license file. Leave the box empty for Community Edition.');
  QdbLicensePage.Add('Location of quasardb license:', 'Text files|*.txt|All files|*.*', '.txt');
  
  QdbDirPage := CreateInputDirPage(wpSelectDir, 'Data directories', 'Where to store quasardb files?', 'Select the directories in which quasardb data will be stored, then click Next.', False, 'New Folder');
  QdbDirPage.Add('Database files');
  QdbDirPage.Add('Log files');

  QdbAddUserPage := CreateInputQueryPage(wpSelectDir, 'Add user', 'Would you like to add a user?', 'Please specify the name of the user you would like to add.');
  QdbAddUserPage.Add('Name', False);
  AddUserPageID := QdbAddUserPage.ID;

  QdbSecurityPage := CreateInputOptionPage(wpSelectDir, 'Security', 'Do you want to enable security?', 'If you want to enable security, please check the box below, then click Next.', False, False)
  QdbSecurityPage.Add('Enable security')
  QdbSecurityPageID := QdbSecurityPage.ID;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  SetPreviousData(PreviousDataKey, 'DbDir', QdbDirPage.Values[0]);
  SetPreviousData(PreviousDataKey, 'LogDir', QdbDirPage.Values[1]);
  SetPreviousData(PreviousDataKey, 'LicenseFile', GetQdbLicenseFileDestination(''));
  SetPreviousData(PreviousDataKey, 'SecurityEnabled', SetSecurity());
  SetPreviousData(PreviousDataKey, 'Username', QdbAddUserPage.Values[0]);
end;

function NextButtonClick(CurPageID: Integer): boolean;
begin
  if CurPageID = wpSelectDir then
  begin
    QdbLicensePage.Values[0] := GetPreviousData('LicenseFile', '');
    QdbDirPage.Values[0] := GetPreviousData('DbDir', ExpandConstant('{app}\db'));
    QdbDirPage.Values[1] := GetPreviousData('LogDir', ExpandConstant('{app}\log'));
    QdbSecurityPage.Values[0] := GetSecurity();
    QdbAddUserPage.Values[0] := GetPreviousData('Username', ExpandConstant('{username}'));
  end;

  if CurPageID = QdbSecurityPageID then
  begin
    {We create this page here because the text depends on wether or not the security is enabled}

    QdbDashboardInfoPage := CreateOutputMsgMemoPage(wpInfoAfter,
      'Information', 'Please read the following important information before continuing.',
      'When you are ready to finish with Setup, click Next.',
      QdbDashboardInfoText());
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

function ReplaceValue(const FileName, TagName, TagValue, Comma: string): Boolean;
var
  I: Integer;
  Tag: string;
  Line: string;
  TagPos: Integer;
  FileLines: TStringList;
begin
  StringChangeEx(TagValue, '\', '/', True);
  Result := False;
  FileLines := TStringList.Create;
  try
    Tag := '"' + TagName + '"';
    FileLines.LoadFromFile(FileName);
    for I := 0 to FileLines.Count - 1 do
    begin
      Line := FileLines[I];
      TagPos := Pos(Tag, Line);
      if TagPos > 0 then
      begin
        Result := True;
        Delete(Line, TagPos, MaxInt);
        Line := Line + '"' + TagName + '": "' + TagValue + '"' + Comma;
        FileLines[I] := Line;
        FileLines.SaveToFile(FileName);
        Break;
      end;
    end;
  finally
    FileLines.Free;
  end;
end;

procedure ConfigureQdbdDefault(FileName: String);
begin
  if IsSecurityEnabled() = true then
  begin
    ReplaceValue(FileName, 'cluster_private_file', ExpandConstant('{app}\conf\cluster_private.key'), ',')
    ReplaceValue(FileName, 'user_list', ExpandConstant('{app}\conf\users.conf'), ' ')
  end
  else
  begin
    ReplaceValue(FileName, 'cluster_private_file', '', ',')
    ReplaceValue(FileName, 'user_list', '', ' ')
  end;
end;


procedure ConfigureQdbRestDefault(FileName: String);
begin
  if IsSecurityEnabled() = true then
  begin
    ReplaceValue(FileName, 'cluster_public_key_file', ExpandConstant('{app}\share\qdb\cluster_public.key'), ',')
  end
  else
  begin
      ReplaceValue(FileName, 'cluster_public_key_file', '', ',')
  end;
  ReplaceValue(FileName, 'tls_certificate', ExpandConstant('{app}\conf\qdb_rest.cert.pem'), ',')
  ReplaceValue(FileName, 'tls_key', ExpandConstant('{app}\conf\qdb_rest.key.pem'), ',')
  ReplaceValue(FileName, 'log', GetQdbDir('log') + '\qdb_rest.log', ',')
  ReplaceValue(FileName, 'assets', ExpandConstant('{app}\assets'), ' ')
end;

procedure AddUser(Username: String; uid: Integer);
var
  ResultCode: Integer;
  ConfDir: String;
  UsersFile: String;
  UserPrivateKeyFile: String;
  Params: String;
begin
  ConfDir :=  ExpandConstant('{app}\conf\');
  UsersFile := '"' + ConfDir + 'users.conf"';
  UserPrivateKeyFile := '"' + ConfDir + Username + '_private.key"';
  Params := '-u ' + Username + ' --uid=' + IntToStr(uid) + ' --superuser=0 --privileges=16894 -p ' + UsersFile + ' -s ' + UserPrivateKeyFile;
  Exec(ExpandConstant('{app}\bin\qdb_user_add.exe'), Params, '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
end;

procedure AddUsers();
begin
  if IsSecurityEnabled() = true then
  begin
    AddUser('qdbsh', 3);
    AddUser(QdbAddUserPage.Values[0], 10);
  end;
end;