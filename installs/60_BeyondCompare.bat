@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0..\BeyondCompare"
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
@FOR %%f IN ("BCompare-4.*.exe") DO @SET "PRG=%%~f"
@ECHO SET PRG=%PRG%
@IF NOT DEFINED PRG (
ECHO ** ERROR: No installation program found
GOTO :exit
)

@IF NOT EXIST "%LOCALAPPDATA%\lboulard\logs\."^
 MD "%LOCALAPPDATA%\lboulard\logs"
@IF ERRORLEVEL 1 GOTO :exit

:: license key shall be in BC4Key.txt
".\%PRG%" /SP- /VERYSILENT /NORESTART^
 /LOG="%LOCALAPPDATA%\lboulard\logs\BCompare4-Install.log"

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
