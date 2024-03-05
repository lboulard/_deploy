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

@IF NOT EXIST "%LOCALAPPDATA%\xdg\." MD "%LOCALAPPDATA%\xdg"
@IF NOT EXIST "%LOCALAPPDATA%\xdg\cache\." MD "%LOCALAPPDATA%\xdg\cache"
@IF NOT EXIST "%LOCALAPPDATA%\xdg\share\." MD "%LOCALAPPDATA%\xdg\share"
@IF NOT EXIST "%LOCALAPPDATA%\xdg\config\." MD "%LOCALAPPDATA%\xdg\config"
@IF ERRORLEVEL 1 (
 ECHO Failure ERRORLEVEL=%ERRORLEVEL%
 GOTO :exit
)

SETX XDG_CACHE_DIR	"%%LOCALAPPDATA%%\xdg\cache"
SETX XDG_CONFIG_HOME	"%%LOCALAPPDATA%%\xdg\config"
SETX XDG_DATA_HOME	"%%LOCALAPPDATA%%\xdg\share"
@IF ERRORLEVEL 1 (
 ECHO Failure ERRORLEVEL=%ERRORLEVEL%
 GOTO :exit
)

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
