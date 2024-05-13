@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_VMWARE%"
@IF ERRORLEVEL 1 GOTO :exit

:: check if admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% NEQ 0 (
  @SET _ELEV=1
  @Powershell.exe "start cmd.exe -arg '/c """%~0"""' -verb runas" && GOTO :exit
  @ECHO This script needs admin rights.
  @ECHO To do so, right click on this script and select 'Run as administrator'.
  @GOTO :exit
)

@SET PRG=
@FOR %%f IN ("VMware-workstation-full-*.exe") DO @SET "PRG=%%~f"
@ECHO SET PRG=%PRG%
@IF NOT DEFINED PRG (
SET ERRORLEVEL=128
ECHO ** ERROR: No installation program found
GOTO :exit
)

".\%PRG%" /s /v/qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=1^
 ADDLOCAL=ALL REBOOT=ReallySuppres
@IF ERRORLEVEL 1 GOTO :exit

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
