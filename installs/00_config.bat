@CALL :absolute ROOT "%~dp0..\.."
@ECHO OFF

SET ROOT_7ZIP="%ROOT%\7-zip"
SET ROOT_AFFINITY="%ROOT%\graphics\affinity"
SET ROOT_BEYONDCOMPARE="%ROOT%\BeyondCompare"
SET ROOT_IRFANVIEW="%ROOT%\graphics"
SET ROOT_JETBRAINS="%ROOT%\dev\JetBrains"
SET ROOT_NOTEPAD_PP="%ROOT%\dev\editors"
SET ROOT_POTPLAYER="%ROOT%\players\PotPlayer"
SET ROOT_POWERTOYS="%ROOT%\shell\PowerToys"
SET ROOT_SUMATRAPDF="%ROOT%\players"
SET ROOT_VIVALDI="%ROOT%"
SET ROOT_VLC="%ROOT%\players\VLC"
SET ROOT_WINCOMPOSE="%ROOT%\keyboard"

SET ROOT_GIT="%ROOT%\dev\git"
SET ROOT_GOLANG="%ROOT%\dev\go"
SET ROOT_VMWARE="%ROOT%\dev\VMWare"
SET ROOT_MSYS2="%ROOT%\dev\msys2"

SET ROOT_PYTHON="%ROOT%\dev\python"
SET ROOT_PYTHON39="%ROOT%\dev\Python3.9"
SET ROOT_PYTHON310="%ROOT%\dev\Python3.10"
SET ROOT_PYTHON311="%ROOT%\dev\Python3.11"
SET ROOT_PYTHON312="%ROOT%\dev\Python3.12"

SET ROOT_RUBY3="%ROOT%\dev\ruby"
SET ROOT_RUBY2="%ROOT%\dev\ruby"

IF EXIST "%ROOT%\deploy_config.bat" CALL "%ROOT%\deploy_config.bat"
IF EXIST "%LOCALAPPDATA%\deploy_config.bat" CALL "%LOCALAPPDATA%\deploy_config.bat"
@ECHO ON
@GOTO :EOF

@:absolute
@SET "%1=%~dpf2"
@GOTO :EOF
