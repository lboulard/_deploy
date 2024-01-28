@SETLOCAL
@CHCP 65001 >NUL:
@CD /D "%~dp0"
@IF  ERRORLEVEL 1 GOTO :exit

:: check if not admin
@fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
@IF %ERRORLEVEL% EQU 0 (
  @ECHO This script shall run as current user.
  @GOTO :exit
)

SETX LBHOME 	C:\lb
SETX LBPROGRAMS C:\lb\Programs

SETX BAT_PAGER none
SETX LESS -FRSX
SETX EDITOR "%%LBHOME%%\Vim\Vim91\gvim.exe"

SETX FZF_ALT_C_COMMAND	"fd -t d"
SETX FZF_CTRL_R_OPTS	"+s -e"
SETX FZF_CTRL_T_COMMAND	"fd -t f"
SETX FZF_DEFAULT_OPTS 	"--layout=reverse --info=inline"

SETX GEM_HOME	"%%LBHOME%%\gems"
SETX PYTHONIOENCODING	utf-8
SETX RIPGREP_CONFIG_PATH	"%%LOCALAPPDATA%%\ripgreprc"
SETX RUBYOPT	"-Eutf-8"
SETX GOPATH	"%%USERPROFILE%%\go"

SETX CHECKPOINT_DISABLE			1
SETX DOTNET_CLI_TELEMETRY_OPTOUT	1

:: disabled by default, configuration can change
SETX GIT_SSH_disabled		"%%ProgramFiles%%\OpenSSH\ssh.exe"
SETX SSH_AUTH_SOCK_disabled	"/tmp/.ssh-pageant-lboulard"

SETX DOCKER_BUILDKIT		0
SETX DOCKER_TLS_VERIFY		1
SETX VAGRANT_CHECKPOINT_DISABLE	1
SETX NOMAD_ADDR			"http://elara.lan.lboulard.net:4646"

:: Obsolete <https://github.com/ScoopInstaller/Install?tab=readme-ov-file#advanced-installation>
::SETX SCOOP	"%LBHOME%%\Scoop"

SETX PIPX_BIN_DIR	"%%LOCALAPPDATA%%\pipx\bin"
SETX PIPX_HOME		"%%LOCALAPPDATA%%\pipx"

SETX XDG_CACHE_DIR	"%%LOCALAPPDATA%%\xdg\cache"
SETX XDG_CONFIG_HOME	"%%LOCALAPPDATA%%\xdg\config"
SETX XDG_DATA_HOME	"%%LOCALAPPDATA%%l\xdg\share"
SETS PLS_USER_CONF_DIR	"%%LOCALAPPDATA%%\xdg\config"

SETX WEZTERM_CONFIG_DIR		"%%XDG_CONFIG_HOMEA%%\wezterm"
SETX WEZTERM_CONFIG_FILE	"%%XDG_CONFIG_HOME%%\wezterm\wezterm.lua"


SETX YORIHISTSIZE	5000
SETX YORIHISTFILE	"%%LOCALAPPDATA%%\yori-hist.txt"


@:: Pause if not interactive
@:exit
@SET ERR=%ERRORLEVEL%
@IF DEFINED _ELEV GOTO :_elev
@SET ERRORLEVEL=0
@ECHO %cmdcmdline% | FIND /i "%~0" >NUL
@IF NOT ERRORLEVEL 1 PAUSE
@:_elev
@ENDLOCAL&EXIT /B %ERR%
