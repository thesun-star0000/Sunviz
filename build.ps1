# Sunviz build script for this Windows installation.
# Target: VEGAS Pro 21 / ScriptPortal.Vegas.dll
$ErrorActionPreference = 'Stop'

$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$VegasDll = 'C:\Program Files\VEGAS\Vegas Pro 21\ScriptPortal.Vegas.dll'

try {
    if (-not (Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
        throw "Sunviz project folder not found: $ProjectRoot"
    }
    Set-Location -LiteralPath $ProjectRoot

    if (-not (Test-Path -LiteralPath $VegasDll -PathType Leaf)) {
        throw "VEGAS API DLL not found: $VegasDll`nCheck the actual VEGAS installation folder."
    }

    $cscCandidates = @(
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'),
        (Join-Path $env:WINDIR 'Microsoft.NET\Framework\v4.0.30319\csc.exe')
    )
    $csc = $cscCandidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
    if (-not $csc) {
        throw 'C# compiler csc.exe was not found. Install the .NET Framework 4.8 Developer Pack.'
    }

    foreach ($required in @('Sunviz.cs', 'flp2json.exe', 'Sunviz.ico', 'Sunviz.cs.png', 'Sunviz.dll.png')) {
        if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot $required) -PathType Leaf)) {
            throw "Required project file is missing: $required"
        }
    }

    $bin = Join-Path $ProjectRoot 'bin'
    New-Item -ItemType Directory -Path $bin -Force | Out-Null
    $outputDll = Join-Path $bin 'Sunviz.dll'
    $log = Join-Path $bin 'build.log'

    Write-Host 'Building Sunviz...' -ForegroundColor Cyan
    Write-Host "Project: $ProjectRoot"
    Write-Host "VEGAS API: $VegasDll"
    Write-Host "Compiler: $csc"

    $compilerArgs = @(
        '/nologo',
        '/target:library',
        "/out:$outputDll",
        "/reference:$VegasDll",
        '/reference:System.dll',
        '/reference:System.Core.dll',
        '/reference:System.Drawing.dll',
        '/reference:System.Windows.Forms.dll',
        '/reference:System.IO.Compression.dll',
        "/win32icon:$(Join-Path $ProjectRoot 'Sunviz.ico')",
        (Join-Path $ProjectRoot 'Sunviz.cs')
    )

    $compilerOutput = & $csc @compilerArgs 2>&1
    $compilerExitCode = $LASTEXITCODE
    $compilerOutput | Out-File -LiteralPath $log -Encoding utf8

    if ($compilerExitCode -ne 0) {
        Write-Host "`nCompilation failed. Compiler output:" -ForegroundColor Red
        Get-Content -LiteralPath $log | Write-Host
        throw "Compilation failed (exit code $compilerExitCode). See $log"
    }

    Copy-Item -LiteralPath (Join-Path $ProjectRoot 'flp2json.exe') -Destination $bin -Force
    Copy-Item -LiteralPath (Join-Path $ProjectRoot 'Sunviz.ico') -Destination $bin -Force
    Copy-Item -LiteralPath (Join-Path $ProjectRoot 'Sunviz.dll.png') -Destination (Join-Path $bin 'Sunviz.dll.png') -Force

    Write-Host "`nBuild completed successfully:" -ForegroundColor Green
    Write-Host $outputDll -ForegroundColor Green
    Write-Host "Build log: $log"
}
catch {
    Write-Host "`nSUNVIZ BUILD ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
