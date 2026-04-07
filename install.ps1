#Requires -Version 5.1
<#
.SYNOPSIS
    SingulCode — Script de instalação (Windows)
.DESCRIPTION
    Compila e instala o singulcode.exe no PATH do usuário.
.PARAMETER Prefix
    Diretório de instalação (padrão: %USERPROFILE%\.singulcode\bin)
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Prefix "C:\Tools\singulcode"
#>
param(
    [string]$Prefix = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$BinaryName = "singulcode"
$RepoDir    = Split-Path -Parent $MyInvocation.MyCommand.Path
$RustDir    = Join-Path $RepoDir "rust"

# ── Helpers ──────────────────────────────────────────────────────────────────
function Write-Info    { param($m) Write-Host "[singulcode] $m" -ForegroundColor Cyan }
function Write-Success { param($m) Write-Host "[singulcode] $m" -ForegroundColor Green }
function Write-Warn    { param($m) Write-Host "[singulcode] $m" -ForegroundColor Yellow }
function Abort         { param($m) Write-Host "[singulcode] ERRO: $m" -ForegroundColor Red; exit 1 }

# ── Banner ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  +===================================+" -ForegroundColor Cyan
Write-Host "  |       SingulCode Installer        |" -ForegroundColor Cyan
Write-Host "  |   Harness de agentes de IA        |" -ForegroundColor Cyan
Write-Host "  +===================================+" -ForegroundColor Cyan
Write-Host ""

# ── Diretório de instalação ───────────────────────────────────────────────────
if ($Prefix -eq "") {
    $InstallDir = Join-Path $env:USERPROFILE ".singulcode\bin"
} else {
    $InstallDir = Join-Path $Prefix "bin"
}

# ── Verificar/instalar cargo ──────────────────────────────────────────────────
$cargo = Get-Command cargo -ErrorAction SilentlyContinue
if (-not $cargo) {
    Write-Warn "cargo nao encontrado. Instalando Rust via rustup..."
    $rustupUrl = "https://win.rustup.rs/x86_64"
    $rustupExe = Join-Path $env:TEMP "rustup-init.exe"
    Invoke-WebRequest -Uri $rustupUrl -OutFile $rustupExe -UseBasicParsing
    & $rustupExe -y --no-modify-path | Out-Null
    Remove-Item $rustupExe -ErrorAction SilentlyContinue

    # Adicionar cargo ao PATH da sessão atual
    $cargoBin = Join-Path $env:USERPROFILE ".cargo\bin"
    $env:PATH = "$cargoBin;$env:PATH"

    $cargo = Get-Command cargo -ErrorAction SilentlyContinue
    if (-not $cargo) {
        Abort "Falha ao instalar Rust. Instale manualmente em https://rustup.rs e tente novamente."
    }
    Write-Success "Rust instalado: $(cargo --version)"
} else {
    Write-Info "cargo encontrado: $(cargo --version)"
}

# ── Build ─────────────────────────────────────────────────────────────────────
Write-Info "Compilando $BinaryName em modo release..."
Write-Info "Isso pode levar alguns minutos na primeira vez."

if (-not (Test-Path $RustDir)) {
    Abort "Diretorio rust/ nao encontrado em $RepoDir. Execute o script a partir da raiz do repositorio."
}

Push-Location $RustDir
try {
    cargo build --release --bin $BinaryName
    if ($LASTEXITCODE -ne 0) { Abort "Falha na compilacao." }
} finally {
    Pop-Location
}

$BuiltBinary = Join-Path $RustDir "target\release\$BinaryName.exe"
if (-not (Test-Path $BuiltBinary)) {
    Abort "Binario nao encontrado em $BuiltBinary apos compilacao."
}

Write-Success "Build concluido: $BuiltBinary"

# ── Instalar ──────────────────────────────────────────────────────────────────
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

$Destination = Join-Path $InstallDir "$BinaryName.exe"
Copy-Item -Path $BuiltBinary -Destination $Destination -Force
Write-Success "Instalado em $Destination"

# ── Adicionar ao PATH do usuário (permanente) ─────────────────────────────────
$userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$InstallDir*") {
    [System.Environment]::SetEnvironmentVariable(
        "PATH",
        "$userPath;$InstallDir",
        "User"
    )
    # Atualizar PATH da sessão atual também
    $env:PATH = "$env:PATH;$InstallDir"
    Write-Success "Adicionado ao PATH do usuario: $InstallDir"
    Write-Warn "Reinicie o terminal para que o PATH seja reconhecido em novas sessoes."
} else {
    Write-Info "$InstallDir ja esta no PATH."
}

# ── Verificar instalação ──────────────────────────────────────────────────────
$installed = Get-Command $BinaryName -ErrorAction SilentlyContinue
Write-Host ""
if ($installed) {
    Write-Success "$BinaryName instalado com sucesso!"
} else {
    Write-Warn "Instalacao concluida. Reinicie o terminal e execute: $BinaryName"
}

Write-Host ""
Write-Host "  Proximos passos:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Configure sua chave de API:" -ForegroundColor Gray
Write-Host "     `$env:ANTHROPIC_API_KEY = 'sk-ant-...'" -ForegroundColor Cyan
Write-Host "     # ou OpenRouter (200+ modelos):" -ForegroundColor Gray
Write-Host "     `$env:OPENROUTER_API_KEY = 'sk-or-v1-...'" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Inicie o REPL interativo:" -ForegroundColor Gray
Write-Host "     $BinaryName" -ForegroundColor White
Write-Host ""
Write-Host "  3. Ou use em modo nao-interativo:" -ForegroundColor Gray
Write-Host "     $BinaryName prompt `"explique este código`"" -ForegroundColor White
Write-Host ""
Write-Host "  4. Com modelo especifico:" -ForegroundColor Gray
Write-Host "     $BinaryName --model deepseek prompt `"corrija o bug`"" -ForegroundColor White
Write-Host ""
