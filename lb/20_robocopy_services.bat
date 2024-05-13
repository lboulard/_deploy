@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit
@CALL ".\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

@IF NOT DEFINED LBHOME (
  @ECHO Missing LBHOME environment variable
  @CALL :errorlevel 1
  @GOTO :exit
)

@CALL :normalize "%ROOT_LB%"
@SET "SRCD=%RETVAL%"
@CALL :normalize "%LBHOME%"
@SET "DEST=%RETVAL%"
@IF "%SRCD%" == "%DEST%" (
 @ECHO Cannot copy on same path ^("%SRCD%" == "%DEST%"^)
 @CALL :errorlevel 128
 @GOTO :exit
)


robocopy.exe "%SRCD%\Services" "%DEST%\Services"^
 /E /XJ /J /COMPRESS /R:5 /NJH

@IF ERRORLEVEL 8 ECHO Failure ERRORLEVEL=%ERRORLEVEL%


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1

@:normalize
@SET RETVAL=%~f1
@GOTO :EOF