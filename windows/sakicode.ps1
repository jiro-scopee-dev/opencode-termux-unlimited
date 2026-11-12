param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Arguments)
$ErrorActionPreference = 'Stop'
$root = Join-Path $env:LOCALAPPDATA 'SakiCode'
$opencode = Join-Path $root 'node_modules\.bin\opencode.cmd'
if (-not (Test-Path $opencode)) { throw 'OpenCode is not installed. Run Install-SakiCode.ps1.' }
& $opencode @Arguments
exit $LASTEXITCODE
