param([ValidateSet('start','stop','restart','status','logs','test','kill')][string]$Action='status')
$ErrorActionPreference='Stop'
$base=Join-Path $env:LOCALAPPDATA 'SakiCode\proxy'; $exe=Join-Path $base 'opencode2api.exe'; $cfg=Join-Path $base 'config.json'; $pidFile=Join-Path $base 'proxy.pid'; $log=Join-Path $base 'proxy.log'
function Get-ProxyProcess { if(Test-Path $pidFile){$id=(Get-Content $pidFile -Raw).Trim(); Get-Process -Id $id -ErrorAction SilentlyContinue} }
switch($Action){
 'start' { if(Get-ProxyProcess){'Proxy already running';break}; if(!(Test-Path $exe)){throw 'Gateway binary missing; installer could not obtain a Windows release.'}; $p=Start-Process -FilePath $exe -ArgumentList @('-config',$cfg) -WorkingDirectory $base -RedirectStandardOutput $log -RedirectStandardError (Join-Path $base 'proxy-error.log') -WindowStyle Hidden -PassThru; $p.Id | Set-Content $pidFile; Start-Sleep 3; if(!(Get-ProxyProcess)){throw "Proxy failed to start; see $log"}; 'Proxy started on 127.0.0.1:8080' }
 'stop' { $p=Get-ProxyProcess; if($p){Stop-Process -Id $p.Id -Force; Remove-Item $pidFile -Force -ErrorAction SilentlyContinue; 'Proxy stopped'}else{'Proxy is stopped'} }
 'restart' { & $PSCommandPath stop; & $PSCommandPath start }
 'status' { if(Get-ProxyProcess){'Proxy process running'}else{'Proxy process stopped'}; try{Invoke-RestMethod 'http://127.0.0.1:8080/healthz' -TimeoutSec 3 | ConvertTo-Json -Depth 8}catch{Write-Host 'Health endpoint unreachable'} }
 'logs' { if(Test-Path $log){Get-Content $log -Tail 35}; $err=Join-Path $base 'proxy-error.log'; if(Test-Path $err){Get-Content $err -Tail 20} }
 'test' { Invoke-RestMethod 'http://127.0.0.1:8080/healthz' -TimeoutSec 5 | ConvertTo-Json -Depth 8 }
 'kill' { & $PSCommandPath stop }
}
