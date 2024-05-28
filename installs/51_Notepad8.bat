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

CD /D "%ROOT_NOTEPAD_PP%"
@IF ERRORLEVEL 1 GOTO :exit

@SET INSTALLER=
@SET VERSION=notfound
@FOR %%f IN ("npp.8.*.installer.x64.exe") DO @(
  FOR /F "tokens=2-4 delims=." %%i IN ("%%f") DO @CALL :version "%%i" "%%j" "%%k" "%%f"
)
@ECHO/INSTALLER=%INSTALLER%
@ECHO/VERSION=%VERSION%
@IF %VERSION%==notfound @(
  @ECHO ** ERROR: installer not found
  @CALL :errorlevel 64
  @GOTO :exit
)

"%INSTALLER%" /S /noUpdater
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

@:version
@SET "X=000000000%~1"
@SET "Y=000000000%~2"
@SET "Z=000000000%~3"
@SET "__VERSION=%X:~-8%.%Y:~-8%.%Z:~-8%"
@IF %VERSION%==notfound GOTO :update
@IF %__VERSION% GTR %_VERSION% GOTO :update
@GOTO :EOF

@:update
@SET "_VERSION=%__VERSION%"
@SET "VERSION=%~1.%~2.%~3"
@SET "INSTALLER=%~4"
@GOTO :EOF

:errorlevel
@EXIT /B %~1
