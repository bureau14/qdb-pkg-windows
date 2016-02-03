#ifndef QdbIs64bit
#define QdbIs64bit 1
#endif

#ifndef QdbVersion
#define QdbVersion "0.0.0"
#endif

#ifndef QdbSetupBaseName
#if QdbIs64bit
#define QdbSetupBaseName "qdb-windows-64bit-setup"
#else
#define QdbSetupBaseName "qdb-windows-32bit-setup"
#endif
#endif

#ifndef QdbOutputDir
#define QdbOutputDir "qdb"
#endif

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
; SignTool=Standard /a /du https://www.quasardb.net/ /d $qqdb qdbd installer$q $f"
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
Name: "{app}\conf"; Flags: uninsneveruninstall
Name: "{app}\log"; Flags: uninsneveruninstall
Name: "{app}\db"; Flags: uninsneveruninstall

[Types]
Name: full;   Description: "Full installation"
Name: server; Description: "Server installation"
Name: client; Description: "Client installation"
Name: custom; Description: "Custom installation"; Flags: iscustom

[Components]
Name: qdbd;  Description: "Server (qdbd)";          Types: full server;
Name: httpd; Description: "Web Bridge (qdb_httpd)"; Types: full server;
Name: utils; Description: "Utilities (qdbsh...)";   Types: full client;
Name: api;   Description: "C API (qdb_api.dll)";    Types: full client;

[Files]
Components: api;   Source: "{#QdbOutputDir}\bin\qdb_api.dll";           DestDir: "{sys}";                Flags: ignoreversion; 
Components: qdbd;  Source: "{#QdbOutputDir}\bin\qdb_dbtool.exe";        DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: qdbd;  Source: "{#QdbOutputDir}\bin\qdb_service.exe";       DestDir: "{app}\bin";            Flags: ignoreversion;
Components: qdbd;  Source: "{#QdbOutputDir}\bin\qdbd.exe";              DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: utils; Source: "{#QdbOutputDir}\bin\qdb_bench.exe";         DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: utils; Source: "{#QdbOutputDir}\bin\qdb_max_conn.exe";      DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: utils; Source: "{#QdbOutputDir}\bin\qdbsh.exe";             DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: httpd; Source: "{#QdbOutputDir}\bin\qdb_http_service.exe";  DestDir: "{app}\bin";            Flags: ignoreversion;
Components: httpd; Source: "{#QdbOutputDir}\bin\qdb_httpd.exe";         DestDir: "{app}\bin";            Flags: ignoreversion; 
Components: httpd; Source: "{#QdbOutputDir}\share\qdb\www\*";           DestDir: "{app}\share\qdb\www";  Flags: recursesubdirs;

Source: "{#SourcePath}\readme.txt";  DestDir: "{app}\doc"
Source: "{#SourcePath}\license.txt"; DestDir: "{app}\doc"

[Run]
Components: qdbd;  StatusMsg: "Install Server";       Filename: "{app}\bin\qdb_service.exe";      Parameters: "/install"; Flags: runascurrentuser runhidden
Components: httpd; StatusMsg: "Install Web Bridge";   Filename: "{app}\bin\qdb_http_service.exe"; Parameters: "/install"; Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Configure Server";     Filename: "{app}\bin\qdbd.exe";      Parameters: """--gen-config={app}\conf\qdbd.conf"" ""--log-file={app}\log\qdbd.log"" ""--log-dump={app}\log\qdbd_error_dump.txt"" ""--root={app}\db"""; Check: not FileExists(ExpandConstant('{app}\conf\qdbd.conf')); Flags: runascurrentuser runhidden
Components: httpd; StatusMsg: "Configure Web Bridge"; Filename: "{app}\bin\qdb_httpd.exe"; Parameters: """--gen-conf={app}\conf\qdb_httpd.conf"" ""--log-file={app}\log\qdb_httpd.log"" ""--log-dump={app}\log\qdb_httpd_error_dump.txt"" ""--root={app}\share\qdb\www"""; Check: not FileExists(ExpandConstant('{app}\conf\qdb_httpd.conf')); Flags: runascurrentuser runhidden

Components: qdbd;  StatusMsg: "Start Server";         Filename: "sc.exe"; Parameters: "start qdbd";      Flags: runhidden
Components: httpd; StatusMsg: "Start Web Bridge";     Filename: "sc.exe"; Parameters: "start qdb_httpd"; Flags: runhidden  

[UninstallRun]
Components: qdbd;  StatusMsg: "Stop Server";          Filename: "sc.exe"; Parameters: "stop qdbd";      Flags: runhidden
Components: httpd; StatusMsg: "Stop Web Bridge";      Filename: "sc.exe"; Parameters: "stop qdb_httpd"; Flags: runhidden  

Components: qdbd;  StatusMsg: "Remove Server";        Filename: "{app}\bin\qdb_service.exe";      Parameters: "/remove"; Flags: runascurrentuser runhidden
Components: httpd; StatusMsg: "Remove Web Bridge";    Filename: "{app}\bin\qdb_http_service.exe"; Parameters: "/remove"; Flags: runascurrentuser runhidden

[Registry]
Components: qdbd;  Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdbd";      ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdbd.conf"
Components: httpd; Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Services\qdb_httpd"; ValueType: string; ValueName: "ConfigFile"; ValueData: "{app}\conf\qdb_httpd.conf"

[Icons]
Components: utils;  Name: "{group}\quasardb shell"; Filename: "{app}\bin\qdbsh.exe"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

