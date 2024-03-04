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
  @GOTO :exit
)

@IF NOT DEFINED LBHOME (
 @ECHO Missing LBHOME environment variable
 @GOTO :exit
)

@CALL :normalize "%ROOT_LB%"
@SET "SRCD=%RETVAL%"
@CALL :normalize "%LBHOME%"
@SET "DEST=%RETVAL%"
@IF "%SRCD%" == "%DEST%" (
 @SET ERRORLEVEL=128
 @ECHO Cannot copy on same path ^("%SRCD%" == "%DEST%"^)
 @GOTO :exit
)


robocopy.exe "%SRCD%" "%DEST%"^
 /E /XJ /J /COMPRESS /R:5 /NJH /NFL /NC^
 XD Code Ruby*-x64 Scoop Services Vim *.vhdx qcom

@IF ERRORLEVEL 1 ECHO Failure ERRORLEVEL=%ERRORLEVEL%


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%


@:normalize
@SET RETVAL=%~f1
@GOTO :EOF