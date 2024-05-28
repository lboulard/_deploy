@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit

:: check if admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% NEQ 0 (
  @SET _ELEV=1
  @Powershell.exe "start cmd.exe -arg '/c """%~0"""' -verb runas" && GOTO :exit
  @ECHO This script needs admin rights.
  @ECHO To do so, right click on this script and select 'Run as administrator'.
  @CALL :errorlevel 128
  @GOTO :exit
)

@IF NOT EXIST "%LOCALAPPDATA%\lboulard\logs\."^
 MD "%LOCALAPPDATA%\lboulard\logs"

:: https://jrsoftware.org/ishelp/index.php?topic=setupcmdline

CD /D "%ROOT_WINCOMPOSE%"
@IF ERRORLEVEL 1 GOTO :exit

.\WinCompose-Setup-0.9.11.exe /SP- /SILENT /NORESTART /SUPPRESSMSGBOXES^
 /ALLUSERS /LOG="%LOCALAPPDATA%\lboulard\logs\WinCompose.log"
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

:errorlevel
@EXIT /B %~1
