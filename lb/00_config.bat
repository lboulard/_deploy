@CALL :absolute ROOT "%~dp0..\.."
@ECHO OFF

:: user global private install

IF EXIST "%ROOT%\deploy_config.bat" CALL "%ROOT%\deploy_config.bat"
IF EXIST "%LOCALAPPDATA%\deploy_config.bat" CALL "%LOCALAPPDATA%\deploy_config.bat"

:: default  values, overrides in any deploy_config.bat
IF "%LBHOME%" == "" SET DEST=C:\lb
IF "%LBPROGRAMS%" == "" CALL :absolute LBPROGRAMS "%LBHOME%\Programs"
IF "%ROOT_LB%" == "" CALL :absolute ROOT_LB "%~dp0..\.."

@ECHO ON
@GOTO :EOF

@:absolute
@SET "%1=%~dpf2"
@GOTO :EOF
