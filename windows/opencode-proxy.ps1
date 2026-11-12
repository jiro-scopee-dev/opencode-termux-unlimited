param([ValidateSet('start','stop','restart','status','logs','test')][string]$Action='status')
$ErrorActionPreference='Stop'
$base=Join-Path $env:LOCALAPPDATA 'SakiCode\proxy'
$exe=Join-Path $base 'opencode2api.exe'
$config=Join-Path $base 'config.json'
$pidPath=Join-Path $base 'gateway.pid'
$log=Join-Path $base 'gateway.log'
$errLog=Join-Path $base 'gateway-error.log'
function Get-GatewayProcess {
    if(Test-Path $pidPath){
        $id=0; [void][int]::TryParse((Get-Content $pidPath -Raw).Trim(),[ref]$id)
        if($id){
            $proc=Get-CimInstance Win32_Process -Filter "ProcessId=$id" -ErrorAction SilentlyContinue
            if($proc -and $proc.ExecutablePath -eq $exe){ return Get-Process -Id $id -ErrorAction SilentlyContinue }
        }
        Remove-Item $pidPath -Force -ErrorAction SilentlyContinue
    }
    return $null
}
function Wait-Health([int]$Seconds=60){
    for($i=0;$i -lt $Seconds;$i++){
        try { $h=Invoke-RestMethod 'http://127.0.0.1:8080/healthz' -TimeoutSec 2; if($h.status -eq 'ready'){ return $h } } catch {}
        Start-Sleep 1
    }
    return $null
}
switch($Action){
 'start' {
    if(Get-GatewayProcess){ Write-Output 'Gateway already running'; break }
    if(!(Test-Path $exe)){ throw "Gateway executable not found: $exe" }
    if(!(Test-Path $config)){ throw "Gateway config not found: $config" }
    $p=Start-Process -FilePath $exe -ArgumentList @('-config',$config) -WorkingDirectory $base -RedirectStandardOutput $log -RedirectStandardError $errLog -WindowStyle Hidden -PassThru
    $p.Id | Set-Content $pidPath
    $health=Wait-Health 90
    if(!$health){ throw "Gateway did not become ready. Review $log and $errLog" }
    Write-Output 'Gateway is ready at http://127.0.0.1:8080'
 }
 'stop' {
    $p=Get-GatewayProcess
    if($p){ Stop-Process -Id $p.Id -Force; Remove-Item $pidPath -Force -ErrorAction SilentlyContinue; Write-Output 'Gateway stopped' } else { Write-Output 'Gateway is not running' }
 }
 'restart' { & $PSCommandPath stop; & $PSCommandPath start }
 'status' {
    if(!(Get-GatewayProcess)){ Write-Output 'Gateway is not running'; break }
    try { Invoke-RestMethod 'http://127.0.0.1:8080/healthz' -TimeoutSec 5 | ConvertTo-Json -Depth 12 } catch { Write-Output 'Gateway process is running but health endpoint is unavailable' }
 }
 'logs' { if(Test-Path $log){Get-Content $log -Tail 50}; if(Test-Path $errLog){Get-Content $errLog -Tail 50} }
 'test' {
    $cfg=Get-Content $config -Raw | ConvertFrom-Json
    $headers=@{Authorization="Bearer $($cfg.server_keys[0])"}
    $models=Invoke-RestMethod 'http://127.0.0.1:8080/v1/models' -Headers $headers -TimeoutSec 60
    $models.data | Select-Object -First 20 id,owned_by | Format-Table -AutoSize
 }
}
