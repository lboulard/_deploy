@SETLOCAL

reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Vim 9.1" "%~dp0Vim 9.1.reg"

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%