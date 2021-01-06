#ifndef QdbIs64bit
#error "QdbIs64bit should be defined"
#endif

#ifndef QdbVersion
#error "QdbVersion should be defined"
#endif

#ifndef QdbODBCSetupBaseName
#if QdbIs64bit == "1"
#define QdbODBCSetupBaseName "qdb-odbc-driver-windows-64bit-setup"
#else
#define QdbODBCSetupBaseName "qdb-odbc-driver-windows-32bit-setup"
#endif
#endif

#ifndef QdbOutputDir
#define QdbOutputDir "qdb"
#endif

#if QdbIs64bit == "1"
#define MyAppName "quasardb odbc driver 64-bit"
#else
#define MyAppName "quasardb odbc driver 32-bit"
#endif

#define MyAppPublisher "quasardb SAS"
#define MyAppURL "https://www.quasardb.net/"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
;AppVerName={#MyAppName} {#QdbVersion}
AppCopyright=Copyright (c) 2009-2021, quasardb SAS. All rights reserved.
AppId={{22515D93-7879-4E9C-B5C6-21823F3288CB}
AppName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppVersion={#QdbVersion}
Compression=lzma
DefaultDirName={pf}\quasardb_odbc
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


[Files]
Source: "{#QdbOutputDir}\bin\qdb_api.dll";              DestDir: "{sys}";         Flags: ignoreversion;
Source: "{#QdbOutputDir}\bin\qdb_odbc_driver.dll";      DestDir: "{app}\bin";     Flags: ignoreversion;
Source: "{#QdbOutputDir}\bin\qdb_odbc_installer.exe";   DestDir: "{app}\bin";     Flags: ignoreversion;
Source: "{#QdbOutputDir}\share\doc\qdb\*";              DestDir: "{app}\doc";     Flags: recursesubdirs;

[Run]
StatusMsg: "Install ODBC driver";   Filename: "{app}\bin\qdb_odbc_installer.exe"; Parameters: "--install qdb_odbc_driver ""{app}\bin\qdb_odbc_driver.dll"" "; Flags: runascurrentuser runhidden

[UninstallRun]
StatusMsg: "Remove ODBC driver";    Filename: "{app}\bin\qdb_odbc_installer.exe"; Parameters: "--remove qdb_odbc_driver"; Flags: runascurrentuser runhidden
