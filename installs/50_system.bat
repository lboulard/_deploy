@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF  ERRORLEVEL 1 GOTO :exit

:: check if admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% NEQ 0 (
  @SET _ELEV=1
  @Powershell.exe "start cmd.exe -arg '/c """%~0"""' -verb runas" && GOTO :exit
  @ECHO This script needs admin rights.
  @ECHO To do so, right click on this script and select 'Run as administrator'.
  @GOTO :exit
)

:: 50 :: tools, editors (survival kit)

CALL .\51_7Zip-STD.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\51_Notepad8.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\51_WinCompose.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\51_Vivaldi.bat
@IF  ERRORLEVEL 1 GOTO :exit


:: 60 :: extras

CALL .\60_BeyondCompare.bat
@IF  ERRORLEVEL 1 GOTO :exit


:: 70 :: players, graphics, design

CALL .\70_IrfanView.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\70_SumatraPDF.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\70_VLC.bat
@IF  ERRORLEVEL 1 GOTO :exit


:: 80 :: development

CALL .\80_Git_all.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\80_Golang.bat
@IF  ERRORLEVEL 1 GOTO :exit

CALL .\80_python3x.bat
@IF  ERRORLEVEL 1 GOTO :exit

:: requires reboot even with reboot disabled after install
::CALL .\80_VmwareWorkstation.bat
::@IF  ERRORLEVEL 1 GOTO :exit

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
