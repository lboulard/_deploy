@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @CALL :errorlevel 128
  @GOTO :exit
)

@:: https://doc.qt.io/qt-5/highdpi.html

@:: Remove those entry does not trigger reloading by explorer
@ECHO Removing QT_AUTO_SCREEN_SCALE_FACTOR ...
@REG>NUL 2>&1 delete HKCU\Environment /F /V QT_AUTO_SCREEN_SCALE_FACTOR
@ECHO Removing QT_ENABLE_HIGHDPI_SCALING ...
@REG>NUL 2>&1 delete HKCU\Environment /F /V QT_ENABLE_HIGHDPI_SCALING
@ECHO Removing QT_FONT_DPI ...
@REG>NUL 2>&1 delete HKCU\Environment /F /V QT_FONT_DPI
@ECHO Removing QT_SCALE_FACTOR ...
@REG>NUL 2>&1 delete HKCU\Environment /F /V QT_SCALE_FACTOR

SETX	QT_AUTO_SCREEN_SCALE_FACTOR	0
@::SETX	QT_ENABLE_HIGHDPI_SCALING	1
@:: value 144 trigger jump in font size
@::SETX	QT_FONT_DPI			144
@::SETX	QT_SCALE_FACTOR 		1


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@TYPE NUL>NUL
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@ENDLOCAL&EXIT /B %ERR%

:errorlevel
@EXIT /B %~1
