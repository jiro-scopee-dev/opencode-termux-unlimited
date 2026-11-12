# One-command Windows installer entry point.
$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'windows\Install-SakiCode.ps1') @args
exit $LASTEXITCODE
