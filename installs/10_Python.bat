@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0..\dev\python"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

IF NOT EXIST "%LOCALAPPDATA%\py.ini" (
  COPY "py.ini" "%LOCALAPPDATA%\py.ini"
)

CALL "%~dp0\50_Python_Install.bat"

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
