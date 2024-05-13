@SETLOCAL
@CHCP 65001 >NUL:
@CALL "%~dp0\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit
@CD /D "%ROOT_PYTHON312%"
@IF ERRORLEVEL 1 GOTO :exit

@SET PYVER=
@FOR /D %%f IN ("python-3.12.*-amd64") DO @SET "PYVER=%%~f"
@ECHO SET PYVER=%PYVER%
@IF NOT DEFINED PYVER (
ECHO ** ERROR: No Python installation program found
SET ERRORLEVEL=64
GOTO :exit
)

CD "%PYVER%"
CALL .\python-silent-install.bat"

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
