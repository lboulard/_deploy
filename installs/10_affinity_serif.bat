@SETLOCAL
@CD /D "%~dp0..\graphics\affinity\2.3"
@IF  ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

@IF NOT EXIST "%LOCALAPPDATA%\lboulard\logs\."^
 MD "%LOCALAPPDATA%\lboulard\logs"

Powershell.exe -NoProfile "Add-AppxPackage -Path affinity-photo-2.3.0.msix"
Powershell.exe -NoProfile "Add-AppxPackage -Path affinity-designer-2.3.0.msix"
Powershell.exe -NoProfile "Add-AppxPackage -Path affinity-publisher-2.3.0.msix"

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
