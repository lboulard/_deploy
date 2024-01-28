@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0.."
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

:: requires writable fodler to extract temporary files

@COPY /Z /V /Y Vivaldi.6.5.3206.57.x64.exe "%TEMP%\Vivaldi.exe"
@IF ERRORLEVEL 1 GOTO :exit

"%TEMP%\Vivaldi.exe" --vivaldi-silent --do-not-launch-chrome

@IF %ERRORLEVEL% EQU 0 (
 DEL /F "%TEMP%\Vivaldi.exe"
 GOTO :exit
)
@ECHO Install failed ERRORLEVEL=%ERRORLEVEL%

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
