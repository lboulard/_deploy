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


SETX FZF_ALT_C_COMMAND	"fd -t d"
SETX FZF_CTRL_R_OPTS	"+s -e"
SETX FZF_CTRL_T_COMMAND	"fd -t f"
SETX FZF_DEFAULT_OPTS 	"--layout=reverse --info=inline"


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
