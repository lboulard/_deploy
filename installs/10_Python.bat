@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_PYTHON%"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

@ECHO OFF

IF NOT EXIST "%LOCALAPPDATA%\py.ini" @(
  ECHO.COPY "py.ini" "%LOCALAPPDATA%\py.ini"
  COPY "py.ini" "%LOCALAPPDATA%\py.ini"
  IF ERRORLEVEL 1 GOTO :exit
)

IF EXIST "pip.ini" (
  IF NOT EXIST "%APPDATA%\pip\pip.ini" @(
    IF NOT EXIST "%APPDATA%\pip\." MKDIR "%APPDATA%\pip"
    ECHO.COPY "pip.ini" "%APPDATA%\pip\pip.ini"
    COPY "pip.ini" "%APPDATA%\pip\pip.ini"
    IF ERRORLEVEL 1 GOTO :exit
  )
)

@ECHO ON

:: reset ERRORLEVEL to 0
@type nul

:: Let user do system install
::CALL "%~dp0\80_Python3x.bat"

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF ERRORLEVEL 1 @ECHO Failure ERRORLEVEL=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
