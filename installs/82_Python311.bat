@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0..\dev\Python3.11"
@IF  ERRORLEVEL 1 GOTO :exit

@SET PYVER=
@FOR /D %%f IN ("python-3.11.*-amd64") DO @SET "PYVER=%%~f"
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
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%
