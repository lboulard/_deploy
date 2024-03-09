$ErrorActionPreference = "Stop"

$TLSProtocol = [System.Net.SecurityProtocolType] 'Tls12, Tls13'
[ System.Net.ServicePointManager]::SecurityProtocol = $TLSProtocol

scoop config aria2-enabled False

# Required to install recent ojdkbuild8-full
scoop install lessmsi
if (-not $?) { throw 'Scoop failed' }
scoop config use_lessmsi $true
if (-not $?) { throw 'Scoop failed' }

# Required for some software like Libreoffice of flameshot
start cmd.exe -args '/c "scoop install extras/windowsdesktop-runtime-lts"' -wait -verb runas
start cmd.exe -args '/c "scoop install extras/vcredist2022"' -wait -verb runas
scoop uninstall extras/vcredist202
