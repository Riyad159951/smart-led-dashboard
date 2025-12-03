<#
  gen-config.ps1
  Reads .env in the project root (key=value lines) and writes config.js
  which sets window.CONFIG = { AIO_KEY: '...' }.

  Usage (PowerShell):
    .\gen-config.ps1

  This writes `config.js` (gitignored). Do NOT commit config.js.
#>

$envFile = Join-Path -Path $PSScriptRoot -ChildPath ".env"
$outFile = Join-Path -Path $PSScriptRoot -ChildPath "config.js"

if (-Not (Test-Path $envFile)) {
    Write-Host ".env not found. Creating a placeholder config.js with REPLACE token." -ForegroundColor Yellow
    $content = "window.CONFIG = { AIO_KEY: 'REPLACE_WITH_ADAFRUIT_IO_KEY' };"
    Set-Content -Path $outFile -Value $content -Encoding UTF8
    Write-Host "Wrote $outFile" -ForegroundColor Green
    exit 0
}

$lines = Get-Content $envFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }
$mapping = @{}
foreach ($l in $lines) {
    if ($l -match '^(.*?)=(.*)$') {
        $k = $matches[1].Trim()
        $v = $matches[2].Trim()
        $mapping[$k] = $v
    }
}

$aio = $mapping['AIO_KEY']
if (-not $aio) { $aio = 'REPLACE_WITH_ADAFRUIT_IO_KEY'; Write-Host "AIO_KEY not set in .env. Using placeholder." -ForegroundColor Yellow }

$safe = $aio -replace "'","\'"
$content = "window.CONFIG = { AIO_KEY: '$safe' };"
Set-Content -Path $outFile -Value $content -Encoding UTF8
Write-Host "Wrote $outFile" -ForegroundColor Green