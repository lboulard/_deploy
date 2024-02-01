@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit

SET DEST=C:\lb

:: D:PAI(A;OICI;FA;;;BA)(A;OICI;FA;;;SY)(A;OICI;FA;;;S-1-5-21-3162883210-3459996465-1035011846-1001)
IF NOT EXIST %DEST%\. MD %DEST%

icacls %DEST% /grant:r lboulard:(OI)(CI)(NP)F /inheritancelevel:r ^
 /grant:r Administrators:(OI)(CI)(NP)F^
 /grant:r SYSTEM:(OI)(CI)(NP)F^
 /remove "Users"  /remove "Authenticated Users"
icacls %DEST% /setowner lboulard

@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%
