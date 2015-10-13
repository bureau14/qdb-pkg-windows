; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#if QdbIs64bit
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
AppCopyright=Copyright (C) 2009-2015 quasardb SAS
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
LicenseFile=license.txt
OutputBaseFilename={#QdbSetupBaseName}
OutputDir=.
SignTool=Standard /a /du https://www.quasardb.net/ /d $qqdb server installer$q $f"
SolidCompression=yes
WizardImageFile=WizardImage.bmp
WizardSmallImageFile=WizardSmallImage.bmp

#if QdbIs64bit
ArchitecturesInstallIn64BitMode=x64
ArchitecturesAllowed=x64
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Dirs]
Name: "{app}"; Permissions: everyone-modify

[Dirs]
Name: "{app}\conf"; Flags: uninsneveruninstall
Name: "{app}\log"; Flags: uninsneveruninstall
Name: "{app}\db"; Flags: uninsneveruninstall

[Files]
Source: "{#QdbOutputDir}\bin\qdbd.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_service.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_bench.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_httpd.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_http_service.exe"; DestDir: "{app}\bin"; Flags: ignoreversion;
Source: "{#QdbOutputDir}\bin\qdbsh.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_max_conn.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_dbtool.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_api.dll"; DestDir: "{app}\bin"; Flags: ignoreversion; 
Source: "{#QdbOutputDir}\bin\qdb_generate_config.exe"; DestDir: "{app}\bin"; Flags: ignoreversion; 

Source: "readme.txt"; DestDir: "{app}\doc"; Flags: isreadme
Source: "license.txt"; DestDir: "{app}\doc"
Source: "{#QdbOutputDir}\bin\html\*"; DestDir: "{app}\bin\console"; Flags: recursesubdirs

[Run]
; install services
Filename: "{app}\bin\qdb_service.exe"; Parameters: "/install"; Description: "install quasardb daemon service"; Flags: runascurrentuser runhidden
Filename: "{app}\bin\qdb_http_service.exe"; Parameters: "/install"; Description: "install quasardb web service"; Flags: runascurrentuser runhidden

; generate configuration files for qdb daemon and qdb web bridge
Filename: "{app}\bin\qdb_generate_config.exe"; Parameters: """{app}\conf"" ""{app}\log"" ""{app}\db"" ""{app}\bin\console"""; Description: "generating quasardb configuration files"; Flags: runascurrentuser runhidden

Filename: "sc.exe"; Parameters: "start qdbd" ; Flags: runhidden
Filename: "sc.exe"; Parameters: "start qdb_httpd" ; Flags: runhidden  

[UninstallRun]
Filename: "sc.exe"; Parameters: "stop qdbd" ; Flags: runhidden
Filename: "sc.exe"; Parameters: "stop qdb_httpd" ; Flags: runhidden  

Filename: "{app}\bin\qdb_service.exe"; Parameters: "/remove"; Flags: runascurrentuser runhidden
Filename: "{app}\bin\qdb_http_service.exe"; Parameters: "/remove"; Flags: runascurrentuser runhidden

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdbd"; ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdbd.conf"
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdb_httpd"; ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdb_httpd.conf"

[Icons]
Name: "{group}\quasardb shell"; Filename: "{app}\bin\qdbsh.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

