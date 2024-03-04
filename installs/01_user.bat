@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

@IF NOT EXIST "%LOCALAPPDATA%\lboulard\logs\."^
 MD "%LOCALAPPDATA%\lboulard\logs"
@IF ERRORLEVEL 1 GOTO :exit

CALL .\02_JetBrains-ToolBox.bat
@IF ERRORLEVEL 1 GOTO :exit

CALL .\02_PowerToys.bat
@IF ERRORLEVEL 1 GOTO :exit

::CALL .\02_MikTex.bat
::@IF ERRORLEVEL 1 GOTO :exit

CALL .\10_affinity_serif.bat
@IF ERRORLEVEL 1 GOTO :exit

CALL .\10_Ruby2x.bat
@IF ERRORLEVEL 1 GOTO :exit

CALL .\10_Ruby3x.bat
@IF ERRORLEVEL 1 GOTO :exit


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@IF ERRORLEVEL 1 @ECHO Failure ERRORLEVEL=%ERRORLEVEL%
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
