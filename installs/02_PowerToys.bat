@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_POWERTOYS%"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

@SET PRG=
@FOR %%f IN ("PowerToysUserSetup-*-x64.exe") DO @SET "PRG=%%~f"
@ECHO SET PRG=%PRG%
@IF NOT DEFINED PRG (
ECHO ** ERROR: No installation program found
SET ERRORLEVEL=64
GOTO :exit
)

".\%PRG%" /install /quiet /norestart

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
