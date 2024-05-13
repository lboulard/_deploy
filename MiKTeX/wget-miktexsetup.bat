@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

@SET POWERSHELL=PowerShell.exe
@where /q pwsh.exe
@IF %ERRORLEVEL% equ 0 SET POWERSHELL=pwsh.exe

%POWERSHELL% -NoProfile -Command^
 "irm https://miktex.org/download/win/miktexsetup-x64.zip -outfile $env:TEMP/miktexsetup-x64.zip"
@IF ERRORLEVEL 1 GOTO :exit

%POWERSHELL% -NoProfile -Ex Unrestricted -Command^
 "Expand-Archive -LiteralPath $env:TEMP/miktexsetup-x64.zip -DestinationPath . -Verbose -Force"
@IF ERRORLEVEL 1 GOTO :exit

@DEL /S "%TEMP%\miktexsetup-x64.zip"


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
