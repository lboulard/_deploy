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

CD /D "%ROOT_IRFANVIEW%"
@IF ERRORLEVEL 1 GOTO :exit

:: <https://www.irfanview.com/faq.htm#PAGE12>
.\iview466_x64_setup.exe /silent^
 /desktop=0^
 /thumbs=0^
 /group=1^
 /allusers=0^
 /assoc=1
@IF ERRORLEVEL 1 GOTO :exit

.\iview466_plugins_x64_setup.exe /silent

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
