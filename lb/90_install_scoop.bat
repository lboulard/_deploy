@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit
@CALL ".\00_config.bat"
@IF ERRORLEVEL 1 GOTO :exit

WHERE scoop >NUL 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO ALREADY INSTALLED
  @GOTO :exit
)

Powershell.exe -NoProfile "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser"
@IF ERRORLEVEL 1 GOTO :exit

@IF EXIST "%TEMP%\install_scoop.ps1" GOTO :install

Powershell.exe -NoProfile "irm get.scoop.sh -outfile '%TEMP%/install_scoop.ps1'"
@IF ERRORLEVEL 1 GOTO :exit

@:install
PowerShell.exe -NoProfile^
 "%TEMP%\install_scoop.ps1 -ScoopDir '%LBHOME%\Scoop' -ScoopGlobalDir '%LBHOME%\GlobalScoopApps'"
@IF ERRORLEVEL 1 GOTO :exit

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%
