param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Arguments)
$ErrorActionPreference='Stop'
$root=Join-Path $env:LOCALAPPDATA 'SakiCode'
$proxy=Join-Path $root 'proxy'
$manager=Join-Path $root 'bin\opencode-proxy.ps1'
$env:OPENCODE_CONFIG=Join-Path $root 'opencode.windows.jsonc'
$gatewayConfig=Join-Path $proxy 'config.json'
if(Test-Path $gatewayConfig){
    $gateway=Get-Content $gatewayConfig -Raw | ConvertFrom-Json
    $env:SAKICODE_GATEWAY_KEY=$gateway.server_keys[0]
}
$health='http://127.0.0.1:8080/healthz'
$ready=$false
try { Invoke-RestMethod $health -TimeoutSec 2 | Out-Null; $ready=$true } catch {}
if(-not $ready -and (Test-Path (Join-Path $proxy 'opencode2api.exe'))){ & $manager start; Start-Sleep 1 }
$exe=Join-Path $root 'node_modules\.bin\opencode.exe'
$cmd=Join-Path $root 'node_modules\.bin\opencode.cmd'
if(Test-Path $exe){& $exe @Arguments; exit $LASTEXITCODE}
if(Test-Path $cmd){& $cmd @Arguments; exit $LASTEXITCODE}
throw 'OpenCode executable is missing. Rerun Install-SakiCode.ps1.'
