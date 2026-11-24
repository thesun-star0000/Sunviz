$ErrorActionPreference = 'Stop'
$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
$Target = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Vegas Script Menu'
New-Item -ItemType Directory -Path $Target -Force | Out-Null
foreach ($name in @('Sunviz.cs', 'Sunviz.cs.png', 'Sunviz.ico', 'flp2json.exe')) {
    $from = Join-Path $Source $name
    if (-not (Test-Path -LiteralPath $from -PathType Leaf)) { throw "Missing file: $from" }
    Copy-Item -LiteralPath $from -Destination (Join-Path $Target $name) -Force
}
Write-Host "Sunviz installed to: $Target" -ForegroundColor Green
Write-Host 'In VEGAS, choose Tools > Scripting > Rescan Script Menu Folder, or restart VEGAS.'
Write-Host 'If an old Sunviz.dll is installed in the same menu folder, remove it to avoid duplicate entries.'
