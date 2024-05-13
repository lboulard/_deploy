@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF  ERRORLEVEL 1 GOTO :exit

:: check if not admin
@TYPE NUL>NUL
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

CALL .\81_Python39.bat
@IF  ERRORLEVEL 1 GOTO :exit
CALL .\82_Python310.bat
@IF  ERRORLEVEL 1 GOTO :exit
CALL .\82_Python311.bat
@IF  ERRORLEVEL 1 GOTO :exit
CALL .\82_Python312.bat
@IF  ERRORLEVEL 1 GOTO :exit

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

:errorlevel
@EXIT /B %~1
