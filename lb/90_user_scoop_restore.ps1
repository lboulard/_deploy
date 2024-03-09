$ErrorActionPreference = "Stop"

$TLSProtocol = [System.Net.SecurityProtocolType] 'Tls12, Tls13'
[ System.Net.ServicePointManager]::SecurityProtocol = $TLSProtocol

scoop config aria2-enabled False

$json = ((gc ../../scoop.json) | ConvertFrom-JSON)
ForEach($bucket in $json.buckets) {
    scoop bucket add $bucket.Name $bucket.Source
}
scoop install $json.apps.Name
if (-not $?) { throw 'Scoop failed' }
