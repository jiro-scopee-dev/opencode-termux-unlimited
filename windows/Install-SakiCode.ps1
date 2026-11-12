param([switch]$SkipOpenCode)
$ErrorActionPreference = 'Stop'
$root = Join-Path $env:LOCALAPPDATA 'SakiCode'
$bin = Join-Path $root 'bin'
$proxy = Join-Path $root 'proxy'
$bridge = Join-Path $root 'bridge'
New-Item -ItemType Directory -Force -Path $bin,$proxy,$bridge | Out-Null

if (-not $SkipOpenCode) {
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { throw 'Install Node.js LTS first (npm is required).' }
    & npm install --prefix $root opencode-ai@1.19.5
    if ($LASTEXITCODE -ne 0) { throw 'OpenCode installation failed.' }
}
$repo = 'https://github.com/leangtg123-art/opencode-termux-unlimited'
$api = Join-Path $proxy 'opencode2api.exe'
if (-not (Test-Path $api)) {
    $release = Invoke-RestMethod 'https://api.github.com/repos/jasonxu114514/opencode2api/releases/latest'
    $asset = $release.assets | Where-Object { $_.name -match 'windows_amd64\.zip$' } | Select-Object -First 1
    if ($asset) {
        $zip = Join-Path $env:TEMP 'sakicode-opencode2api.zip'
        Invoke-WebRequest $asset.browser_download_url -OutFile $zip
        Expand-Archive $zip -DestinationPath $proxy -Force
        Remove-Item $zip -Force
        $found = Get-ChildItem $proxy -Filter opencode2api.exe -Recurse | Select-Object -First 1
        if ($found -and $found.FullName -ne $api) { Copy-Item $found.FullName $api -Force }
        $example = Get-ChildItem $proxy -Filter config.example.json -Recurse | Select-Object -First 1
        if ($example -and -not (Test-Path (Join-Path $proxy 'config.json'))) { Copy-Item $example.FullName (Join-Path $proxy 'config.json') }
    }
}
if (-not (Test-Path (Join-Path $proxy 'config.json'))) { throw 'Gateway config was not installed.' }
if (-not (Test-Path $api)) { throw 'No Windows x64 gateway release asset was found.' }
$cfg = Get-Content (Join-Path $proxy 'config.json') -Raw | ConvertFrom-Json
$cfg.warp.enabled = $true
$cfg.warp.pool_size = 6
$cfg.webui.listen = '127.0.0.1:8081'
if ($cfg.webui.password -eq 'change-this-admin-password') { $cfg.webui.password = [guid]::NewGuid().ToString('N') }
$cfg | ConvertTo-Json -Depth 30 | Set-Content (Join-Path $proxy 'config.json')
Copy-Item (Join-Path $PSScriptRoot 'opencode.ps1') (Join-Path $bin 'sakicode.ps1') -Force
Copy-Item (Join-Path $PSScriptRoot 'opencode-proxy.ps1') (Join-Path $bin 'opencode-proxy.ps1') -Force
Copy-Item (Join-Path $PSScriptRoot 'opencode.windows.jsonc') (Join-Path $root 'opencode.windows.jsonc') -Force
$cmd = "@echo off`r`npowershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File `"%LOCALAPPDATA%\SakiCode\bin\sakicode.ps1`" %*`r`n"
Set-Content -Path (Join-Path $bin 'sakicode.cmd') -Value $cmd -Encoding ASCII
$userPath = [Environment]::GetEnvironmentVariable('Path','User')
$pathEntries = @($userPath -split ';' | Where-Object { $_ -and $_ -ne $bin })
[Environment]::SetEnvironmentVariable('Path', ((($pathEntries + $bin) -join ';').TrimEnd(';')), 'User')
Write-Host "Installed SakiCode in $bin. Open a new terminal and run: sakicode"
