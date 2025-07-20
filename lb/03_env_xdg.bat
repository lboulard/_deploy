@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO.**FAILURE this script shall run as current user.
  @SET ERR=2
  @GOTO :exit
)

@IF NOT DEFINED XDG_ROOT SET "XDG_ROOT=%LBHOME%"
@IF NOT DEFINED XDG_ROOT (
  @ECHO.**ERROR XDG_ROOT cannot be defined
  @SET ERR=1
  @GOTO :exit
)

@TYPE NUL>NUL
@IF NOT EXIST "%XDG_ROOT%\." MD "%XDG_ROOT%"
@IF NOT EXIST "%XDG_ROOT%\.cache\." MD "%XDG_ROOT%\.cache"
@IF NOT EXIST "%XDG_ROOT%\.local\share\." MD "%XDG%_ROOT\.local\share"
@IF NOT EXIST "%XDG_ROOT%\.config\." MD "%XDG%_ROOT\.config"
@IF ERRORLEVEL 1 (
 ECHO Failure ERRORLEVEL=%ERRORLEVEL%
 GOTO :exit
)

SETX XDG_CACHE_DIR	"%XDG_ROOT%\.cache"
SETX XDG_CACHE_HOME	"%XDG_ROOT%\.cache"
SETX XDG_CONFIG_HOME	"%XDG_ROOT%\.config"
SETX XDG_DATA_HOME	"%XDG_ROOT%\.local\share"
@IF ERRORLEVEL 1 (
 ECHO Failure ERRORLEVEL=%ERRORLEVEL%
 GOTO :exit
)

@CALL :mklink .cache
@CALL :mklink .config
@CALL :mklink .local

@:: Pause if not interactive
@:exit
@IF NOT DEFINED ERR SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:mklink
@IF EXIST "%USERPROFILE%\%~1" (
  @ECHO.# %USERPROFILE%\%~1 already exists
  @GOTO :EOF
)
MKLINK /D "%USERPROFILE%\%~1"  "%XDG_ROOT%\%~1"
@GOTO :EOF

:errorlevel
@EXIT /B %~1
