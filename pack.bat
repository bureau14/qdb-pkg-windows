@setlocal enabledelayedexpansion

@set SIGNTOOL=C:\Program Files (x86)\Windows Kits\8.1\bin\x86\signtool.exe
@set CERTIFICATE_SHA1=AD1DCC5C75A87AECED3CD9FDE119467B4110E172

@for /f "tokens=2 delims=-" %%i  in ('dir /b %1') do @set VERSION=%%i

@echo %~n1 | @findstr 64bit
@if %ERRORLEVEL%==0 (
    @set IS64BIT=1
    @set SETUP=qdb-%VERSION%-windows-64bit-setup
) else (
    @set IS64BIT=0
    @set SETUP=qdb-%VERSION%-windows-32bit-setup
)

@set PATH=%PATH%;C:\Program Files (x86)\Inno Setup 5;C:\Program Files\7-zip

@rmdir /S /Q qdb
@for %%x in (%*) do (
    7z x -oqdb "%%~fx"
)

iscc qdb-server.iss ^
    /dQdbSetupBaseName=%SETUP% ^
    /dQdbVersion=%VERSION% ^
    /dQdbIs64bit=%IS64BIT% ^
    /dQdbOutputDir=qdb ^
    /sStandard="%SIGNTOOL% sign /sha1 %CERTIFICATE_SHA1% $p"
