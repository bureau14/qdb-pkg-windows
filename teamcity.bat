@setlocal enabledelayedexpansion

@for /f "tokens=2 delims=-" %%i  in ('dir /b %1') do @set VERSION=%%i

@echo %~n1 | @findstr 64bit
@if %ERRORLEVEL%==0 (
    @set IS64BIT=1
    @set SETUP=qdb-%VERSION%-windows-64bit-setup
) else (
    @set IS64BIT=0
    @set SETUP=qdb-%VERSION%-windows-32bit-setup
)

: STEP 1: unzip --------------------------------------------------------------

@echo ##teamcity[blockOpened name='unzip' description='Extract artifacts']

@rmdir /S /Q qdb
@for %%x in (%*) do (
    7z x -oqdb "%%~fx"
)

@echo ##teamcity[blockClosed name='unzip']

: STEP 2: compile ------------------------------------------------------------

@echo ##teamcity[blockOpened name='iscc' description='Inno Setup']

iscc qdb-server.iss ^
    /dQdbSetupBaseName=%SETUP% ^
    /dQdbVersion=%VERSION% ^
    /dQdbIs64bit=%IS64BIT% ^
    /dQdbOutputDir=qdb

@if %ERRORLEVEL% NEQ 0 (
    @echo ##teamcity[buildProblem description='Compilation failed']
    @exit /b 0
)

@echo ##teamcity[blockClosed name='iscc']

: STEP 3: sign  --------------------------------------------------------------


@echo ##teamcity[blockOpened name='sign' description='Sign executable']

@set DESCRIPTION="quasardb installer"
@set URL=https://www.quasardb.net/
@set THUMBPRINT=25B672BA5AD762CDD5F7EC58178D898CF74736C5

signtool sign /v /a /sha1 %THUMBPRINT% /du %URL% /d %DESCRIPTION% %SETUP%.exe

@if %ERRORLEVEL% NEQ 0 (
    @echo ##teamcity[buildProblem description='Signing failed']
    @exit /b 0
)

@echo ##teamcity[blockClosed name='sign']
