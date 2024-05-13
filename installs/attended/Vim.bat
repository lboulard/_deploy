@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0..\..\dev\editors\vim"
@IF  ERRORLEVEL 1 GOTO :exit

@SET GVIM=
@FOR %%f IN ("gvim-*-amd64.exe") DO @SET "GVIM=%%~f"
@ECHO SET GVIM=%GVIM%
@IF NOT DEFINED GVIM @(
  @ECHO ** ERROR: No Gvim installation program found
  @CALL :errorlevel 64
  @GOTO :exit
)

".\%GVIM%"


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
