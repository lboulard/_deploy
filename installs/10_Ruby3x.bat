@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_RUBY3%"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 @(
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)


@SET RBINST=
@FOR %%f IN ("rubyinstaller-3.*-x64.exe") DO @SET "RBINST=%%~f"
@ECHO SET RBINST=%RBINST%
@IF NOT DEFINED RBINST @(
  @ECHO ** ERROR: No Ruby installation program found
  @CALL :errorlevel 64
  @GOTO :exit
)

@IF NOT EXIST "%LOCALAPPDATA%\lboulard\logs\."^
 MD "%LOCALAPPDATA%\lboulard\logs"
@::IF ERRORLEVEL 1 GOTO :exit

@SET "RBVER=Ruby3%RBINST:~16,1%"
@SET "DEST=%LBHOME%\%RBVER%-x64"

".\%RBINST%" /SILENT /CURRENTUSER ^
 /TASKS="modpath,assocfiles,noridkinstall,defaultutf8"^
 /LOG="%LOCALAPPDATA%\lboulard\logs\%RBVER%-Install.log"^
 /COMPONENTS=ruby,rdoc^
 /DIR="%DEST%"


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF ERRORLEVEL 1 @ECHO Failure ERRORLEVEL=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
