@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_MSYS2%"
@IF ERRORLEVEL 1 GOTO :exit


:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 @(
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

@SET PRG=
@FOR %%f IN ("msys2-x86_64-*.exe") DO @SET "PRG=%%~f"
@ECHO SET PRG=%PRG%
@IF NOT DEFINED PRG @(
  @ECHO ** ERROR: No installation program found
  @CALL :errorlevel 64
  @GOTO :exit
)

@SET DEST=C:/msys64
@IF EXIST C:\DEV\. @SET DEST=C:/DEV/msys64

@IF "%1"=="uninstall" @GOTO :uninstall

".\%PRG%" in --confirm-command --accept-messages --root %DEST%

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@IF ERRORLEVEL 1 @ECHO Failure ERRORLEVEL=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1

@:uninstall
%DEST:/=\%\uninstall.exe pr --confirm-command
