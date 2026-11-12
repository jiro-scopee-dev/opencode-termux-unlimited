$ErrorActionPreference = 'Stop'
$raw = 'https://raw.githubusercontent.com/jiro-scopee-dev/opencode-termux-unlimited/main/windows'
$tmp = Join-Path $env:TEMP 'sakicode-setup'
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
'sakicode.ps1', 'opencode-proxy.ps1', 'opencode.windows.jsonc', 'Install-SakiCode.ps1' | ForEach-Object {
    Invoke-WebRequest -UseBasicParsing "$raw/$_" -OutFile (Join-Path $tmp $_)
}
& (Join-Path $tmp 'Install-SakiCode.ps1')
